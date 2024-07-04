
# ripgrep 14.0.3 (rev 67ad9917ad)

export extern rg [
  PATTERN?: string                      # A regular expression used for searching.
  ...PATH: path                        # A file or directory to search.

  #- INPUT OPTIONS
  --regexp(-e) : string                # A pattern to search for.
  --file(-f) : string                  # Search for patterns from the given file.
  --pre : string                       # Search output of COMMAND for each PATH.
  --pre-glob : string                  # Include or exclude files from a preprocessor.
  --search-zip(-z)                     # Search in compressed files.

  #- SEARCH OPTIONS
  --case-sensitive(-s)                 # Search case sensitively (default).
  --crlf                               # Use CRLF line terminators (nice for Windows).
  --dfa-size-limit : string            # The upper size limit of the regex DFA.
  --encoding(-E) : string              # Specify the text encoding of files to search.
  --engine : string                    # Specify which regex engine to use.
  --fixed-strings(-F)                  # Treat all patterns as literals.
  --ignore-case(-i)                    # Case insensitive search.
  --invert-match(-v)                   # Invert matching.
  --line-regexp(-x)                    # Show matches surrounded by line boundaries.
  --max-count(-m) : string             # Limit the number of matching lines.
  --mmap                               # Search with memory maps when possible.
  --multiline(-U)                      # Enable searching across multiple lines.
  --multiline-dotall                   # Make '.' match line terminators.
  --no-unicode                         # Disable Unicode mode.
  --null-data                          # Use NUL as a line terminator.
  --pcre2(-P)                          # Enable PCRE2 matching.
  --regex-size-limit : string          # The size limit of the compiled regex.
  --smart-case(-S)                     # Smart case search.
  --stop-on-nonmatch                   # Stop searching after a non-match.
  --text(-a)                           # Search binary files as if they were text.
  --threads(-j) : string               # Set the approximate number of threads to use.
  --word-regexp(-w)                    # Show matches surrounded by word boundaries.
  --auto-hybrid-regex                  # (DEPRECATED) Use PCRE2 if appropriate.
  --no-pcre2-unicode                   # (DEPRECATED) Disable Unicode mode for PCRE2.

  #- FILTER OPTIONS
  --binary                             # Search binary files.
  --follow(-L)                         # Follow symbolic links.
  --glob(-g) : string                  # Include or exclude file paths.
  --glob-case-insensitive              # Process all glob patterns case insensitively.
  --hidden(-.)                         # Search hidden files and directories.
  --iglob : string                     # Include/exclude paths case insensitively.
  --ignore-file : string               # Specify additional ignore files.
  --ignore-file-case-insensitive       # Process ignore files case insensitively.
  --max-depth(-d) : string             # Descend at most NUM directories.
  --max-filesize : string              # Ignore files larger than NUM in size.
  --no-ignore                          # Don't use ignore files.
  --no-ignore-dot                      # Don't use .ignore or .rgignore files.
  --no-ignore-exclude                  # Don't use local exclusion files.
  --no-ignore-files                    # Don't use --ignore-file arguments.
  --no-ignore-global                   # Don't use global ignore files.
  --no-ignore-parent                   # Don't use ignore files in parent directories.
  --no-ignore-vcs                      # Don't use ignore files from source control.
  --no-require-git                     # Use .gitignore outside of git repositories.
  --one-file-system                    # Skip directories on other file systems.
  --type(-t) : string                  # Only search files matching TYPE.
  --type-not(-T) : string              # Do not search files matching TYPE.
  --type-add : string                  # Add a new glob for a file type.
  --type-clear : string                # Clear globs for a file type.
  --unrestricted(-u)                   # Reduce the level of "smart" filtering.

  #- OUTPUT OPTIONS
  --after-context(-A) : string         # Show NUM lines after each match.
  --before-context(-B) : string        # Show NUM lines before each match.
  --block-buffered                     # Force block buffering.
  --byte-offset(-b)                    # Print the byte offset for each matching line.
  --color : string                     # When to use color.
  --colors : string                    # Configure color settings and styles.
  --column                             # Show column numbers.
  --context(-C) : string               # Show NUM lines before and after each match.
  --context-separator : string         # Set the separator for contextual chunks.
  --field-context-separator : string   # Set the field context separator.
  --field-match-separator : string     # Set the field match separator.
  --heading                            # Print matches grouped by each file.
  --help(-h)                           # Show help output.
  --hostname-bin : string              # Run a program to get this system's hostname.
  --hyperlink-format : string          # Set the format of hyperlinks.
  --include-zero                       # Include zero matches in summary output.
  --line-buffered                      # Force line buffering.
  --line-number(-n)                    # Show line numbers.
  --no-line-number(-N)                 # Suppress line numbers.
  --max-columns(-M) : string           # Omit lines longer than this limit.
  --max-columns-preview                # Show preview for lines exceeding the limit.
  --null(-0)                           # Print a NUL byte after file paths.
  --only-matching(-o)                  # Print only matched parts of a line.
  --path-separator : string            # Set the path separator for printing paths.
  --passthru                           # Print both matching and non-matching lines.
  --pretty(-p)                         # Alias for colors, headings and line numbers.
  --quiet(-q)                          # Do not print anything to stdout.
  --replace(-r) : string               # Replace matches with the given text.
  --sort : string                      # Sort results in ascending order.
  --sortr : string                     # Sort results in descending order.
  --trim                               # Trim prefix whitespace from matches.
  --vimgrep                            # Print results im a vim compatible format.
  --with-filename(-H)                  # Print the file path with each matching line.
  --no-filename(-I)                    # Never print the path with each matching line.
  --sort-files                         # (DEPRECATED) Sort results by file path.

  #- OUTPUT MODES
  --count(-c)                          # Show count of matching lines for each file.
  --count-matches                      # Show count of every match for each file.
  --files-with-matches(-l)             # Print the paths with at least one match.
  --files-without-match                # Print the paths that contain zero matches.
  --json                               # Show search results in a JSON Lines format.

  #- LOGGING OPTIONS
  --debug                              # Show debug messages.
  --no-ignore-messages                 # Suppress gitignore parse error messages.
  --no-messages                        # Suppress some error messages.
  --stats                              # Print statistics about the search.
  --trace                              # Show trace messages.

  #- OTHER BEHAVIORS
  --files                              # Print each file that would be searched.
  --generate : string                  # Generate man pages and completion scripts.
  --no-config                          # Never read configuration files.
  --pcre2-version                      # Print the version of PCRE2 that ripgrep uses.
  --type-list                          # Show all supported file types.
  --version(-V)                        # Print ripgrep's version.
]
