
export-env {
    $env.DVD_MOUNT = ($env.HOME | path join dvd mount)
    $env.DVD_RESCUE = ($env.HOME | path join dvd rescue)
    $env.DVD_COPY = ($env.HOME | path join dvd copy)
    $env.DVD_REPAIR = ($env.HOME | path join dvd repair)
    $env.DVD_CONVERT = ($env.HOME | path join dvd convert)
}

export def create-dirs [] {
    mkdir $env.DVD_MOUNT
    mkdir $env.DVD_RESCUE
    mkdir $env.DVD_COPY
    mkdir $env.DVD_REPAIR
    mkdir $env.DVD_CONVERT
}

export def disc [
    project: string
    --mount(-m),
    --umount(-u),
] {
    let mount_point = ($env.DVD_MOUNT | path join disc $project)

    if $mount {
        sudo mkdir -p $mount_point
        sudo mount -t udf -o ro /dev/sr0 $mount_point
    }
    if $umount {
       sudo umount $mount_point
       sudo rm $mount_point
    }
    ls /mnt/dvd
}

export def rescue [ project: string ] {
    let rescue_dir = ($env.DVD_RESCUE | path join $project)
    let iso = ($rescue_dir | path join disc.iso)
    let log = ($rescue_dir | path join disc.log)

    mkdir $rescue_dir
    sudo ddrescue -v -r3 /dev/sr0 $iso $log
}

export def iso [
    project: string
    --mount(-m),
    --umount(-u),
] {
    let disc_iso = ($env.DVD_RESCUE | path join $project disc.iso)
    let mount_point = ($env.DVD_MOUNT | path join iso $project)

    if $mount  {
        sudo mkdir -p $mount_point
        sudo mount -o loop -o ro $disc_iso $mount_point
    }
    if $umount {
       sudo umount $mount_point
       sudo rm $mount_point
    }
    ls /mnt/iso
}

export def copy [ project: string ] {
    let mount_point = ($env.DVD_MOUNT | path join disc $project)
    let copy_dir = ($env.DVD_COPY | path join $project)
    mkdir $copy_dir

    rclone copy --progress $mount_point $copy_dir
}

export def repair [ project: string ] {
    let mount_point = ($env.DVD_MOUNT | path join iso $project)
    let repair_dir = ($env.DVD_REPAIR | path join $project)
    mkdir $repair_dir

    let vobs = glob ($"($mount_point)/**/*.VOB" | into glob)
    for $input in $vobs {
        let output = ($repair_dir | path join ($input | path basename))
        try {
            mencoder -oac pcm -ovc copy -forceidx $input -o $output
        }
    }
}

export def convert [ input: path ] {
    let output_dir = ($env.HOME | path join convert)
    mkdir $output_dir

    let files = if ($input | path type) == "dir" {
        fd --glob "*_01_*.VOB" $input | lines
    } else {
        if ($input | str ends-with ".VOB") {
            [$input]
        } else {
            []
        }
    }

    if ($files | is-empty) {
        print $"No valid VOB files found in (if ($input | path type) == 'dir' {'directory'} else {'file'})"
        return
    }

    for $input in $files {
        let stem = ($input | path parse | get stem)
        let output = ($output_dir | path join $"($stem).mp4")
        let output_repaired = ($output_dir | path join $"($stem).VOB")

        try {

            # ffmpeg -fflags +discardcorrupt -i $input -c:v libx264 -crf 18 -c:a aac -ignore_unknown -vsync drop -map_metadata 0 $output
            
            # ffmpeg -err_detect explode -fflags +discardcorrupt -i $input -c:v libx264 -crf 18 -c:a aac -strict experimental -max_muxing_queue_size 9999 $output

            # ffmpeg -err_detect ignore_err -i $input -c:v libx264 -crf 18 -c:a aac -ignore_unknown $output
        }
    }
}
