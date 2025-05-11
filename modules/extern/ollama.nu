
def "nu-complete ollama-ls-name" [] {
  ^ollama ls | from ssv | get name
}

def "nu-complete ollama-ps-name" [] {
  ^ollama ps | from ssv | get name
}

export extern main []

# Start ollama
export extern serve []

# Create a model from a Modelfile
export extern create []

# Show information for a model
export extern show [model: string@'nu-complete ollama-ls-name']

# Run a model
export extern run [model: string@'nu-complete ollama-ls-name', prompt?: string]

# Stop a running model
export extern stop [model: string@'nu-complete ollama-ps-name']

# Pull a model from a registry
export extern pull [model: string]

# Push a model to a registry
export extern push [model: string]

# List models
export extern list []

# List running models
export extern ps []

# Copy a model
export extern cp [src: string@'nu-complete ollama-ls-name', dst: string]

# Remove a model
export extern rm [...models: string@'nu-complete ollama-ls-name']

# Help about any command
export extern help []
