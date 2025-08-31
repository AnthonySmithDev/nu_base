
export def image [...paths: path] {
  use magick.nu
  $paths | each {|path| try { magick preload $path }}
}

export def video [...paths: path] {
  use ffmpeg.nu
  $paths | each {|path| try { ffmpeg preload $path }}
}

export def list [] {
  (ls /tmp/preload/image/) | append (ls /tmp/preload/video/)
}

export def remove [] {
  rm -rfp /tmp/preload/image/*
  rm -rfp /tmp/preload/video/*
}
