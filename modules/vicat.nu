#!/usr/bin/env nu

export def main [
  ...files: path,
  --width(-W): int,
  --height(-H): int,
  --force(-f)
] {
  let tmp_dir = "/tmp/vicat"
  if not ($tmp_dir | path exists) {
    mkdir $tmp_dir
  }

  for $file in $files {
    handle_file $file $width $height $force
  }
}

def handle_file [
  file: path,
  width?: int,
  height?: int,
  force?: bool
] {
  if ($file | path type) != "file" {
    return
  }

  let size = (term size)
  let display_size = $"($width | default $size.columns)x($height | default $size.rows)"

  let mime_type = (get_mime_type $file)
  if $mime_type =~ "image/" {
    display_image $file $display_size
  } else if $mime_type =~ "video/" {
    display_video $file $display_size $force
  } else {
    print $"Unsupported file type: ($mime_type)"
  }
}

def get_mime_type [file: path] {
  file --mime-type $file | str trim | split row ": " | last
}

def display_image [file: path, size: string] {
  chafa --size $size $file
}

def display_video [file: path, size: string, force: bool] {
  let image_path = $"/tmp/vicat/($file | hash md5).png"

  if not ($image_path | path exists) or $force {
    let args = [
      "-v", "quiet",
      "-ss", "00:00:10",
      "-i", $file,
      "-vframes", "1",
      "-q:v", "9",
      "-y", $image_path
    ]
    ^ffmpeg ...$args
  }

  if ($image_path | path exists) {
    chafa --size $size $image_path
  }
}

export def clean [] {
  rm -rf /tmp/vicat/*
}
