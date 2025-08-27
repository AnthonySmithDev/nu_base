
const rt = {
  preview: {
    max_width: 600
    max_height: 900
    image_quality: 75
  }
}

export def list_meta [file: string, entries: string] {
  mut args = [-v quiet]

  if not ($entries | str contains "attached_pic") {
    $args = ($args | append ["-select_streams", "v"])
  }

  $args = ($args | append [-show_entries $entries -of json=c=1 $file])

  let output = (ffprobe ...$args | complete)
  if $output.exit_code != 0 {
    return $"Failed to start `ffprobe`, error: ($output.stderr)"
  }

  let stdout = ($output.stdout | from json)
  if ($stdout | is-empty) {
    return $"Failed to decode `ffprobe` output: ($output.stdout)"
  } else if ($stdout | describe -d | get type) != "record" {
    return $"Invalid `ffprobe` output: ($output.stdout)"
  }

  return $stdout
}

export def preload [file: string] {
  let hash = ($file | hash md5)
  let cache = $"/tmp/video_($hash).png"
  if ($cache | path exists) {
    return $cache
  }

  let meta = list_meta $file "format=duration:stream_disposition=attached_pic"
  if ($meta.format.duration | is-empty) {
    return "Failed to get video duration"
  }

  let percent = if (has_pic $meta) { 0 } else { 5 }
  let hwaccel = "none" # "auto"

  mut args = [
    "-v", "quiet", "-threads", 1, "-hwaccel", $hwaccel,
		"-skip_frame", "nokey",
		"-an", "-sn", "-dn",
  ]
  if $percent != 0 {
    let seek_start = (($meta.format.duration | into int) * $percent / 100 | math floor)
    $args = ($args | append ["-ss", $seek_start])
  }
  $args = ($args | append ["-i", $file])
  if $percent == 0 {
    $args = ($args | append ["-map", "disp:attached_pic"])
  }

	$args = ($args | append [
    "-vframes", 1,
		"-q:v", (31 - ($rt.preview.image_quality * 0.3 | math floor)),
		"-vf", $"scale='min\(($rt.preview.max_width),iw)':'min\(($rt.preview.max_height),ih)':force_original_aspect_ratio=decrease:flags=fast_bilinear",
		"-f", "image2",
		"-y", $cache,
  ])

  let output = (ffmpeg ...$args | complete)
  if $output.stderr != "" {
    return $"Failed to start `ffmpeg`, error: ($output.stderr)"
  } else if $output.exit_code != 0 {
    return $"`ffmpeg` exited with error code: ($output.exit_code)"
  }
  return $cache
}

export def has_pic [meta: record] {
  if ($meta.streams | is-empty) { return false }
  ($meta.streams | where {|s| $s.disposition?.attached_pic? == 1 } | length) > 0
}
