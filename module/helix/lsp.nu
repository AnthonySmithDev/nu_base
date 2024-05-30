
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

export def core [] {
  json
  yaml
  docker
  compose

  html
  javascript
  typescript

  bash
  sql
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

export def tailwindcss [] {
  npm i -g @tailwindcss/language-server
}

export def bash [] {
  npm install -g bash-language-server
}

export def sql [] {
  npm install -g sql-language-server
}

export def cmake [] {
  pipx install cmake-language-server
}

export def docker [] {
  npm install -g dockerfile-language-server-nodejs
}

export def compose [] {
  npm install -g @microsoft/compose-language-service
}

export def rust [] {
  rustup component add rust-analyzer
}

export def golang [] {
  go install golang.org/x/tools/gopls@latest
}

export def svelte [] {
  npm install -g svelte-language-server
  npm install -g typescript-svelte-plugin
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
  npm install -g yaml-language-server@next
}

export def toml [] {
  cargo install taplo-cli --locked
}
