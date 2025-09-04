
export def images [--sort(-s)] {
  mut playlist = (ls | find -n .jpg .png)
  if ($playlist | is-empty) {
    return
  }
  if $sort {
    $playlist = ($playlist | sort-by -r size)
  }
  $playlist | get name | to text | mpv --save-position-on-quit --config-dir=~/.config/mpd --playlist=-
}

export def videos [--sort(-s)] {
  mut playlist = (ls | find -n .mp4 .mkv)
  if ($playlist | is-empty) {
    return
  }
  if $sort {
    $playlist = ($playlist | sort-by -r size)
  }
  $playlist | get name | to text | mpv --save-position-on-quit --config-dir=~/.config/mpd --playlist=-
}
