
export def dev [] {
  pipx install mycli
  pipx install iredis
  pipx install litecli
  pipx install harlequin[mysql]

  pipx install httpie
  pipx install ranger-fm
}

export def core [] {
  dev
}

export def extra [] {
  pipx install dooit
  pipx install girok
  pipx install calcure
  pipx install scrapy
  pipx install http-prompt
}

def other [] {
  pipx install ipython
  pipx install asciinema
  pipx install shell-gpt
  pipx install gpt-command-line
  pipx install 'git+https://github.com/darrenburns/elia'
  pipx install 'git+https://github.com/kraanzu/termtyper'
  pipx install 'git+https://github.com/karlch/vimiv'
}
