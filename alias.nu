
alias zj = zellij
alias zr = zellij run
alias ze = zellij edit
alias za = zellij action
alias zka = zellij kill-all-sessions -y
alias zda = zellij delete-all-sessions -y

alias lzg = lazygit
alias lzd = lazydocker

alias remote-mouse = bash -c 'RemoteMouse > /dev/null &'
alias irc = input-remapper-control --command autoload

alias xcopy = xclip -i -selection clipboard
alias xpaste = xclip -o -selection clipboard

alias gra = git remote add
alias grr = git remote remove
alias gP = git push
alias gPF = git push --force
alias gPU = git push -u origin main
alias gp = git pull --no-edit
alias gs = git status
alias gl = git log
alias gf = git fetch
alias gaA = git add '.'
alias grH = git reset --hard
alias grM = git reset --mixed
alias grS = git reset --soft
alias glO = git log --oneline
alias gca = git commit --allow-empty --amend --only
alias gcA = git commit --allow-empty --amend --no-edit
alias gm = git merge

alias ventoyGUI = sudo ($env.VENTOY_PATH | path join VentoyGUI.x86_64)

alias docker! = ^($env.DOCKER_BIN | path join docker)
alias dockerd! = sudo ($env.DOCKER_BIN | path join dockerd)

def lvim [] {
  mkdir ~/.config/LazyNvim
  NVIM_APPNAME=LazyNvim nvim
}

alias snips = ssh snips.sh

def paste [--lang(-l): string = "plain", --key(-k): string] {
  let input = $in

  if ($key | is-not-empty) {
    let response = http get --full $"https://api.pastes.dev/($key)"
    let lang = ($response | get headers.response | where name == content-type | get value | split row ";" | first | split row "/" | last)
    ($response | get body) | bat -l $lang
  } else {
    http post --headers [Content-Type  $"text/($lang)"] https://api.pastes.dev/post $input
  }
}
