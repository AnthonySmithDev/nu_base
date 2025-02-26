
def vulnerable [] {
  docker run -it --rm --net host heywoodlh/vulnerable
}

export def interfaces [] {
  ifconfig | grep -o '^[^[:space:]:]*' | grep -vE 'br|veth' | lines
}

export def arp_scan [] {
  let scan = (sudo arp-scan -I eth0 --localnet | lines | skip 2 | drop 3 | parse -r '([\d.]+)\s+([\w:]+)\s+(.+)' | rename ip mac description)
  $scan | save -f ($env.HOME | path join .scan.nuon)
  print $scan
}

export def ips [] {
  open ($env.HOME | path join .scan.nuon) | get ip
}

export def arp_spoof [interface: string@interfaces, target: string@ips] {
  sudo arpspoof -i $interface -t $target (ips | first)
}
