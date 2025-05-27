
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

def molc [] {
  {
    options: {
      case_sensitive: false,
      completion_algorithm: prefix,
      positional: false,
      sort: false,
    },
    completions: (mods --list --raw | parse "{value}\t{description}\t{time}")
  }
}

alias mo = mods  # Run the mods command (CLI interface for LLMs)
alias mos = mods --show-last  # Show the last mods response
alias mor = mods --show-last --raw  # Show the last response in raw format
alias moe = tempeditor --suffix .md (mor)  # Open the last response in a temporary editor
alias moc = mods --continue-last  # Continue the last conversation with mods

def mop [...rest] { wl-paste | mo ...$rest }  # Paste clipboard content and run mods
def mocp [...rest] { wl-paste | moc ...$rest }  # Paste clipboard content and continue last conversation
def molr [] { mods --list --raw }  # List previous conversations in raw format

def moS [id: string@molc] { mods --show $id }  # Show a specific conversation
def moR [id: string@molc] { mods --show $id --raw }  # Show a conversation in raw format
def moE [id: string@molc] { tempeditor --suffix .md (moR $id) }  # Open a conversation in an editor
def moC [id: string@molc, ...rest] { mods --continue $id ...$rest }  # Continue a specific conversation
def moP [id: string@molc, ...rest] { wl-paste | mods --continue $id ...$rest }  # Paste and continue a conversation
