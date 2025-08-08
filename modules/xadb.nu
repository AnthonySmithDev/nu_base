
# sudo systemctl start avahi-daemon
# sudo systemctl enable avahi-daemon

export def mdns-services [] {
  adb mdns services | grep "adb" | from csv -n -s "\t" | rename id service host
}

export def mdns-browse [] {
  avahi-browse --all --resolve --parsable --terminate | grep "adb"
}

export def mdns-pairing [] {
  let columns = [type interface protocol svc_name svc_type host_name scope ip port info]
  mdns-browse | grep "="
  | from csv --noheaders --separator ';'
  | rename ...$columns 
  | where protocol in ["IPv4"]
  | where svc_type in ["_adb-tls-pairing._tcp"]
}

export def mdns-connect [] {
  let columns = [type interface protocol svc_name svc_type host_name scope ip port info]
  mdns-browse | grep "="
  | from csv --noheaders --separator ';'
  | rename ...$columns 
  | where protocol in ["IPv4"]
  | where svc_type in ["_adb-tls-connect._tcp"]
}

export def "pair pin" [] {
  let devices = mdns-pairing | each { $"($in.ip):($in.port)" }
  if ($devices | is-empty) {
    return
  }
  if ($devices | length) == 1 {
    adb pair ($devices | first)
  } else {
    adb pair ($devices | input list)
  }
}

const ADB_PAIR_PASS = "adb_pair_pass"

export def "gen-qr" [] {
  let name = $'ADB_WIFI_(random chars -l 10;)';
  let input = $'WIFI:T:ADB;S:($name);P:($ADB_PAIR_PASS);;'
  qrrs -m 1 $input
}

export def "pair qr" [] {
  gen-qr

  loop {
    let devices = mdns-pairing | each { $"($in.ip):($in.port)" }
    if ($devices | is-empty) {
      sleep 1sec
      continue
    }
    if ($devices | length) == 1 {
      adb pair ($devices | first) $ADB_PAIR_PASS
    } else {
      adb pair ($devices | input list) $ADB_PAIR_PASS
    }
    break
  }
}

export def devices [] {
  adb devices | str trim | lines | skip | to text | parse '{name}	{status}'
}

export def connect [] {
  let devices = (devices | where status == device)
  if ($devices | length) > 0 {
    return "Already connected device"
  }

  let devices = mdns-pairing | each { $"($in.ip):($in.port)" }
  if ($devices | length) == 1 {
    adb connect ($devices | first)
  } else {
    adb connect ($devices | input list)
  }
}
