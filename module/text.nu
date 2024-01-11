
export def search [
  query: string = ""
  --editor(-e)
  --json(-j)
] {
  if (which rg | is-empty) {
    return
  }
  if (which bat | is-empty) {
    return
  }
  if (which fzf | is-empty) {
    return
  }
  let rg = "rg --column --line-number --no-heading --color=always --smart-case "
  let start = $"start:reload:($rg) {q}"
  let change = $"change:reload:sleep 0.1; ($rg) {q} || true"
  let preview = 'bat --plain --number --color=always {1} --highlight-line {2}'
  let window = 'up,80%,border-bottom,+{2}+3/3,~3'
  let select = fzf --ansi --disabled --query $query --bind $start --bind $change --delimiter : --preview $preview --preview-window $window
  if ($select | is-empty) {
    return
  }
  let file = ($select | split row -r ' ' | first | str trim -c ':' | parse '{name}:{line}:{column}' | first)

  if $editor {
    hx $"($file.name):($file.line):($file.column)"
  } else if $json {
    jless --mode line $file.name
  } else {
    return $file.name
  }
}

export def replace [
  pattern: string
  replacement: string
  --write(-w)
] {
  if (which delta | is-empty) {
    return
  }
  if (which sad | is-empty) {
    return
  }
  if (which fd | is-empty) {
    return
  }
  $env.GIT_PAGER = 'delta -s'
  $env.FZF_DEFAULT_OPTS = '--layout=reverse --border'
  if $write {
    fd | sad $pattern $replacement --commit
  } else {
    fd | sad $pattern $replacement
  }
}
