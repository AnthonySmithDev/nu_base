
def complete_cmd [] {
  ls -s ~/.local/lib/hyde/ | where type == file | get name
}

export extern main [
  cmd: string@complete_cmd
]
