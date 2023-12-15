
export extern main [
  ...FILE : string
          # File(s) to print / concatenate. Use '-' for standard input.
  --show-all(-A)
          # Show non-printable characters (space, tab, newline, ..).
      --nonprintable-notation : string
          # Set notation for non-printable characters.
  --plain(-p)
          # # Show plain style (alias for '--style=plain').
  --language(-l) : string
          # Set the language for syntax highlighting.
  --highlight-line(-H) : string
          # Highlight lines N through M.
      --file-name : string
          # Specify the name to display for a file.
  --diff(-d)
          # Only show lines that have been added/removed/modified.
      --tabs : string
          # Set the tab width to T spaces.
      --wrap : string
          # Specify the text-wrapping mode (*auto*, never, character).
  --chop-long-lines(-S)
          # Truncate all lines longer than screen width. Alias for '--wrap=never'.
  --number(-n)
          # Show line numbers (alias for '--style=numbers').
      --color : string
          # When to use colors (*auto*, never, always).
      --italic-text : string
          # Use italics in output (always, *never*)
      --decorations : string
          # When to show the decorations (*auto*, never, always).
      --paging : string
          # Specify when to use the pager, or use `-P` to disable (*auto*, never, always).
  --map-syntax(-m) : string
          # Use the specified syntax for files matching the glob pattern ('*.cpp:C++').
      --theme : string
          # Set the color theme for syntax highlighting.
      --list-themes
          # Display all supported highlighting themes.
      --style : string
          # Comma-separated list of style elements to display (*default*, auto, full, plain, changes,
          # header, header-filename, header-filesize, grid, rule, numbers, snip).
  --line-range(-r) : string
          # Only print the lines from N to M.
  --list-languages(-L)
          # Display all supported languages.
  --help(-h)
          # Print help (see more with '--help')
  --version(-V)
          # Print version
]
