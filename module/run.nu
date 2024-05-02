
export def nano-work-server [] {
  ^nano-work-server --gpu 0:0 -l 0.0.0.0:7076
}

export def ollama-serve [] {
   OLLAMA_HOST="0.0.0.0:11434" ^ollama serve
}
