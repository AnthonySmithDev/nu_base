
export def images [--sort] {
  let find = (fd -e jpg -e jpg -e png)
  if ($find | is-empty) {
    return
  }
  mut playlist = []
  if $sort {
    $playlist = ($find | lines | du ...$in | sort-by -r physical)
  } else {
    $playlist = ($find | lines)
  }
  $playlist | to text | mpv --config-dir=~/.config/mpd --playlist=-
}

export def videos [--sort] {
  let find = (fd -e mp4 -e mkv)
  if ($find | is-empty) {
    return
  }
  mut playlist = []
  if $sort {
    $playlist = ($find | lines | du ...$in | sort-by -r physical)
  } else {
    $playlist = ($find | lines)
  }
  $playlist | to text | mpv --config-dir=~/.config/mpd --playlist=-
}
