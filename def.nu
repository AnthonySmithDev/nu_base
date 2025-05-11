
export def to-repo [] {
  url parse | get path | path split | skip | first 2 | path join
}
