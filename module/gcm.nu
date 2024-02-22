
export-env {
  $env.IDENTITY = 'You are to act as the author of a commit message in git.'
  $env.EMOJI = true
  $env.DESCRIPTION = true
  $env.LANGUAGE = "spanish"
}

def emoji [] {
  if $env.EMOJI {
    "Use GitMoji convention to preface the commit."
  } else {
    "Do not preface the commit with anything."
  }
}

def description [] {
  if $env.DESCRIPTION {
    "Add a short description of WHY the changes are done after the commit message. Don't start it with 'This commit', just describe the changes."
  } else {
    "Don't add any descriptions to the commit, only commit message."
  }
}

export def prompt [] {
  $"($env.IDENTITY) Your mission is to create clean and comprehensive commit messages as per the conventional commit convention and explain WHAT were the changes and mainly WHY the changes were done. I'll send you an output of 'git diff --staged' command, and you are to convert it into a commit message. (emoji) (description) Use the present tense. Lines must not be longer than 74 characters. Use ($env.LANGUAGE) for the commit message."
}

export def main [] {
  git diff | mods (prompt)
}
