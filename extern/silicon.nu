
# USAGE
# silicon [FLAGS] [OPTIONS] --output <PATH> [FILE]

# VERSION
# silicon 0.5.1

def "nu-complete list-fonts" [] {
  silicon --list-fonts | lines
}

def "nu-complete list-themes" [] {
  silicon --list-themes | lines
}

export extern main [

# ARGS
  file?: string                               # File to read. If not set, stdin will be use

# FLAGS
  --config-file                               # Show the path of silicon config file
  --from-clipboard                            # Read input from clipboard
  --help(-h)                                  # Prints help information
  --list-fonts                                # List all available fonts in your system
  --list-themes                               # List all themes
  --no-line-number                            # Hide the line number
  --no-round-corner                           # Don't round the corner
  --no-window-controls                        # Hide the window controls
  --to-clipboard(-c)                          # Copy the output image to clipboard
  --version(-V)                               # Prints version information

# OPTIONS
  --background(-b): string                    # Background color of the image [default: #aaaaff]
  --background-image: string                  # Background image
  --build-cache: string                       # build syntax definition and theme cache
  --font(-f): string@"nu-complete list-fonts" # The fallback font list. eg. 'Hack; SimSun=31'
  --highlight-lines: string                   # Lines to high light. rg. '1-3; 4'
  --language(-l): string                      # The language for syntax highlighting. You can use full name ("Rust") or file extension ("rs")
  --line-offset: int                          # Line number offset [default: 1]
  --line-pad: int                             # Pad between lines [default: 2]
  --output(-o): string                        # Write output image to specific location instead of cwd
  --pad-horiz: int                            # Pad horiz [default: 80]
  --pad-vert: int                             # Pad vert [default: 100]
  --shadow-blur-radius: int                   # Blur radius of the shadow. (set it to 0 to hide shadow) [default: 0]
  --shadow-color: string                      # Color of shadow [default: #555555]
  --shadow-offset-x: int                      # Shadow's offset in X axis [default: 0]
  --shadow-offset-y: int                      # Shadow's offset in Y axis [default: 0]
  --tab-width: int                            # Tab width [default: 4]
  --theme: string@"nu-complete list-themes"   # The syntax highlight theme. It can be a theme name or path to a .tmTheme file [default: Dracula]
]
