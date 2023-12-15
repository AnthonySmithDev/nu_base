
export extern main [
  ...term: string
  --model(-m)                                  # Default model (gpt-3.5-turbo, gptggml-(-4gpt4all-j...).
  --api(-a)                                    # OpenAI compatible REST API (openai, localai).
  --http-proxy(-x)                             # HTTP proxy to use for API requests.
  --format(-f)                                 # Ask for the response to be formatted as markdown unless otherwise set.
  --raw(-r)                                    # Render output as raw text when connected to a TTY.
  --prompt(-P)                                 # Include the prompt from the arguments and stdin, truncate stdin to specified number of lines.
  --prompt-args(-p)                            # Include the prompt from the arguments in the response.
  --continue(-c)                               # Continue from the last response or a given save title.
  --continue-last(-C)                          # Continue from the last response.
  --list(-l)                                   # Lists saved conversations.
  --title(-t)                                  # Saves the current conversation with the given title.
  --delete(-d)                                 # Deletes a saved conversation with the given title or ID.
  --show(-s)                                   # Show a saved conversation with the given title or ID.
  --show-last(-S)                              # Show a the last saved conversation.
  --quiet(-q)                                  # Quiet mode (hide the spinner while loading and stderr messages for success).
  --help(-h)                                   # Show help and exit.
  --version(-v)                                # Show version and exit.
  --max-retries                                # Maximum number of times to retry API calls.
  --no-limit                                   # Turn off the client-side limit on the size of the input into the model.
  --max-tokens                                 # Maximum number of tokens in response.
  --temp                                       # Temperature (randomness) of results, from 0.0 to 2.0.
  --topp                                       # TopP, an alternative to temperature that narrows response, from 0.0 to 1.0.
  --fanciness                                  # Your desired level of fanciness.
  --status-text                                # Text to show while generating.
  --no-cache                                   # Disables caching of the prompt/response.
  --reset-settings                             # Backup your old settings file and reset everything to the defaults.
  --settings                                   # Open settings in your $EDITOR.
  --dirs                                       # Print the directories in which mods store its data
]
