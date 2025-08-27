
export def image [path: path] {
  use magick.nu
  magick preload $path
}

export def video [path: path] {
  use ffmpeg.nu
  ffmpeg preload $path
}
