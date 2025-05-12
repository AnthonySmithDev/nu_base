
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

export def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}

export def brave-browser [--dir(-d): string] {
  let args = [
    --enable-features=UseOzonePlatform
    --ozone-platform=wayland
  ]
  let data_dir_name = if ($dir | is-not-empty) {
    $"Brave-Browser-($dir | str upcase)"
  } else {
    "Brave-Browser"
  }
  let data_dir_path = ($env.HOME | path join .config BraveSoftware $data_dir_name)
  job spawn {|| ^brave-browser ...$args --user-data-dir=($data_dir_path) }
}
