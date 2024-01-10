
export def background [] {
  sed -i '/"ui.background"= { bg = "background" }/d' ($env.HELIX_RUNTIME | path join 'themes' 'ayu_*.toml')
}

export def grammar [] {
  hx --grammar fetch
  hx --grammar build
}
