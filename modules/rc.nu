
export def comp [context: string] {
  let rc_path = ($context | split row " " | skip 2 | str join " ")

  if not ($rc_path | str contains ":") {
    let remotes = (rclone listremotes | lines)
    let paths = (ls | get name)
    return ($remotes | append $paths)
  }

  let parse = ($rc_path | parse "{remote}:{path}" | first )
  if ($parse.path | is-empty) {
    # print "path is empty"
    rclone lsjson ($parse.remote):($parse.path) | from json | get Path | each {|row| $"($parse.remote):($parse.path)($row)"}
  } else if ($parse.path | str ends-with "/") {
    # print "path end slash"
    rclone lsjson ($parse.remote):($parse.path) | from json | get Path | each {|row| $"($parse.remote):($parse.path)($row)"}
  } else {
    # print "path auto complete"
    let dirname = ($parse.path | path dirname)
    let basename = ($parse.path | path basename)
    let paths = (rclone lsjson ($parse.remote):($dirname) | from json)

    let filter = ($paths | where Path =~ $basename)
    if ($filter | length) == 1 {
      let result = ($filter | first)
      let path = ($result | get Path)
      let current = ([$dirname, $path] | path join)
      if ($result.IsDir) {
        [$"($parse.remote):($current)/"]
      } else {
        [$"($parse.remote):($current)"]
      }
    } else {
      $filter | get Path | each {|row| $"($parse.remote):($dirname | path join $row)" }
    }
  }
}

export def comp2 [context: string] {
  let rc_path = ($context | split row " " | skip 2 | str join " ")

  if not ($rc_path | str contains ":") {
    return (rclone listremotes | lines | append (ls | get name))
  }

  let parse = ($rc_path | parse "{remote}:{path}" | first)
  let dirname = ($parse.path | path dirname)
  let basename = ($parse.path | path basename)

  mut remote_path = ""
  if ($parse.path | is-empty) or ($parse.path | str ends-with "/") {
    $remote_path = $parse.path
  } else {
    $remote_path = $dirname
  }

  let lsjson = (rclone lsjson ($parse.remote):($remote_path) | from json)
  let filter = ($lsjson | where Path =~ $basename)
  if ($filter | length) > 0 {
    $filter | each {|row|
    if $row.IsDir {
      $"($parse.remote):($dirname | path join $row.Path)/"
    } else {
      $"($parse.remote):($dirname | path join $row.Path)"
    }}
  } else {
    $lsjson | get Path | each {|row| $"($parse.remote):($dirname | path join $row)" }
  }
}

export def run [arg1: string@comp] {
  print $arg1
}
