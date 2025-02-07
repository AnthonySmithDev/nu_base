
export def main [--pretty(-p)] {
  if $pretty {
    format_pretty
  } else {
    format_table
  }
}

# Display storage items
export def storage [] {
  read | where isArchived == false | reject date
}

# Display archived items
export def archive [] {
  read | where isArchived == true
}

export alias a = archive

# Start/pause task
export def begin [...ids: int@task_ids] {
  let closure = {|e|
    if ($e.id in $ids) and $e.isTask {
      return ($e | upsert inProgress (not $e.inProgress))
    }
    return $e
  }
  read | each $closure | write

  {msg: $"Item: ($ids | str join ' ')"}
}

export alias b = begin

# Cancel/revive task
export def cancel [...ids: int@task_ids] {
  let closure = {|e|
    if ($e.id in $ids) and $e.isTask {
      return ($e | upsert isCanceled (not $e.isCanceled))
    }
    return $e
  }
  read | each $closure | write

  {msg: $"Item: ($ids | str join ' ')"}
}

# Check/uncheck task
export def check [...ids: int@task_ids] {
  let closure = {|e|
    if ($e.id in $ids) and $e.isTask {
      return ($e | upsert isComplete (not $e.isComplete))
    }
    return $e
  }
  read | each $closure | write

  {msg: $"Item: ($ids | str join ' ')"}
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
export def copy [id: int@ids] {
  read | where id == $id | first | get description
}

export alias y = copy

# Delete item
export def delete [...ids: int@ids, --force(-f) ] {
  if $force {
    read | where {|e| ($e.id in $ids) } | write
  } else {
    let closure = {|e|
      if ($e.id in $ids) {
        return ($e | upsert isArchived true)
      }
      return $e
    }
    read | each $closure | write
  }

  {msg: $"Deleted item: ($ids | str join ' ')"}
}

export alias d = delete

# Update duedate of task
export def due [id: int@ids, date: datetime] {
  let closure = {|e|
    if ($e.id == $id) and $e.isTask {
      return ($e | upsert dueDate $date)
    }
    return $e
  }
  read | each $closure | write

  {msg: $"Update duedate of task: ($id)"}
}

# Edit item description
export def edit [id: int@ids, ...desc: string] {
  let closure = {|e|
    if ($e.id == $id) {
      return ($e | upsert description ($desc | str join ' '))
    }
    return $e
  }
  read | each $closure | write

  {msg: $"Updated description of item: ($id)"}
}

export alias e = edit

# TODO:
# Search for items
export def find [...terms: string] {}

export alias f = find

# TODO:
# List items by attributes
export def list [...terms: string] {
}

export alias l = list

# Move item between boards
export def move [id: int@ids, ...boards: string@boards] {
  let closure = {|e|
    if ($e.id == $id) {
      return ($e | upsert boards $boards)
    }
    return $e
  }
  read | each $closure | write

  {msg: $"Moved item: ($id) to ($boards | str join ' ')"}
}

export alias m = move

# Create note
export def note [...desc: string, --board(-b): string@boards] {
  if ($desc | is-empty) {
    error make -u { msg: "description is a required argument" }
  }
  let id = (next_id)
  let value = {
    id: $id
    date: (date now)
    isTask: false
    description: ($desc | str join ' ')
    isStarred: false
    boards: [$board]
    isArchived: false
  }
  read | append $value | write

  {msg: $"Created note: ($id)"}
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
export def priority [id: int@task_ids, level: int@level] {
  let closure = {|e|
    if ($e.id == $id) and $e.isTask {
      return ($e | upsert priority $level)
    }
    return $e
  }
  read | each $closure | write

  {msg: $"Updated priority of task: ($id) to ($level)"}
}

export alias p = priority

# Restore items from archive
export def restore [...ids: int@archived_ids] {
  let closure = {|e|
    if ($e.id in $ids) {
      return ($e | upsert isArchived false)
    }
    return $e
  }
  read | each $closure | write

  {msg: $"Restored item: ($ids | str join ' ')"}
}

export alias r = restore

# Star/unstar item
export def star [...ids: int@ids] {
  let closure = {|e|
    if ($e.id in $ids) {
      return ($e | upsert isStarred (not $e.isStarred))
    }
    return $e
  }
  read | each $closure | write

  {msg: $"Starred item: ($ids | str join ' ')"}
}

export alias s = star

# Create task
export def task [...desc: string, --board(-b): string@boards] {
  if ($desc | is-empty) {
    error make -u { msg: "description is a required argument" }
  }
  let id = (next_id)
  let value = {
    id: $id
    date: (date now)
    isTask: true
    description: ($desc | str join ' ')
    isStarred: false
    boards: [$board]
    priority: 1
    inProgress: false
    isCanceled: false
    isComplete: false
    isArchived: false
    dueDate: null
    passedTime: null
    lastStartTime: null
  }
  read | append $value | write

  {msg: $"Created task: ($id)"}
}

export alias t = task

# TODO:
# Display timeline view
export def timeline [] {}

export alias i = timeline

# Rearrange the IDs of all items
export def refactor [] {
  read | sort-by isArchived | enumerate | each {|e|
    return ($e.item | upsert id ($e.index + 1))
  } | write

  {msg: "Rearranged ids of all items"}
}

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
  read | where isArchived == false | select id description | rename value
}

def task_ids [] {
  read | where isArchived == false | where isTask | select id description | rename value
}

def archived_ids [] {
  read | where isArchived | select id description | rename value
}

export def boards [] {
  read | get boards | flatten | uniq
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

def circle_symbol [] {
  $"(ansi blue) ● (ansi reset)"
}

def box_symbol [] {
  $"(ansi purple) ☐ (ansi reset)"
}

def ellipsis_symbol [] {
  $"(ansi cyan) … (ansi reset)"
}

def check_symbol [] {
  $"(ansi green) ✔ (ansi reset)"
}

def multiplication_symbol [] {
  $"(ansi red) ✖ (ansi reset)"
}

def star_symbol [] {
  $"(ansi yellow) ★ (ansi reset)"
}

def get_symbol [e: record] {
  if not $e.isTask { (circle_symbol)
  } else if $e.inProgress { (ellipsis_symbol)
  } else if $e.isCanceled { (multiplication_symbol)
  } else if $e.isComplete { (check_symbol)
  } else { (box_symbol) }
}

def get_priority [e: record] {
  if not $e.isTask { ""
  } else if $e.priority == 2 { $"(ansi yellow_bold) \(!\) (ansi reset)"
  } else if $e.priority == 3 { $"(ansi red_bold) \(!!\) (ansi reset)"
  }
}

def get_star [e: record] {
  if $e.isStarred { star_symbol } else { "" }
}

def get_due [e: record] {
  if not $e.isTask {  ""
  } else if $e.dueDate != null {
    $"(ansi yellow) \(due ($e.dueDate | date humanize) \)(ansi reset)"
  } else { "" }
}

def get_priority_desc [e: record] {
  if not $e.isTask { $e.description } else {
    if $e.priority == 2 {
      $"(ansi yellow_underline)($e.description)(ansi reset)"
    } else if $e.priority == 3 {
      $"(ansi red_underline)($e.description)(ansi reset)"
    } else { $e.description }
  }
}

def format_table [] {
  let closure = {|e|
    let symbol = ([(get_symbol $e) (get_star $e)] | str join)
    {
      id: $e.id
      s: $symbol
      desc: (get_priority_desc $e)
      due: (if not $e.isTask { "" } else if $e.dueDate != null { ($e.dueDate | date humanize) } else {""})
      boards: ($e.boards | str join ' ')
    }
  }
  read | where isArchived == false | each $closure
}

def format_pretty [] {
  let closure = {|e|
    let desc = ([(get_symbol $e) $e.description (get_star $e) (get_due $e) (get_priority $e)] | str join)
    $"    ($e.id). ($desc)"
  }
  let data = (read | where isArchived == false)

  let task = ($data | where isTask | length)
  let notes = ($data | where isTask == false | length)
  let progress = ($data | where isTask | where inProgress | length)
  let cancel = ($data | where isTask | where isCanceled | length)
  let done = ($data | where isTask | where isComplete | length)
  let pending = ($task - $progress - $cancel - $done)

  for board in (boards) {
    let tasks = ($data | where {|e| ($board in $e.boards)})
    let total = ($tasks | where isTask | length)
    let complete = ($tasks | where isTask | where isComplete | length)
    print $"  (ansi default_underline)($board)(ansi reset) (ansi white)[($complete)/($total)](ansi reset)"
    print ($tasks | each $closure | to text)
  }

  let info = [
    $"(ansi green)($done)(ansi reset) done"
    $"(ansi red)($cancel)(ansi reset) canceled"
    $"(ansi blue)($progress)(ansi reset) in-progress"
    $"(ansi purple)($pending)(ansi reset) pending"
    $"(ansi blue)($notes)(ansi reset) notes"
  ]

  let percentage = $"(ansi green)(($pending / $task) * 100)%(ansi reset)"
  print $"  ($percentage) of all tasks complete."
  print $"  ($info | str join ' · ')"
}
