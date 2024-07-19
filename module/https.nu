
export def bench [url: string] {
  bombardier $url
}

export def download [
  url: string
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

export def 'download xh' [
  url: string
  --output(-o): string
] {
  mut args = [
    '--body'
    '--download'
  ]
  if $output != null {
    $args = ($args | append ['--output' $output])
  }
  ^xh ...$args $url
}

export def 'download https' [
  url: string
  --output(-o): string
] {
  mut args = [
    '--body'
    '--download'
  ]
  if $output != null {
    $args = ($args | append ['--output' $output])
  }
  ^https ...$args $url
}

export def 'download wget' [
  url: string
  --output(-o): string
] {
  mut args = [
    '--quiet'
    '--show-progress'
  ]
  if $output != null {
    $args = ($args | append ['--output-document' $output])
  }
  ^wget ...$args  $url
}
