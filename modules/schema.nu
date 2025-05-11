
def names [] {
  [anthony, jean, kube-dev, kube-prod, file]
}

export def dsn [dsn: string@names] {
  if $dsn == "anthony" {
    mode dev
    return (sql dsn true)
  } else if $dsn == "jean" {
    mode dev -n jean
    return (sql dsn true)
  } else if $dsn == "kube-dev" {
    mode kube-dev
    return (sql dsn true)
  } else if $dsn == "kube-prod" {
    mode kube-prod
    return (sql dsn true)
  } else if $dsn == "file" {
    let files = (^fd -e hcl)
    if ($files | is-empty) {
      error make -u { msg: "Files HCL not found" }
    }
    let file = ($files | gum filter --select-if-one)
    if ($file | is-empty) {
      error make -u { msg: "File selection is empty" }
    }
    return $"file://($file)"
  }
}

def dev_url [] {
  "docker://maria/latest/dev"
}

export def inspect [name: string@names, --sql, --save(-s)] {
  let args = [
    schema inspect
    --dev-url (dev_url)
    --url (dsn $name)
  ]
  if $sql {
    let output = (atlas ...$args --format "{{ sql . }}" | sleek)
    if $save {
      $output | save -f schema.sql
    } else {
      $output
    }
  } else {
    let output = (atlas ...$args)
    if $save {
      $output | save -f schema.hcl
    } else {
      $output
    }
  }
}

export def diff [from: string@names, to: string@names --syntax(-s)] {
  let args = [
    schema diff
    --dev-url (dev_url)
    --from (dsn $from)
    --to (dsn $to)
  ]
  if $syntax {
    atlas ...$args | sleek | bat -l sql -p -n
  } else {
    atlas ...$args | sleek
  }
}

export def apply [from: string@names, to: string@names, --yes(-y)] {
  let args = [
    schema apply
    --dev-url (dev_url)
    --url (dsn $from)
    --to (dsn $to)
  ]
  if $yes {
    atlas ...$args --auto-approve
  } else {
    atlas ...$args
  }
}

export def apply_all [] {
  let query = (diff anthony file)

  $query | bat -l sql -p -n

  sql_exec (dsn anthony) $query
  sql_exec (dsn jean) $query
  sql_exec (dsn kube) $query
}

def sql_exec [dsn: string, query: string] {
  print -n "Apply in: " $dsn "\n"

  let filename = (mktemp -t --suffix .sql)
  $query | save -f $filename

  usql $dsn -q -C -f $filename | null
}
