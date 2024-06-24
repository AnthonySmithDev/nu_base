
export extern fd [
  pattern?: string                    # the search pattern (a regular expression, unless '--glob' is used; optional)
  ...path: string                     # the root directories for the filesystem search (optional)
  --hidden(-H)                        # Search hidden files and directories
  --no-ignore(-I)                     # Do not respect .(git|fd)ignore files
  --case-sensitive(-s)                # Case-sensitive search (default: smart case)
  --ignore-case(-i)                   # Case-insensitive search (default: smart case)
  --glob(-g)                          # Glob-based search (default: regular expression)
  --absolute-path(-a)                 # Show absolute instead of relative paths
  --list-details(-l)                  # Use a long listing format with file metadata
  --follow(-L)                        # Follow symbolic links
  --full-path(-p)                     # Search full abs. path (default: filename only)
  --max-depth(-d) : string            # Set maximum search depth (default: none)
  --exclude(-E) : string              # Exclude entries that match the given glob pattern
  --type(-t) : string                 # Filter by type: file (f), directory (d), symlink (l),
                                      # executable (x), empty (e), socket (s), pipe (p)
  --extension(-e) : string            # Filter by file extension
  --size(-S) : string                 # Limit results based on the size of files
      --changed-within : string       # Filter by file modification time (newer than)
      --changed-before : string       # Filter by file modification time (older than)
  --owner(-o) : string                # Filter by owning user and/or group
  --exec(-x) : string              # Execute a command for each search result
  --exec-batch(-X) : string        # Execute a command with all search results at once
  --color(-c) : string                # When to use colors [default: auto] [possible values: auto,
                                      # always, never]
  --help(-h)                          # Print help (see more with '--help')
  --version(-V)                       # Print version
]
