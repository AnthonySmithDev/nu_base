
export def lunarvim [] {
  (curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh) | bash
  lvim
}

export def nvchad [] {
  git clone --depth 1 https://github.com/NvChad/NvChad ~/.config/nvim
  nvim
}

export def spacevim [] {
  curl -sLf https://spacevim.org/install.sh | bash
  nvim
}

export def astronvim [] {
  git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim
  nvim
}

export def lazyvim [] {
  git clone https://github.com/LazyVim/starter ~/.config/nvim
}
