
def __zellij_sessions [] {
  zellij list-sessions | lines | parse "{value} {desc}"
  | update value {ansi strip}
}

def 'zellij drop' [ ...session: string@__zellij_sessions, --all(-a) ] {
  let select_sessions = if ($session | is-not-empty) {
    __zellij_sessions | where value in $session
  } else if $all {
    __zellij_sessions
  } else { [] }

  if ($select_sessions | length) == 0 {
    return
  }

  let active_sessions = ($select_sessions | where desc !~ 'EXITED' | get value)
  for $session in $active_sessions {
    zellij kill-session $session
  }

  let exited_sessions = ($select_sessions | get value)
  for $session in $exited_sessions {
    zellij delete-session --force $session
  }
}

alias zj = zellij
alias zr = zellij run
alias ze = zellij edit
alias za = zellij action
alias zat = zellij attach

alias zls = zellij list-sessions
alias zks = zellij kill-session
alias zds = zellij delete-session
alias zkas = zellij kill-all-sessions -y
alias zdas = zellij delete-all-sessions -y

alias zdr = zellij drop
alias zda = zellij drop --all

alias zl = zellij --layout
alias zot = zellij options --theme
alias zon = zellij options --session-name
alias zrf = zellij run --floating --

alias zna = zon a
alias znb = zon b
alias znc = zon c
alias znd = zon d

alias zaa = zat a
alias zab = zat b
alias zac = zat c
alias zad = zat d
