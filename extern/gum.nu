
export extern main [
  --help(-h)    # Show context-sensitive help.
  --version(-v) # Print the version number
]

# Choose an option from a list of choices
export extern choose [
  ...prompt: any
]

# Ask a user to confirm an action
export extern confirm [
  ...prompt: any
]

# Pick a file from a folder
export extern file []

# Filter items from a list
export extern filter []

# Format a string using a template
export extern format []

# Prompt for some input
export extern input []

# Join text vertically or horizontally
export extern join []

# Scroll through a file
export extern pager []

# Display spinner while running a command
export extern spin []

# Apply coloring, borders, spacing to text
export extern style []

# Render a table of data
export extern table []

# Prompt for long-form text
export extern write []

# Log messages to output
export extern log []
