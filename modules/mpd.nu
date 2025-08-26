
export def images [] {
  let playlist = (fd -e jpg -e jpg -e png)
  if ($playlist | is-empty) {
    return
  }
  $playlist | mpv --config-dir=~/.config/mpd --playlist=-
}

export def videos [] {
  let playlist = (fd -e mp4 -e mkv)
  if ($playlist | is-empty) {
    return
  }
  $playlist | mpv --config-dir=~/.config/mpd --playlist=-
}
