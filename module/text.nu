
export def search [query: string = ""] {
  let rg = "rg --column --line-number --no-heading --color=always --smart-case "
  let start = $"start:reload:($rg) {q}"
  let change = $"change:reload:sleep 0.1; ($rg) {q} || true"
  let preview = 'bat --plain --number --color=always {1} --highlight-line {2}'
  let window = 'up,60%,border-bottom,+{2}+3/3,~3'
  let enter = 'enter:become(hx {1}:{2}:{3})'
  fzf --ansi --disabled --query $query --bind $start --bind $change --delimiter : --preview $preview --preview-window $window --bind $enter
}

export def replace [
  pattern: string
  replacement: string
  --write(-w)
] {
  $env.GIT_PAGER = 'delta -s'
  $env.FZF_DEFAULT_OPTS = '--layout=reverse --border'
  if $write {
    fd | sad $pattern $replacement --commit
  } else {
    fd | sad $pattern $replacement
  }
}
