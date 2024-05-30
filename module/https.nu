
export def download [
  url: string
  --output(-o): string
] {
   if (^which xh | is-not-empty) {
    mut args = [
      '--body'
      '--download'
    ]
    if $output != null {
      $args = ($args | append ['--output' $output])
    }
    ^xh ...$args $url
  } else if (^which https | is-not-empty) {
    mut args = [
      '--body'
      '--download'
    ]
    if $output != null {
      $args = ($args | append ['--output' $output])
    }
    ^https ...$args $url

  } else if (^which wget | is-not-empty) {
    mut args = [
      '--quiet'
      '--show-progress'
    ]
    if $output != null {
      $args = ($args | append ['--output-document' $output])
    }
    ^wget ...$args  $url
  }
}

export def bench [url: string] {
  bombardier $url
}
