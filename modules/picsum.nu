
export def main [
  --width (-w): int = 720
  --height (-h): int = 1080
  --id: string
  --seed: string
  --grayscale (-g)
  --blur(-b): int
  --format(-f): string = "jpg"
  --save(-s)
  --batch: int = 1
] {
  mut parent = []
  if $id != null {
    $parent = ($parent | append [id $id])
  }
  if $seed != null {
    $parent = ($parent | append [seed $seed])
  }
  $parent = ($parent | append ($width | into string))

  let path = ({
    parent: ($parent | path join),
    stem: $height,
    extension: $format
  } | path join)

  mut query = []
  if $grayscale {
    $query = ($query | append "grayscale")
  }
  if $blur != null {
    if $blur == 0 {
      $query = ($query | append "blur")
    } else {
      $query = ($query | append $"blur=($blur)")
    }
  }

  let url = ({
    "scheme": "https",
    "host": "picsum.photos",
    "path": $path,
    "query": ($query | str join "&"),
  } | url join)

  mut urls = []
  for i in 1..$batch {
    let resp = (http get --full --redirect-mode m $url )
    let url = ($resp | get headers.response | where name == location | first | get value)
    $urls = ($urls | append $url)
  }

  if $save {
    for url in $urls {
      let resp = (http get --full $url)
      # let filename = ($resp.headers.response
      # | where name == "content-disposition" | first
      # | get value | split row "=" | last | str trim -c '"')
      let filename = ($url | url parse  | get path | split words | skip | $"($in.0)-($in.1)x($in.2).($in.3)")
      $resp.body | save --force --progress $filename
    }
  } else {
    $urls
  }
}

