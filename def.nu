
export def to-repo [] {
  url parse | get path | path split | skip | first 2 | path join
}

export def tempeditor [
  data: any,
  --suffix(-s): string = "",
  --output(-o),
] {
  if ($data | str trim | is-empty) {
    return
  }

  let temp = mktemp --tmpdir --suffix $suffix
  $data | str trim | save --force $temp
  hx $temp

  if $output {
    return (open $temp | str trim)
  }
}
