
def 'nu-complete mode' [] {
  [line, data]
}

export extern main [
  input?: string
    # Input file. jless will read from stdin if no input file is provided, or '-' is specified.
    # If a filename is provided, jless will check the extension to determine what the input format is,
    # and by default will assume JSON. Can specify input format explicitly using --json or --yaml

  --mode(-m): string@'nu-complete mode'
    # Initial viewing mode. In line mode (--mode line), opening and closing c urly and square brackets
    # are shown and all Object keys are quoted. In data mode (--mode data; the default ), closing braces,
    # commas, and quotes around Object keys are elided. The active mode can be toggled by pr essing 'm'
    # [default: data]

  --no-line-numbers(-N)
    # Don't show line numbers

  --line-numbers(-n)
    # Show "line" numbers (default). Line numbers are determined by the line number of a given line if
    # the document were pretty printed. These means there are discontinuities when viewing in data mode
    # because the lines containing closing brackets and braces aren't displayed

  --relative-line-numbers(-r)
    # Show the line number relative to the currently focused line. Relative line numbers help you use a
    # count with vertical motion commands (j k) without having to count

  --no-relative-line-numbers(-R)
    # Don't show relative line numbers (default)

  --scrolloff: int
    # Number of lines to maintain as padding between the currently focused row and the top or bottom of
    # the screen. Setting this to a large value will keep the focused in the middle of the screen
    # (except at the start or end of a file) [default: 3]

  --help(-h)
    # Print help information

  --version(-V)
    # Print version information

  --json
    # Parse input as JSON, regardless of file extension

  --yaml
    # Parse input as YAML, regardless of file extension
]
