
def git-commit [...rest: string] {
  git commit -m ($rest | str join ' ')
}

def --wrapped git-clone-cd [repo: string, dir?: string, ...args: string] {
  let repo_name = ($repo | split row "/" | last | str replace ".git" "")
  git clone $repo ($dir | default $repo_name) ...$args
}

def git-show-history [filename: string] {
  if not ($filename | path exists) {
    return
  }

  let logs = (git log --pretty=format:"%h" -- $filename | lines)
  for $commit in $logs {
    git show $"($commit):($filename)" | bat -l go
  }
}

export def --wrapped fzf-vim [...args] {
  let bind_vim = 'j:down,k:up,/:show-input+unbind(j,k,/)'
  let bind_enter = 'enter,esc,ctrl-c:transform:
        if [[ $FZF_INPUT_STATE = enabled ]]; then
          echo "rebind(j,k,/)+hide-input"
        elif [[ $FZF_KEY = enter ]]; then
          echo accept
        else
          echo abort
        fi'
  $in | fzf --no-input --bind $bind_vim --bind $bind_enter ...$args
}

def git-diff-history [filename: string] {
  if not ($filename | path exists) {
    return
  }

  let hash = git log --pretty=format:"%h" -- $filename
  if ($hash | lines | length) <= 1 {
    return (open -r $filename)
  }

  $env.GIT_EXTERNAL_DIFF = "difft --skip-unchanged --display inline --color always --syntax-highlight on"
  let diff = "git diff --color $(git rev-parse {}^) {}"
  let preview = $"($diff) -- ($filename)"

  mut args = [
    --style full
    --layout reverse
    --preview $preview
    --preview-window right:75%
    --bind "ctrl-k:preview-up,ctrl-j:preview-down"
    --bind "alt-k:preview-page-up,alt-j:preview-page-down"
    --bind "ctrl-t:preview-top,ctrl-b:preview-bottom"
  ]

  $hash | fzf-vim ...$args
}

def --env git-show-filter [filter: string] {
  $env.GIT_EXTERNAL_DIFF = "difft --skip-unchanged --display inline"
  let commit_hash = git log -1 --pretty=format:"%H"
  git show --ext-diff  $commit_hash -- $"*($filter)*"
}

alias gu = gitu
alias gme = gitmoji -c
alias gcm = git-commit
alias ghi = git-history
alias gsf = git-show-filter
alias gcd = git-clone-cd

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
