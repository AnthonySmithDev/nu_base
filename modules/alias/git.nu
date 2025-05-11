
def git-commit [...rest: string] {
  git commit -m ($rest | str join ' ')
}

def --wrapped git-clone-cd [repo: string, dir?: string, ...args: string] {
  let repo_name = ($repo | split row "/" | last | str replace ".git" "")
  git clone $repo ($dir | default $repo_name) ...$args
}

def git-history [file: string] {
  let logs = (git log --pretty=format:"%h" -- $file | lines)
  for $commit in $logs {
    git show $"($commit):($file)" | bat -l go
  }
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
