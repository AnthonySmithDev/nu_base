def current-year [] { date now | format date '%Y' }

def backup-path [...parts: string] {
    $env.HOME | path join "backup" ...$parts
}

def media-path [...parts: string] {
    "/media" | path join $env.USER ...$parts
}

def remotes [] {
    rclone listremotes | lines | each {|x| $x | str replace ':' ''}
}

const targets = {
    public: {
        users: {
            anthony: [
                {type: "photos", path: "/DCIM/Camera"},
                {type: "apps", path: "/Apps"}
            ]
        }
        copy: { include: "**" }
        password: ""
    },
    private: {
        users: {
            cosita: [
                {type: "photos", path: "/Pictures/Cosita"},
                {type: "others", path: "/Pictures/Underwear"}
            ]
        }
        copy: { include: "*.7z" }
        password: "smithg"
    }
}

def process-user-backup [
    remote: string, 
    target: string, 
    user: string, 
    dir_config: record
] {
    let backup_path = (backup-path $target $user $dir_config.type (current-year))
    mkdir $backup_path
    rclone copy --transfers=1 -P -M $"($remote):($dir_config.path)" $backup_path
}

export def phone [
    remote_server: string@remotes,
    --target(-t): string
] {
    let targets_to_process = if $target == null {
        $targets | columns
    } else {
        [$target]
    }

    for $target in $targets_to_process {
        let type_config = ($targets | get $target)
        
        for $user in ($type_config.users | columns) {
            print $"Procesando ($target)/($user)..."
            $type_config.users | get $user | each {|dir|
                process-user-backup $remote_server $target $user $dir
            }
        }
    }
}

def run [args: list] {
    let cmd = ($args | str join " ")
    print $"(ansi green_bold) ($cmd) (ansi reset)"
    nu -c $"($cmd)"
    print ""
}

def needs_compression [archive_path: string, source_dir: string] {
    if not ($archive_path | path exists) {
        return true
    }
    
    let source_last_modified = (ls -D $source_dir | get modified | math max)
    let backup_last_modified = (ls -D $archive_path | get modified | first)
    
    $source_last_modified > $backup_last_modified
}

export def compress [
    archive_path: string,
    source_dir: string,
    force: bool = false,
    --password(-p): string = ""
    --sudo(-s)
] {
    if not ($source_dir | path exists) {
        print $"La carpeta de origen ($source_dir) no existe, omitiendo."
        return
    }
    
    if (not $force) and (not (needs_compression $archive_path $source_dir)) {
        print $"No hay cambios en ($archive_path), omitiendo compresión."
        return
    }

    mut args = ["-bsp1", "-t7z", "-mhe=on", "-mx=0"]
    if $password != "" {
        $args = ($args | append $"-p($password)")
    }

    if $sudo {
        run [sudo 7z a ...$args $archive_path $source_dir]
        run [sudo chown $"($env.USER):($env.USER)" $archive_path]
    } else {
        run [7z a ...$args $archive_path $source_dir]
    }
}

export def private [
    --target(-t): string,
    --year: string,
    --force(-f),
] {
    let selected_year = ($year | default (current-year))
    let targets_to_process = if $target == null {
        [$targets.private]
    } else {
        [($targets | get $target)]
    }

    for $target_data in $targets_to_process {
        for $user in ($target_data.users | columns) {
            let photos_source_dir = (backup-path private $user photos $selected_year)
            let compressed_archive_path = (backup-path private $user photos $"($selected_year).7z")

            compress --password $target_data.password $compressed_archive_path $photos_source_dir $force
        }
    }
}

export def immich [
    --target(-t): string,
    --force(-f),
] {
    let targets_to_process = if $target == null {
        $targets | columns
    } else {
        [$target]
    }

    for $target in $targets_to_process {
        let target_data = ($targets | get $target)
        let backup_path = (backup-path $target)
        let backup_file = ($backup_path | path join "immich.7z")
        let source_path = ($env.HOME | path join "immich" $target)

        mkdir $backup_path
        compress --sudo --password $target_data.password $backup_file $source_path $force
    }
}

def disk_names [] {
    [B1 B2 B3]
}

export def copy [
    disk: string@disk_names,
    --target(-t): string
    --include(-i): string,
    --sudo(-s),
] {
    let disk_path = (media-path $disk)
    
    if not ($disk_path | path exists) {
        print $"El disco no existe en ($disk_path)"
        return
    }
    
    let targets_to_process = if $target == null {
        $targets | columns
    } else {
        [$target]
    }

    for $target in $targets_to_process {
        let target_include = ($include | default ($targets | get $target | get copy.include))
        let destination_path = ($disk_path | path join $target)

        let source_path = ($env.HOME | path join backup $target)
        if not ($source_path | path exists) {
            print $"La ruta de origen no existe: ($source_path)"
            return
        }
        mut cmd = [rclone copy -P -M --check-first --size-only --include $"'($target_include)'" $source_path $destination_path]
        if $sudo {
            $cmd = ($cmd | prepend sudo)
        }
        run $cmd
    }
}

export def clone [
    src_disk: string@disk_names,
    dst_disk: string@disk_names,
    --target(-t): string
] {
    let targets_to_process = if $target == null {
        $targets | columns
    } else {
        [$target]
    }

    for $target in $targets_to_process {
        let target_include = ($targets | get $target | get copy.include)
        let src = (media-path $src_disk $target)
        let dst = (media-path $dst_disk $target)
        run [rclone copy -P -M --check-first --size-only --include $"'($target_include)'" $src $dst]
    }
}
