
export extern main [
  --config(-c): string
    # Change where zellij looks for the configuration file [env:
    # ZELLIJ_CONFIG_FILE=]

  --config-dir: string
    # Change where zellij looks for the configuration directory [env:
    # ZELLIJ_CONFIG_DIR=]

  --debug(-d)
    # Specify emitting additional debug information

  --data-dir: string
    # Change where zellij looks for plugins

  --help(-h)
    # Print help information

  --layout(-l): string
    # Name of a predefined layout inside the layout directory or the
    # path to a layout file

  --max-panes: string
    # Maximum panes on screen, caution: opening more panes will close
    # old ones

  --session(-s): string
    # Specify name of a new session

  --version(-V)
    # Print version information
]

# Send actions to a specific session [aliases: ac]
export extern action [
  subcommand: string@"nu-complete action-subcommands"
]

# Attach to a session [aliases: a]
export extern attach [
  session_name: string@"nu-complete sessions"
    # Name of the session to attach to

  --create-background(-b)
    # Create a detached session in the background if one does not exist

  --create(-c)
    # Create a session if one does not exist

  --force-run-commands(-f)
    # If resurrecting a dead session, immediately run all its commands
    # on startup

  --help(-h)
    # Print help information

  --index: int
    # Number of the session index in the active sessions ordered creation
    # date
]

export extern convert-config [
  old_config_file: string
  --help(-h)
    # Print help information
]

export extern convert-layout [
  old_layout_file: string
  --help(-h)
    # Print help information
]

export extern convert-theme [
  old_theme_file: string
  --help(-h)
    # Print help information
]

# Delete all sessions [aliases: da]
export extern delete-all-sessions [
  --force(-f)
    # Kill the sessions if they're running before deleting them

  --help(-h)
    # Print help information

  --yes(-y)
    # Automatic yes to prompts
]

# Delete a specific session [aliases: d]
export extern delete-session [
  target_session: string@"nu-complete sessions"
    # Name of target session

  --force(-f)
    # Kill the session if it's running before deleting it

  --help(-h)
    # Print help information
]

# Edit file with default $EDITOR / $VISUAL [aliases: e]
export extern edit [
  file: string
    # Filename

  --cwd: string
    # Change the working directory of the editor

  --direction(-d): string
    # Direction to open the new pane in

  --floating(-f)
    # Open the new pane in floating mode

  --help(-h)
    # Print help information

  --in-place(-i)
    # Open the new pane in place of the current pane, temporarily
    # suspending it

  --line-number(-l): string
    # Open the file in the specified line number
]

# Print this message or the help of the given subcommand(s)
export extern help [
  subcommand: string@"nu-complete help-subcommands"
]

# Kill all sessions [aliases: ka]
export extern kill-all-sessions [
  --help(-h)
    # Print help information

  --yes(-y)
    # Automatic yes to prompts
]

  # Kill a specific session [aliases: k]
export extern kill-session [
  target_session: string@"nu-complete sessions"
    # Name of target session

  --help(-h)
    # Print help information
]

  # List active sessions [aliases: ls]
export extern list-sessions [
  --help(-h)
    # Print help information

  --no-formatting(-n)
    # Do not add colors and formatting to the list (useful for parsing)

  --short(-s)
    # Print just the session name
]

