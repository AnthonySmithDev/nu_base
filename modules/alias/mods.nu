
def --wrapped mods [...rest] {
  let input = $in
  let columns = (term size | get columns)
  if $columns > 110 {
    $env.MODS_WORD_WRAP = 100
  } else {
    $env.MODS_WORD_WRAP = $columns - 10
  }
  $input | ^mods ...$rest
}

alias mo = mods
alias mos = mods --show-last
alias mor = mods --show-last --raw
alias moe = tempeditor --suffix .md (mor)
alias moc = mods --continue-last

def mop [...rest] { wl-paste | mo ...$rest }
def mocp [...rest] { wl-paste | moc ...$rest }

def molr [] { mods --list --raw }

def molc [] {
  {
    options: {
      case_sensitive: false,
      completion_algorithm: prefix,
      positional: false,
      sort: false,
    },
    completions: (molr | parse "{value}\t{description}\t{time}")
  }
}

def moS [id: string@molc] { mods --show $id }
def moR [id: string@molc] { mods --show $id --raw }
def moE [id: string@molc] { tempeditor --suffix .md (moR $id) }
def moC [id: string@molc, ...rest] { mods --continue $id ...$rest }
def moP [id: string@molc, ...rest] { wl-paste | mods --continue $id ...$rest }
