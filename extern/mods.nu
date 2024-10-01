
def models [] {
  mut models = []
  for api in (open ~/.config/mods/mods.yml | get apis | transpose key value) {
    for model in ($api.value.models | columns) {
      $models = ($models | append {value: $model, description: $api.key})
    }
  }
  return $models
}

def apis [] {
  [openai, localai]
}

def roles [] {
  mods --list-roles | lines | split column ' ' roles | get roles
}

def themes [] {
  [charm, catppuccin, dracula base16]
}

export extern main [
  ...term: string
  --model(-m): string@models # Default model (gpt-3.5-turbo, gpt-4, ggml-gpt4all-j...).
  --ask-model(-M)            # Ask which model to use with an interactive prompt.
  --api(-a): string@apis     # OpenAI compatible REST API (openai, localai).
  --http-proxy(-x)           # HTTP proxy to use for API requests.
  --format(-f)               # Ask for the response to be formatted as markdown unless otherwise set.
  --format-as
  --raw(-r)                  # Render output as raw text when connected to a TTY.
  --prompt(-P)               # Include the prompt from the arguments and stdin, truncate stdin to specified number of lines.
  --prompt-args(-p)          # Include the prompt from the arguments in the response.
  --continue(-c)             # Continue from the last response or a given save title.
  --continue-last(-C)        # Continue from the last response.
  --list(-l)                 # Lists saved conversations.
  --title(-t)                # Saves the current conversation with the given title.
  --delete(-d)               # Deletes a saved conversation with the given title or ID.
  --delete-older-than        # Deletes all saved conversations older than the specified duration. Valid units are: ns, us, µs, μs, ms, s, m, h, d, w, mo, and y.
  --show(-s)                 # Show a saved conversation with the given title or ID.
  --show-last(-S)            # Show the last saved conversation.
  --quiet(-q)                # Quiet mode (hide the spinner while loading and stderr messages for success).
  --help(-h)                 # Show help and exit.
  --version(-v)              # Show version and exit.
  --max-retries              # Maximum number of times to retry API calls.
  --no-limit                 # Turn off the client-side limit on the size of the input into the model.
  --max-tokens               # Maximum number of tokens in response.
  --word-wrap                # Wrap formatted output at specific width (default is 80)
  --temp                     # Temperature (randomness) of results, from 0.0 to 2.0.
  --stop                     # Up to 4 sequences where the API will stop generating further tokens.
  --topp                     # TopP, an alternative to temperature that narrows response, from 0.0 to 1.0.
  --fanciness                # Your desired level of fanciness.
  --status-text              # Text to show while generating.
  --no-cache                 # Disables caching of the prompt/response.
  --reset-settings           # Backup your old settings file and reset everything to the defaults.
  --settings                 # Open settings in your $EDITOR.
  --dirs                     # Print the directories in which mods store its data.
  --role: string@roles       # System role to use.
  --list-roles               # List the roles defined in your configuration file
  --theme: string@themes     # Theme to use in the forms. Valid units are: 'charm', 'catppuccin', 'dracula', and 'base16'
]
