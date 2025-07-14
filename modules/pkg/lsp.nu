
export def all [] {
  astro
  awk
  bash
  cpp
  cmake
  css
  dart
  deno
  docker
  docker-compose
  golang
  html
  java
  javascript
  json
  kotlin
  lua
  markdown
  php
  python
  rust
  svelte
  sql
  tailwindcss
  toml
  typescript
  vlang
  vue
  yaml
  zig
}

export def core [] {
  golang

  json
  yaml

  sql
  bash

  docker
  docker-compose

  html
  javascript
  typescript
}

export def astro [] {
  pnpm install -g @astrojs/language-server
}

export def awk [] {
  pnpm install -g "awk-language-server@>=0.5.2"
}

export def bash [] {
  pnpm install -g bash-language-server
}

export def --env cpp [] {
  bin clangd
}

export def cmake [] {
  pipx install cmake-language-server
}

export def css [] {
  pnpm install -g vscode-langservers-extracted
}

export def --env dart [] {
  bin dart
}

export def --env deno [] {
  bin deno
}

export def docker [] {
  pnpm install -g dockerfile-language-server-nodejs
}

export def docker-compose [] {
  pnpm install -g @microsoft/compose-language-service
}

export def golang [] {
  go install golang.org/x/tools/gopls@latest
  go install github.com/go-delve/delve/cmd/dlv@latest
  go install golang.org/x/tools/cmd/goimports@latest
  go install github.com/nametake/golangci-lint-langserver@latest
}

export def --env html [] {
  pnpm install -g vscode-langservers-extracted
  bin superhtml
}

export def --env java [] {
  bin jdtls
}

export def javascript [] {
  pnpm install -g typescript-language-server
}

export def json [] {
  pnpm install -g vscode-langservers-extracted
}

export def --env kotlin [] {
  bin kotlin-language-server
}

export def --env lua [] {
  bin lua-language-server
}

export def --env markdown [] {
  bin marksman
}

export def php [] {
  pnpm install -g intelephense
}

export def python [] {
  pipx install python-lsp-server[all]
  pipx install ruff-lsp
}

export def rust [] {
  rustup component add rust-analyzer
}

export def svelte [] {
  pnpm install -g svelte-language-server
  pnpm install -g typescript-svelte-plugin
}

export def sql [] {
  pnpm install -g sql-language-server
}

export def tailwindcss [] {
  pnpm install -g @tailwindcss/language-server
}

export def toml [] {
  cargo install taplo-cli --locked
}

export def typescript [] {
  pnpm install -g typescript-language-server typescript
}

export def --env vlang [] {
  bin v-analyzer
}

export def vue [] {
  pnpm install -g @vue/language-server
}

export def yaml [] {
  pnpm install -g yaml-language-server@next
}

export def --env zig [] {
  bin zls
}

export def hyprlang [] {
  go install github.com/hyprland-community/hyprls/cmd/hyprls@latest
}
