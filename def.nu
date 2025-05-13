
export def to-repo [] {
  url parse | get path | path split | skip | first 2 | path join
}

export def tempeditor [
  data: any,
  --suffix(-s): string = "",
  --output(-o),
] {
  let trimmed_data = ($data | str trim)
  if ($trimmed_data | is-empty) {
    return
  }

  let temp_file = (mktemp --tmpdir --suffix $suffix)
  $trimmed_data | save --force $temp_file

  hx $temp_file

  if $output {
    open $temp_file | str trim
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

export def --wrapped brave-browser [...rest: string, --dir(-d): string, --rm] {
  let basename = if ($dir | is-not-empty) {
    $"Brave-Browser-($dir | str upcase)"
  } else {
    "Brave-Browser"
  }
  let data_path = ($env.HOME | path join .config/BraveSoftware/ $basename)
  if $rm {
    rm -rf $data_path
  }
  let args = [
    --enable-features=UseOzonePlatform
    --ozone-platform=wayland
    --user-data-dir=($data_path)
  ]
  job spawn {|| ^brave-browser ...$args ...$rest }
}

export def --wrapped vieb-browser [...rest: string, --dir(-d): string, --rm ] {
  let basename = if ($dir | is-not-empty) {
    $"Vieb-($dir | str upcase)"
  } else {
    "Vieb"
  }
  let data_path = ($env.HOME | path join .config/ $basename)
  if $rm {
    rm -rf $data_path
  }
  let args = [
    '--config-file=~/.config/Vieb/viebrc'
    $'--datafolder=($data_path)'
  ]
  job spawn {|| ^vieb ...$args ...$rest }
}

export def nault [] {
  brave-browser --dir=nault --app=https://nault.cc/configure-wallet
}

export def images-preview [] {
  # let preview = "img2sixel -w $FZF_PREVIEW_COLUMNS -h $FZF_PREVIEW_LINES {}"
  let preview = "chafa --size=$(echo $FZF_PREVIEW_COLUMNS)x$(echo $FZF_PREVIEW_LINES) {}"
  fd -e jpg -e jpg -e png | fzf --style full --layout reverse --preview $preview --preview-window=right:70%
}
