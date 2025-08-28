
const rt = {
  preview: {
    max_width: 600
    max_height: 900
    image_quality: 75
  }
}

export def list_meta [file: string, entries: string] {
  mut cmd_args = [-v quiet]

  if not ($entries | str contains "attached_pic") {
    $cmd_args = ($cmd_args | append ["-select_streams", "v"])
  }

  $cmd_args = ($cmd_args | append ["-show_entries" $entries "-of" "json=c=1" $file])

  let output = (run-external ffprobe ...$cmd_args | complete)
  if $output.exit_code != 0 {
    error make -u { msg: $"Failed to start `ffprobe`, error: ($output.stderr)" }
  }

  let stdout = ($output.stdout | from json)
  if ($stdout | is-empty) {
    error make -u { msg: $"Failed to decode `ffprobe` output: ($output.stdout)" }
  } else if ($stdout | describe -d | get type) != "record" {
    error make -u { msg: $"Invalid `ffprobe` output: ($output.stdout)" }
  }

  return $stdout
}

export def has_pic [meta: record] {
  if ($meta.streams | is-empty) { return false }
  ($meta.streams | where {|s| $s.disposition?.attached_pic? == 1 } | length) > 0
}

export def preload [file: string, --downscale(-d)] {
  let mimetype = (file --mime-type $file | str replace $"($file): " "" | str trim)
  if not ($mimetype | str starts-with "video/") {
    error make -u { msg: $"File is not a video file. Mimetype: ($mimetype)" }
  }

  let cache = $"/tmp/preload_video_($file | hash md5).jpg"
  if ($cache | path exists) {
    return $cache
  }

  let meta = list_meta $file "format=duration:stream_disposition=attached_pic"
  if ($meta.format.duration | is-empty) {
    error make -u { msg: "Failed to get video duration" }
  }

  let percent = if (has_pic $meta) { 0 } else { 5 }
  let hwaccel = "none" # "auto"

  mut cmd_args = [
    "-v", "quiet", "-threads", 1, "-hwaccel", $hwaccel,
		"-skip_frame", "nokey",
		"-an", "-sn", "-dn",
  ]
  if $percent != 0 {
    let seek_start = (($meta.format.duration | into int) * $percent / 100 | math floor)
    $cmd_args = ($cmd_args | append ["-ss", $seek_start])
  }
  $cmd_args = ($cmd_args | append ["-i", $file])
  if $percent == 0 {
    $cmd_args = ($cmd_args | append ["-map", "disp:attached_pic"])
  }
  $cmd_args = ($cmd_args | append ["-vframes", 1])

  if $downscale {
    $cmd_args = ($cmd_args | append [
      "-q:v", (31 - ($rt.preview.image_quality * 0.3 | math floor)),
      "-vf", $"scale='min\(($rt.preview.max_width),iw)':'min\(($rt.preview.max_height),ih)':force_original_aspect_ratio=decrease:flags=fast_bilinear",
    ])
  }

	$cmd_args = ($cmd_args | append [
		"-f", "image2",
		"-y", $cache,
  ])

  let output = (run-external ffmpeg ...$cmd_args | complete)
  if $output.stderr != "" {
    error make -u { msg: $"Failed to start `ffmpeg`, error: ($output.stderr)" }
  } else if $output.exit_code != 0 {
    error make -u { msg: $"`ffmpeg` exited with error code: ($output.exit_code)" }
  }

  return $cache
}
