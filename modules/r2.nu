
export def --wrapped ollama [...rest] {
  $env.OLLAMA_HOST = "r2v2:11434"
  ^ollama ...$rest
}

export def "ollama config" [] {
  let name = (^ollama list | from ssv -a | get NAME | gum filter ...$in)
  ^ollama cp $name gpt-3.5-turbo
}
