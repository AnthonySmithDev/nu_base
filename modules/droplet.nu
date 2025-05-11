
export def ssh-key [] {
   doctl compute ssh-key list | from ssv
}

export def region [] {
   doctl compute region list | from ssv
}

export def image [] {
  doctl compute image list | from ssv
}

export def size [] {
   doctl compute size list | from ssv | first 10
}

export def tag [] {
   doctl compute tag list | from ssv
}

export def create [name: string] {
  let args = [
    --size s-1vcpu-1gb
    --image ubuntu-24-10-x64
    --ssh-keys 8f:4a:ed:2b:85:c4:22:f0:a7:07:38:01:9d:b0:88:8d
    --region nyc1
  ]
  doctl compute droplet create $name ...$args | from ssv
}

export def list [] {
  doctl compute droplet list | from ssv
}

export def names [] {
  list | get Name
}

export def info [name: string@names] {
  doctl compute droplet get $name | from ssv | first
}

export def ssh [name: string@names] {
  doctl compute ssh $name
}

export def delete [name: string@names] {
  doctl compute droplet delete $name
}
