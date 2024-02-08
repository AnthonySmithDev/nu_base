
export def main [] {
  read | where isArchived == false
}

# Display archived items
export def archive [] {
  read | where isArchived == true
}

export alias a = archive

# Start/pause task
export def begin [id?: int@ids] {
  let closure = {|e|
    if ($e.id == $id) and $e.isTask {
      return ($e | upsert inProgress (not $e.inProgress))
    }
    return $e
  }
  read | each $closure | write
}

export alias b = begin

# Cancel/revive task
export def cancel [id?: int@ids] {
  let closure = {|e|
    if ($e.id == $id) and $e.isTask {
      return ($e | upsert isCanceled (not $e.isCanceled))
    }
    return $e
  }
  read | each $closure | write
}

# Check/uncheck task
export def check [id?: int@ids] {
  let closure = {|e|
    if ($e.id == $id) and $e.isTask {
      return ($e | upsert isComplete (not $e.isComplete))
    }
    return $e
  }
  read | each $closure | write
}

export alias c = check

# Delete all checked items
export def clear [ --force(-f) ] {
  if $force {
    [] | write
  } else {
    let closure = {|e|
      if $e.isTask and $e.isComplete {
        return ($e | upsert isArchived true)
      }
      return $e
    }
    read | each $closure | write
  }
}

# Copy description to clipboard
export def copy [id?: int@ids] {
  read | where id == $id | first | get description
}

export alias y = copy

# Delete item
export def delete [id?: int@ids, --force(-f) ] {
  if $force {
    read | where id != $id | write
  } else {
    let closure = {|e|
      if ($e.id == $id) {
        return ($e | upsert isArchived true)
      }
      return $e
    }
    read | each $closure | write
  }
}

export alias d = delete

# TODO:
# Update duedate of task
export def due [id?: int@ids] {}

# Edit item description
export def edit [id?: int@ids, ...desc: string] {
  let closure = {|e|
    if ($e.id == $id) {
      return ($e | upsert description ($desc | str join " "))
    }
    return $e
  }
  read | each $closure | write
}

export alias e = edit

# TODO:
# Search for items
export def find [...terms: string] {}

export alias f = find

# TODO:
# List items by attributes
export def list [...terms: string] {}

export alias l = list

# Move item between boards
export def move [id?: int@ids, board?: string] {
  let closure = {|e|
    if ($e.id == $id) {
      return ($e | upsert boards [$board])
    }
    return $e
  }
  read | each $closure | write
}

export alias m = move

# Create note
export def note [...desc: string] {
  if ($desc | is-empty) {
    error make -u { msg: "description is a required argument" }
  }
  let value = {
    id: (next_id)
    date: (date now)
    isTask: false
    description: ($desc | str join " ")
    isStarred: false
    isArchived: false
  }
  read | append $value | write
}

export alias n = note

def level [] {
  [
    { value: 1, description: "Normal" },
    { value: 2, description: "Medium" }
    { value: 3, description: "High" }
  ]
}

# Update priority of task
export def priority [id?: int@ids, level?: int@level] {
  let closure = {|e|
    if ($e.id == $id) and $e.isTask {
      return ($e | upsert priority $level)
    }
    return $e
  }
  read | each $closure | write
}

export alias p = priority

# Restore items from archive
export def restore [id?: int@ids] {
  let closure = {|e|
    if ($e.id == $id)  {
      return ($e | upsert isArchived false)
    }
    return $e
  }
  read | each $closure | write
}

export alias r = restore

# Star/unstar item
export def star [id?: int@ids] {
  let closure = {|e|
    if ($e.id == $id) {
      return ($e | upsert isStarred (not $e.isStarred))
    }
    return $e
  }
  read | each $closure | write
}

export alias s = star

# Create task
export def task [...desc: string] {
  if ($desc | is-empty) {
    error make -u { msg: "description is a required argument" }
  }
  let value = {
    id: (next_id)
    date: (date now)
    isTask: true
    description: ($desc | str join " ")
    isStarred: false
    boards: ["inbox"]
    priority: 1
    inProgress: false
    isCanceled: false
    isComplete: false
    isArchived: false
    dueDate: ""
    passedTime: 0
    lastStartTime: 0
  }
  read | append $value | write
}

export alias t = task

# TODO:
# Display timeline view
export def timeline [id?: int@ids, priority?: int] {}

export alias i = timeline

# TODO:
# Rearrange the IDs of all items
export def refactor [id?: int@ids, priority?: int] {}

def read [] {
  let path = ($env.HOME | path join gtd.json)
  if not ($path | path exists) {
    return []
  }
  open $path
}

def write [] {
  save -f ($env.HOME | path join gtd.json)
}

def ids [] {
  read | get id
}

def boards [] {
  read | get board | uniq
}

def next_id [] {
  read | length | $in + 1
}

export def gen [] {
  task "Lorem ipsum dolor sit amet"
  task "consectetur adipiscing elit"
  task "labore et dolore magna aliqua"

  note "Esta es mi primera nota"
  note "Como saber en que momento hay un elipse"
  note "Quiero comprar algo cuando pueda"
}
