
export def install [] {
  php
  python
  javascript
  typescript
  bash
  cmake
  docker
  c
  rust
  golang
  svelte
  html
  css
  json
  yaml
  toml
}

export def php [] {
  npm install -g intelephense
}

export def python [] {
  pipx install python-lsp-server[all]
  pipx install ruff-lsp
}

export def javascript [] {
  npm install -g typescript-language-server
}

export def typescript [] {
  npm install -g typescript-language-server typescript
}

export def bash [] {
  npm install -g bash-language-server
}

export def cmake [] {
  pipx install cmake-language-server
}

export def docker [] {
  npm install -g dockerfile-language-server-nodejs
}

export def rust [] {
  rustup component add rust-analyzer
}

export def golang [] {
  go install golang.org/x/tools/gopls@latest
}

export def svelte [] {
  npm install -g svelte-language-server
}

export def html [] {
  npm install -g vscode-langservers-extracted
}

export def css [] {
  npm install -g vscode-langservers-extracted
}

export def json [] {
  npm install -g vscode-langservers-extracted
}

export def yaml [] {
  npm install -g yaml-language-server
}

export def toml [] {
  cargo install taplo-cli --locked
}
