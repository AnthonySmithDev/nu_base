
export def mdns-scan [resolve: string] {
  let columns = [type interface protocol 'service name' 'service type' 'host name' scope ip port info]
  avahi-browse -p -t -r $resolve | rg '=' | from csv --noheaders --separator ';' | rename ...$columns
}

export def connect [] {
  let devices = (mdns-scan _adb-tls-connect._tcp)
  if ($devices | length) > 0 {
    let device = ($devices | where protocol == IPv4 | first)
    adb connect $"($device.ip):($device.port)"
  }
}

export def pair [] {
  let nameId = random chars -l 10;
  let password = random chars -l 10;
  let name = $'ADB_WIFI_($nameId)';

  $'WIFI:T:ADB;S:($name);P:($password);;' | qrencode -t ANSI -m 1

  loop {
    let devices = (mdns-scan _adb-tls-pairing._tcp)
    if ($devices | length) > 0 {
      let device = ($devices | where protocol == IPv4 | where 'service name' == $name | first)
      adb pair $"($device.ip):($device.port)" $password
      adbx c
      break
    }
    sleep 1sec
  }
}