# Change the behaviour of zellij
export extern options [
  --attach-to-session
    # Whether to attach to a session specified in "session-name" if it exists [possible
    # values: true, false]

  --auto-layout
    # Whether to lay out panes in a predefined set of layouts whenever possible [possible
    # values: true, false]

  --copy-clipboard: string@"nu-complete copy-clipboard"
    # OSC52 destination clipboard [possible values: system, primary]

  --copy-command: string
    # Switch to using a user supplied command for clipboard instead of OSC52

  --copy-on-select
    # Automatically copy when selecting text (true or false) [possible values: true, false]

  --default-cwd: string
    # Set the default cwd

  --default-layout: string
    # Set the default layout

  --default-mode: string
    # Set the default mode

  --default-shell: string
    # Set the default shell

  --disable-mouse-mode
    # Disable handling of mouse events

  --help(-h)
    # Print help information

  --layout-dir: string
    # Set the layout_dir, defaults to subdirectory of config dir

  --mirror-session
    # Mirror session when multiple users are connected (true or false) [possible values: true,
    # false]

  --mouse-mode
    # Set the handling of mouse events (true or false) Can be temporarily bypassed by the
    # [SHIFT] key [possible values: true, false]

  --no-pane-frames
    # Disable display of pane frames

  --on-force-close: string@"nu-complete on-force-close"
    # Set behaviour on force close (quit or detach)

  --pane-frames
    # Set display of the pane frames (true or false) [possible values: true, false]

  --scroll-buffer-size: int


  --scrollback-editor: string
    # Explicit full path to open the scrollback editor (default is $EDITOR or $VISUAL)

  --scrollback-lines-to-serialize: int
    # Scrollback lines to serialize along with the pane viewport when serializing sessions, 0
    # defaults to the scrollback size. If this number is higher than the scrollback size, it
    # will also default to the scrollback size

  --serialization-interval: int
    # The interval at which to serialize sessions for resurrection (in seconds)

  --serialize-pane-viewport
    # Whether pane viewports are serialized along with the session, default is false [possible
    # values: true, false]

  --session-name?: string
    # The name of the session to create when starting Zellij

  --session-serialization
    # Whether sessions should be serialized to the HD so that they can be later resurrected,
    # default is true [possible values: true, false]

  --simplified-ui
    # Allow plugins to use a more simplified layout that is compatible with more fonts (true
    # or false) [possible values: true, false]

  --styled-underlines
    # Whether to use ANSI styled underlines [possible values: true, false]

  --theme: string
    # Set the default theme

  --theme-dir: string
    # Set the theme_dir, defaults to subdirectory of config dir
]

# Load a plugin [aliases: r]
export extern plugin [
  url: string
    # Plugin URL, can either start with http(s), file: or zellij

  --configuration(-c): string
    # Plugin configuration

  --floating(-f)
    # Open the new pane in floating mode

  --help(-h)
    # Print help information

  --in-place(-i)
    # Open the new pane in place of the current pane, temporarily suspending it
]

# Run a command in a new pane [aliases: r]
export extern run [
  ...command: string
    # Command to run

  --close-on-exit(-c)
    # Close the pane immediately when its command exits

  --cwd: string
    # Change the working directory of the new pane

  --direction(-d): string
    # Direction to open the new pane in

  --floating(-f)
    # Open the new pane in floating mode

  --help(-h)
    # Print help information

  --in-place(-i)
    # Open the new pane in place of the current pane, temporarily
    # suspending it

  --name(-n): string
    # Name of the new pane

  --start-suspended(-s)
    # Start the command suspended, only running after you first presses

  --width: int
    # The width if the pane is floating as a bare integer (eg. 1) or percent (eg. 10%)

  --x(-x): int
    # The x coordinates if the pane is floating as a bare integer (eg. 1) or percent (eg. 10%)

  --y(-y): int
    # The y coordinates if the pane is floating as a bare integer (eg. 1) or percent (eg. 10%)]
]

# Setup zellij and check its configuration
export extern setup [
  --check
    # Checks the configuration of zellij and displays currently used directories

  --clean
    # Disables loading of configuration file at default location, loads the defaults that
    # zellij ships with

  --dump-config
    # Dump the default configuration file to stdout

  --dump-layout: string
    # Dump specified layout to stdout

  --dump-plugins: list<string>
    # Dump the builtin plugins to DIR or "DATA DIR" if unspecified

  --dump-swap-layout: string
    # Dump the specified swap layout file to stdout

  --generate-auto-start: string
    # Generates auto-start script for the specified shell

  --generate-completion: string
    # Generates completion for the specified shell

  --help(-h)
    # Print help information
]

def "nu-complete sessions" [] {
  zellij list-sessions -n | lines | parse '{value} {description}'
}

