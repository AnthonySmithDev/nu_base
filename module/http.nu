
export def download [
  url: string
  --output(-o): string
] {
   if not (which https | is-empty) {
    mut args = [
      '--body'
      '--download'
    ]
    if $output != null {
      $args = ($args | append ['--output' $output])
    }
    ^https $args $url
  } else if not (which xh | is-empty) {
    mut args = [
      '--body'
      '--download'
    ]
    if $output != null {
      $args = ($args | append ['--output' $output])
    }
    ^xh $args $url

  } else if not (which wget | is-empty) {
    mut args = [
      '--quiet'
      '--show-progress'
    ]
    if $output != null {
      $args = ($args | append ['--output-document' $output])
    }
    ^wget $args  $url
  }
}

export def bench [url: string] {
  bombardier $url
}
