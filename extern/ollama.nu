
def models [] {
  [
    { value: "llama3:8b", description: "arch llama · parameters 8B · quantization 4-bit 4.7GB" },
    { value: "llama3:70b", description: "arch llama · parameters 71B · quantization 4-bit 40GB" }
    { value: "llama2:7b", description: "arch llama · parameters 7B · quantization 4-bit 3.8GB" }
    { value: "llama2:13b", description: "arch llama · parameters 13B · quantization 4-bit 7.4GB" }
    { value: "llama2:70b", description: "arch llama · parameters 69B · quantization 4-bit 39GB" }
    { value: "gemma:7b", description: "arch gemma · parameters 9B · quantization 4-bit 5.0GB" }
    { value: "gemma:2b", description: "arch gemma · parameters 3B · quantization 4-bit 1.7GB" }
    { value: "mistral:7b", description: "arch llama · parameters 7B · quantization 4-bit 4.1GB" }
  ]
}

export extern main []

# Start ollama
export extern serve []

# Create a model from a Modelfile
export extern create []

# Show information for a model
export extern show []

# Run a model
export extern run []

# Pull a model from a registry
export extern pull [model: string@models]

# Push a model to a registry
export extern push []

# List models
export extern list []

# Copy a model
export extern cp []

# Remove a model
export extern rm []

# Help about any command
export extern help []

export def config [] {
  let name = (^ollama list | from ssv -a | get NAME | gum filter ...$in)
  ^ollama cp $name gpt-3.5-turbo
}
