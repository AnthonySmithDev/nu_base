
alias zj = zellij
alias zr = zellij run
alias ze = zellij edit
alias za = zellij action

alias lzg = lazygit
alias lzd = lazydocker

alias remote-mouse = bash -c 'RemoteMouse > /dev/null &'
alias irc = input-remapper-control --command autoload

alias xcopy = xclip -i -selection clipboard
alias xpaste = xclip -o -selection clipboard

alias snips = ssh snips.sh

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
alias gmc = gitmoji -c

alias ventoyGUI = sudo ($env.VENTOY_PATH | path join VentoyGUI.x86_64)
