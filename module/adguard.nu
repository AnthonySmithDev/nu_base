
export def install [] {
  sudo snap install adguard-home
}

export def remove [] {
  sudo snap remove adguard-home
}

def content [] {
  let lines = [
    "[Resolve]"
    "DNS=127.0.0.1"
    "DNSStubListener=no"
  ]
  ($lines | to text)
}

export def config [] {
  sudo mkdir -p /etc/systemd/resolved.conf.d
  let config = "/etc/systemd/resolved.conf.d/adguardhome.conf"
  if not ($config | path exists) {
    sudo bash -c $"echo '(content)' > ($config)"
  }

  let backup = "/etc/resolv.conf.backup"
  if not ($backup | path exists) {
    sudo mv /etc/resolv.conf $backup
  }

  sudo ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf
  sudo systemctl restart systemd-resolved
}

export def restore [] {
  let backup = "/etc/resolv.conf.backup"
  if ($backup | path exists) {
    sudo ln -sf $backup /etc/resolv.conf
    sudo systemctl restart systemd-resolved
  }
}
