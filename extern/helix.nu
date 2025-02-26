
# USAGE
# hx [FLAGS] [files]...

# VERSION
# helix-term 23.10 (f6021dd0)
# A post-modern text editor.

def "nu-complete category" [] {
  ["all" "clipboard" "languages"]
}

def "nu-complete grammar" [] {
  ["fetch" "build"]
}

export extern hx [
# ARGS
  ...files: string                            #Sets the input file to use, position can also be specified via file[:row[:col]]

# FLAGS
  --help(-h)                                  # Prints help information
  --tutor                                     # Loads the tutorial
  --health: string@"nu-complete category"     # Checks for potential errors in editor setup
                                              # CATEGORY can be a language or one of 'clipboard', 'languages'
                                              # or 'all'. 'all' is the default if not specified.
  --grammar(-g): string@"nu-complete grammar" # Fetches or builds tree-sitter grammars listed in languages.toml
  --config(-c): string                        # Specifies a file to use for configuration
  -v                                          # Increases logging verbosity each use for up to 3 times
  --log: string                               # Specifies a file to use for logging
                                              # (default file: ~/.cache/helix/helix.log)
  --version(-V)                               # Prints version information
  --vsplit                                    # Splits all given files vertically into different windows
  --hsplit                                    # Splits all given files horizontally into different windows
  --working-dir(-w): string                   # Specify an initial working directory
  # +N                                        # Open the first given file at line number N
]
