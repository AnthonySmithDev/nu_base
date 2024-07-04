
export-env {
  $env.FLUTTER_PID_FILE = "/tmp/flutter.pid"
}

export def run [] {
  ^flutter run --pid-file $env.FLUTTER_PID_FILE
}

export def reload [] {
  watch . --glob=**/*.dart {| op, path, new_path |
    print $"($op) ($path) ($new_path)"
    ^kill -USR1 (open $env.FLUTTER_PID_FILE)
  }
}

export def restart [] {
  watch . --glob=**/*.dart {| op, path, new_path |
    print $"($op) ($path) ($new_path)"
    ^kill -USR2 (open $env.FLUTTER_PID_FILE)
  }
}

export def dirs [] {
  ls ~/Documents/flutter | get name
}

def sync_dir [$dir: string] {
  rsync -a $dir smith@192.168.0.111:~/Documents/flutter/
}

export def sync [dir: string@dirs] {
  sync_dir $dir
  watch . --glob=**/*.dart {||
    sync_dir $dir
  }
}
