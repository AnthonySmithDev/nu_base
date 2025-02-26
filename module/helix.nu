
export def grammar [] {
  hx --grammar fetch
  hx --grammar build
}

export def ts [] {
  # nushell
  http get https://raw.githubusercontent.com/nushell/tree-sitter-nu/main/queries/nu/highlights.scm | save -f ($env.HELIX_RUNTIME | path join queries/nu/highlights.scm)
  http get https://raw.githubusercontent.com/nushell/tree-sitter-nu/main/queries/nu/injections.scm | save -f ($env.HELIX_RUNTIME | path join queries/nu/injections.scm)

  # sql
  http get https://raw.githubusercontent.com/DerekStride/tree-sitter-sql/main/queries/highlights.scm | save -f ($env.HELIX_RUNTIME | path join queries/sql/injections.scm)
  http get https://raw.githubusercontent.com/DerekStride/tree-sitter-sql/main/queries/indents.scm | save -f ($env.HELIX_RUNTIME | path join queries/sql/indents.scm)
}

