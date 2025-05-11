
export def 'image list' [] {
  hcloud image list | from ssv
}

export def 'image names' [] {
  hcloud image list | from ssv | get NAME | uniq
}

export def 'server-type list' [] {
  hcloud server-type list | from ssv
}

export def 'ssh-key list' [] {
  hcloud ssh-key list | from ssv
}

export def 'datacenter list' [] {
  hcloud datacenter list | from ssv
}

export def 'location list' [] {
  hcloud location list | from ssv
}

export def 'primary-ip list' [] {
  hcloud primary-ip list | from ssv
}

export def 'server list' [] {
  hcloud server list | from ssv
}

export def 'server ids' [] {
  server list | select ID NAME | rename value description
}

export def 'server create' [name: string = 'test', image: string = 'ubuntu-24.04'] {
  hcloud server create --name $name --image $image --type cpx11 --ssh-key Anthony
}

export def 'server describe' [id: string@'server ids'] {
  hcloud server describe -o json $id | from json
}

export def 'server delete' [id: string@'server ids'] {
  hcloud server delete $id
}

export def 'pricing' [] {
  let TOKEN = 'cQro7VnbtMInERtSOA7d7Wj7FPaJfx9tDrbWbmwcQNZckRF7xUa8SeucPmAeFLjz'
  curl -H $"Authorization: Bearer ($TOKEN)" "https://api.hetzner.cloud/v1/pricing"
}
