
export module lsp.nu

export def background [] {
  sed -i '/"ui.background"= { bg = "background" }/d' ($env.HELIX_RUNTIME | path join 'themes' 'ayu_*.toml')
}

export def grammar [] {
  hx --grammar fetch
  hx --grammar build
}

export def ts [] {
  http get https://raw.githubusercontent.com/nushell/tree-sitter-nu/main/queries/nu/highlights.scm | save -f ($env.HELIX_RUNTIME | path join queries/nu/highlights.scm)
  http get https://raw.githubusercontent.com/nushell/tree-sitter-nu/main/queries/nu/injections.scm | save -f ($env.HELIX_RUNTIME | path join queries/nu/injections.scm)
}