def "nu-complete action-subcommands" [] {
  [
    { value: "clear", description: "Clear all buffers for a focused pane" }
    { value: "close-pane", description: "Close the focused pane" }
    { value: "close-tab", description: "Close the current tab" }
    { value: "dump-layout", description: "Dump current layout to stdout" }
    { value: "dump-screen", description: "Dump the focused pane to a file" }
    { value: "edit", description: "Open the specified file in a new zellij pane with your default EDITOR" }
    { value: "edit-scrollback", description: "Open the pane scrollback in your default editor" }
    { value: "focus-next-pane", description: "Change focus to the next pane" }
    { value: "focus-previous-pane", description: "Change focus to the previous pane" }
    { value: "go-to-next-tab", description: "Go to the next tab" }
    { value: "go-to-previous-tab", description: "Go to the previous tab" }
    { value: "go-to-tab", description: "Go to tab with index [index]" }
    { value: "go-to-tab-name", description: "Go to tab with name [name]" }
    { value: "half-page-scroll-down", description: "Scroll down half page in focus pane" }
    { value: "half-page-scroll-up", description: "Scroll up half page in focus pane" }
    { value: "help", description: "Print this message or the help of the given subcommand(s)" }
    { value: "launch-or-focus-plugin", description: "" }
    { value: "launch-plugin", description: "" }
    { value: "move-focus", description: "Move the focused pane in the specified direction. [right|left|up|down]" }
    { value: "move-focus-or-tab", description: "Move focus to the pane or tab (if on screen edge) in the specified direction [right| left|up|down]" }
    { value: "move-pane", description: "Change the location of the focused pane in the specified direction or rotate forwrads [right|left|up|down]" }
    { value: "move-pane-backwards", description: "Rotate the location of the previous pane backwards" }
    { value: "new-pane", description: "Open a new pane in the specified direction [right|down] If no direction is specified, will try to use the biggest available space" }
    { value: "new-tab", description: "Create a new tab, optionally with a specified tab layout and name" }
    { value: "next-swap-layout", description: "" }
    { value: "page-scroll-down", description: "Scroll down one page in focus pane" }
    { value: "page-scroll-up", description: "Scroll up one page in focus pane" }
    { value: "previous-swap-layout", description: "" }
    { value: "query-tab-names", description: "Query all tab names" }
    { value: "rename-pane", description: "Renames the focused pane" }
    { value: "rename-session", description: "" }
    { value: "rename-tab", description: "Renames the focused pane" }
    { value: "resize", description: "[increase|decrease] the focused panes area at the [left|down|up|right] border" }
    { value: "scroll-down", description: "Scroll down in focus pane" }
    { value: "scroll-to-bottom", description: "Scroll down to bottom in focus pane" }
    { value: "scroll-to-top", description: "Scroll up to top in focus pane" }
    { value: "scroll-up", description: "Scroll up in the focused pane" }
    { value: "start-or-reload-plugin", description: "" }
    { value: "switch-mode", description: "Switch input mode of all connected clients [locked|pane|tab|resize|move|search|session]" }
    { value: "toggle-active-sync-tab", description: "Toggle between sending text commands to all panes on the current tab and normal mode" }
    { value: "toggle-floating-panes", description: "Toggle the visibility of all fdirectionloating panes in the current Tab, open one if none exist" }
    { value: "toggle-fullscreen", description: "Toggle between fullscreen focus pane and normal layout" }
    { value: "toggle-pane-embed-or-floating", description: "Embed focused pane if floating or float focused pane if embedded" }
    { value: "toggle-pane-frames", description: "Toggle frames around panes in the UI" }
    { value: "undo-rename-pane", description: "Remove a previously set pane name" }
    { value: "undo-rename-tab", description: "Remove a previously set tab name" }
    { value: "write", description: "Write bytes to the terminal" }
    { value: "write-chars", description: "Write characters to the terminal" }
  ]
}

def "nu-complete help-subcommands" [] {
  [
    { value: "action", description: "Send actions to a specific session [aliases: ac]" }
    { value: "attach", description: "Attach to a session [aliases: a]" }
    { value: "convert-config", description:"" }
    { value: "convert-layout", description:"" }
    { value: "convert-theme", description:"" }
    { value: "delete-all-sessions", description: "Delete all sessions [aliases: da]" }
    { value: "delete-session", description: "Delete a specific session [aliases: d]" }
    { value: "edit", description: "Edit file with default $EDITOR / $VISUAL [aliases: e]" }
    { value: "help", description: "Print this message or the help of the given subcommand(s)" }
    { value: "kill-all-sessions", description: "Kill all sessions [aliases: ka]" }
    { value: "kill-session", description: "Kill a specific session [aliases: k]" }
    { value: "list-sessions", description: "List active sessions [aliases: ls]" }
    { value: "options", description: "Change the behaviour of zellij" }
    { value: "plugin", description: "Load a plugin [aliases: r]" }
    { value: "run", description: "Run a command in a new pane [aliases: r]" }
    { value: "setup", description: "Setup zellij and check its configuration" }
  ]
}

def "nu-complete copy-clipboard" [] {
  ["system", "primary"]
}

def "nu-complete on-force-close" [] {
  ["quit", "detach"]
}
