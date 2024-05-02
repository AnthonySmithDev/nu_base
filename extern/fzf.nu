
export extern main [
  #- Search
  --extended(-x)                # Extended-search mode
                                # (enabled by default; +x or --no-extended to disable)
  --exact(-e)                   # Enable Exact-match
  # -i                          # Case-insensitive match (default: smart-case match)
  # +i                          # Case-sensitive match
  --scheme : string             # Scoring scheme [default|path|history]
  --literal                     # Do not normalize latin script letters before matching
  --nth(-n) : string            # Comma-separated list of field index expressions
                                # for limiting search scope. Each can be a non-zero
                                # integer or a range expression ([BEGIN]..[END]).
  --with-nth : string           # Transform the presentation of each line using
                                # field index expressions
  --delimiter(-d) : string      # Field delimiter regex (default: AWK-style)
  # +s, --no-sort               # Do not sort the result
  --track                       # Track the current selection when the result is updated
  --tac                         # Reverse the order of the input
  --disabled                    # Do not perform search
  --tiebreak : string           # Comma-separated list of sort criteria to apply
                                # when the scores are tied [length|chunk|begin|end|index]
                                # (default: length)

  #- Interface
  --multi(-m) : string          # Enable multi-select with tab/shift-tab
  --no-mouse                    # Disable mouse
  --bind : string               # Custom key bindings. Refer to the man page.
  --cycle                       # Enable cyclic scroll
  --keep-right                  # Keep the right end of the line visible on overflow
  --scroll-off : string         # Number of screen lines to keep above or below when
                                # scrolling to the top or to the bottom (default: 0)
  --no-hscroll                  # Disable horizontal scroll
  --hscroll-off : string        # Number of screen columns to keep to the right of the
                                # highlighted substring (default: 10)
  --filepath-word               # Make word-wise movements respect path separators
  --jump-labels : string        # Label characters for jump and jump-accept

  #- Layout
  --height : string             # Display fzf window below the cursor with the given
                                # height instead of using fullscreen.
                                # If prefixed with '~', fzf will determine the height
                                # according to the input size.
  --min-height : string         # Minimum height when --height is given in percent
                                # (default: 10)
  --layout : string             # Choose layout: [default|reverse|reverse-list]
  --border : string             # Draw border around the finder
                                # [rounded|sharp|bold|block|thinblock|double|horizontal|vertical|
                                #  top|bottom|left|right|none] (default: rounded)
  --border-label : string       # Label to print on the border
  --border-label-pos : string   # Position of the border label
                                # [POSITIVE_INTEGER: columns from left|
                                #  NEGATIVE_INTEGER: columns from right][:bottom]
                                # (default: 0 or center)
  --margin : string             # Screen margin (TRBL | TB,RL | T,RL,B | T,R,B,L)
  --padding : string            # Padding inside border (TRBL | TB,RL | T,RL,B | T,R,B,L)
  --info : string               # Finder info style
                                # [default|right|hidden|inline[:SEPARATOR]|inline-right]
  --separator : string          # String to form horizontal separator on info line
  --no-separator                # Hide info line separator
  --scrollbar : string          # Scrollbar character(s) (each for main and preview window)
  --no-scrollbar                # Hide scrollbar
  --prompt : string             # Input prompt (default: '> ')
  --pointer : string            # Pointer to the current line (default: '>')
  --marker : string             # Multi-select marker (default: '>')
  --header : string             # String to print as header
  --header-lines : string       # The first N lines of the input are treated as header
  --header-first                # Print header before the prompt line
  --ellipsis : string           # Ellipsis to show when line is truncated (default: '..')

  #- Display
  --ansi                        # Enable processing of ANSI color codes
  --tabstop : string            # Number of spaces for a tab character (default: 8)
  --color : string              # Base scheme (dark|light|16|bw) and/or custom colors
  --no-bold                     # Do not use bold text

  #- History
  --history : string            # History file
  --history-size : string       # Maximum number of history entries (default: 1000)

  #- Preview
  --preview : string            # Command to preview highlighted line ({})
  --preview-window : string     # Preview window layout (default: right:50%)
                                # [up|down|left|right][,SIZE[%]]
                                # [,[no]wrap][,[no]cycle][,[no]follow][,[no]hidden]
                                # [,border-BORDER_OPT]
                                # [,+SCROLL[OFFSETS][/DENOM]][,~HEADER_LINES]
                                # [,default][,<SIZE_THRESHOLD(ALTERNATIVE_LAYOUT)]
  --preview-label : string
  --preview-label-pos : string  # Same as --border-label and --border-label-pos,
                                # but for preview window

  #- Scripting
  --query(-q) : string          # Start the finder with the given query
  --select-1(-1)                # Automatically select the only match
  --exit-0(-0)                  # Exit immediately when there's no match
  --filter(-f) : string         # Filter mode. Do not start interactive finder.
  --print-query                 # Print query as the first line
  --expect : string             # Comma-separated list of keys to complete fzf
  --read0                       # Read input delimited by ASCII NUL characters
  --print0                      # Print output delimited by ASCII NUL characters
  --sync                        # Synchronous search for multi-staged filtering
  --listen : string             # Start HTTP server to receive actions (POST /)
                                # (To allow remote process execution, use --listen-unsafe)
  --version                     # Display version information and exit
]

