
alias la = ls -la
alias tk = taskell
alias top = btm --basic
alias fuzzy = fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"

alias fdd = fd --type dir
alias fdf = fd --type file

alias sas = apt search
alias sai = sudo apt install -y
alias sar = sudo apt remove -y
alias saa = sudo apt autoremove
alias saud = sudo apt update
alias saug = sudo apt upgrade
alias saif = sudo apt install --fix-broken
alias salu = sudo apt list --upgradable
alias sdca = sudo dpkg --configure -a

alias snap = sudo nala autopurge
alias snar = sudo nala autoremove
alias snf = sudo nala full-upgrade
alias snF = sudo nala full-upgrade -y
alias snh = sudo nala history
alias sni = sudo nala install -y
alias snl = sudo nala list
alias snp = sudo nala purge
alias snr = sudo nala remove
alias sns = sudo nala search
alias snS = sudo nala show
alias snu = sudo nala update
alias snU = sudo nala upgrade

alias pyi = uv tool install
alias jsi = pnpm install --global
alias rsi = cargo install --locked
alias goi = go install

alias tsix = timg -p sixel
alias isix = img2sixel

alias zj = zellij
alias zr = zellij run
alias ze = zellij edit
alias za = zellij action
alias zt = zellij attach

alias zls = zellij list-sessions
alias zks = zellij kill-session
alias zds = zellij delete-session
alias zkas = zellij kill-all-sessions -y
alias zdas = zellij delete-all-sessions -y

alias zf = zellij run --floating --
alias zn = zellij options --session-name

alias zna = zn a
alias znb = zn b

alias zaa = zt a
alias zab = zt b

alias zdr = zellij drop
alias zda = zellij drop --all

alias lzg = lazygit
alias lzd = lazydocker

alias mo = mods
alias mos = mods --show-last
alias mor = mods --show-last --raw
alias moc = mods --continue-last

def moe [] { mos | hx }
def mop [...rest] { wl-paste | mo ...$rest }
def moP [...rest] { wl-paste | moc ...$rest }

alias xcp = xclip -i -selection clipboard
alias xps = xclip -o -selection clipboard

alias wcp = wl-copy
alias wps = wl-paste

alias gu = gitu
alias gme = gitmoji -c
alias gcm = git_commit

alias gra = git remote add
alias grr = git remote rename
alias grR = git remote remove
alias grv = git remote --verbose
alias gP = git push origin
alias gPF = git push --force
alias gPU = git push --set-upstream origin main
alias gPO = git push --force --set-upstream origin main
alias gPD = git push --delete origin
alias gPT = git push --tags origin
alias gp = git pull --no-edit
alias gs = git status
alias gsw = git switch
alias gsc = git switch --create
alias gl = git log
alias glp = git log -p
alias gf = git fetch
alias gfa = git fetch --all
alias gfp = git fetch --prune
alias gb = git branch
alias gba = git branch --all
alias gbr = git branch --remotes
alias gbD = git branch --delete
alias gt = git tag
alias gtl = git tag --list
alias gtD = git tag --delete
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
alias gsi = git submodule init
alias gss = git submodule status
alias gsu = git submodule update
alias gsui = git submodule update --init
alias gsum = git submodule update --merge
alias gsur = git submodule update --recursive
alias gls = git ls-remote

alias vieb = browser vieb
alias brave = browser brave
alias chrome = browser chrome

alias vle = vieb --left
alias vri = vieb --right

alias bra = brave --dir a
alias brb = brave --dir b

alias dn = dir new
alias fn = file new
alias fo = file open
alias frn = file rn
alias frm = file rm
alias fmv = file mv

alias suk = srv user kanata
alias sum = srv user mouseless

alias irc = input-remapper-control --command autoload

alias asr = audiosource run

alias snips = ssh snips.sh

alias rcopy = rclone copy -P -M
