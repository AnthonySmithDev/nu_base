
export def list [] {
  let blockdevices = (lsblk -o NAME,LABEL,FSTYPE,SIZE,RM,RO,TYPE,MOUNTPOINTS,UUID --json | from json | get blockdevices)
  $blockdevices | get children | flatten
  # | where ($it.label? | default "" | str trim) != ""
  | into filesize size | where size > 8GB
  | each {|e| $e | update label {default $e.uuid}}
  | select name label mountpoints
}

def list-mount [] {
  list | filter {$in.mountpoints | is-not-empty } | rename value description
}

def list-umount [] {
  list | filter {$in.mountpoints | is-empty } | rename value description
}

export def mount [name: string@list-umount] {
  let label = (list | where name == $name | get label | first)
  let source = ("/dev" | path join $name)
  let directory = ("/media" | path join $env.USER $label)
  sudo mkdir -p $directory
  sudo mount $source $directory
  return $directory
}

export def umount [name: string@list-mount] {
  let label = (list | where name == $name | get label | first)
  let directory = ("/media" | path join $env.USER $label)
  sudo umount $directory
  sudo rm -rf $directory
  return $directory
}
