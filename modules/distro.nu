
export def kali [] {
  if not (container_exist kali) {
    docker pull docker.io/kalilinux/kali-rolling
    docker run --name kali --net host --detach --privileged --tty --interactive kalilinux/kali-rolling
    docker exec -it kali apt update
    docker exec -it kali apt install -y kali-linux-headless
  }
  if not (container_enable kali) {
    docker start kali
  }
  docker attach kali
}

export def config [] {
  {
    'Kismet': {
      'Install Kismet "setui root"?': 'yes'
      'Users to add to the kismet group': ' '
    }
    'Change MAC automatically?': 'no'
    'Please select the layout matching the keyboard for this machine': '28,84,1'
    'Should non-superusers be able to capture packets?': 'no'
    'Configuring console-setup': {
      'Character set to support': 14
    }
    'Run sslh': 1
  }
}

def container_exist [name: string] {
  let container = container_ps | where name == $name
  if ($container | is-empty) {
    return false
  }
  return true
}

def container_enable [name: string] {
  let container = container_ps | where name == $name
  if ($container | is-empty) {
    return false
  }
  return ($container | first | get status | str contains Up)
}

def container_ps [] {
  docker ps -a --format "{{.Names}} {{.Status}}" | lines | parse '{name} {status}'
}
