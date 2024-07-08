
alias la = ls -la

alias zj = zellij
alias zr = zellij run
alias ze = zellij edit
alias za = zellij action
alias zk = zellij kill-session
alias zd = zellij delete-session
alias zka = zellij kill-all-sessions -y
alias zda = zellij delete-all-sessions -y

alias zn = zellij options --session-name
alias zat = zellij attach
alias zle = zn left
alias zri = zn right

alias lzg = lazygit
alias lzd = lazydocker

alias remote-mouse = bash -c 'RemoteMouse > /dev/null &'
alias irc = input-remapper-control --command autoload

alias xcopy = xclip -i -selection clipboard
alias xpaste = xclip -o -selection clipboard

alias wcopy = wl-copy
alias wpaste = wl-paste

alias gra = git remote add
alias grr = git remote remove
alias gP = git push
alias gPF = git push --force
alias gPU = git push -u origin main
alias gPFU = git push -f -u origin main
alias gp = git pull --no-edit
alias gs = git status
alias gl = git log
alias glp = git log -p
alias gf = git fetch
alias gfa = git fetch --all
alias gb = git branch
alias gba = git branch --all
alias gbl = git blame
alias gd = git diff
alias ga = git add
alias gaA = git add .
alias grH = git reset --hard
alias grM = git reset --mixed
alias grS = git reset --soft
alias glO = git log --oneline
alias gca = git commit --allow-empty --amend --only
alias gcA = git commit --allow-empty --amend --no-edit
alias gm = git merge
alias gc = git clone
alias gi = git init
alias gu = gitu

alias gcm = git_commit
alias gme = gitmoji -c

alias docker! = ^($env.DOCKER_BIN | path join docker)
alias dockerd! = sudo ($env.DOCKER_BIN | path join dockerd)

alias ventoyGUI = sudo ($env.VENTOY_PATH | path join VentoyGUI.x86_64)

alias snips = ssh snips.sh

alias vieb = browser vieb
alias brave = browser brave
alias chrome = browser chrome

alias vle = vieb --left
alias vri = vieb --right

alias ble = brave --left
alias bri = brave --right

alias dn = dir new
alias fn = file new
alias fo = file open
alias frn = file rn
alias frm = file rm
alias fmv = file mv

alias ar = audiosource run

alias suk = srv user kanata
