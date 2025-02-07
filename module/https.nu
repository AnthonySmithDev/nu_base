
export def bench [url: string] {
  bombardier $url
}

export def download [
  url?: string
  --output(-o): string
] {
   if (^which xh | is-not-empty) {
    download xh $url --output $output
  } else if (^which https | is-not-empty) {
    download https $url --output $output
  } else if (^which wget | is-not-empty) {
    download wget $url --output $output
  }
}

export alias d = download

export def 'download xh' [
  url: string
  --output(-o): string
] {
  mut args = [
    --body
    --download
  ]
  if ($output | is-not-empty) {
    $args = ($args | append ['--output' $output])
  }
  try {
    ^xh ...$args $url
  } catch { ||
    if ($output | is-not-empty) { rm -rf $output }
    error make -u { msg: $"Not found: ($url)" }
  }
}

export def 'download https' [
  url: string
  --output(-o): string
] {
  mut args = [
    --body
    --download
  ]
  if ($output | is-not-empty) {
    $args = ($args | append ['--output' $output])
  }
  try {
    ^https ...$args $url
  } catch { ||
    if ($output | is-not-empty) { rm -rf $output }
    error make -u { msg: $"Not found: ($url)" }
  }
}

export def 'download wget' [
  url: string
  --output(-o): string
] {
  mut args = [
    --quiet
    --show-progress
  ]
  if ($output | is-not-empty) {
    $args = ($args | append ['--output-document' $output])
  }
  try {
    ^wget ...$args $url
  } catch { ||
    if ($output | is-not-empty) { rm -rf $output }
    error make -u { msg: $"Not found: ($url)" }
  }
}
