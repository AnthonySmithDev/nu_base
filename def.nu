
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
  job spawn {|| ^brave ...$args ...$rest }
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

export def xdg-default [] {
  xdg-settings set default-web-browser brave-browser.desktop
  xdg-settings set default-url-scheme-handler http brave-browser.desktop
  xdg-settings set default-url-scheme-handler https brave-browser.desktop
}

export def run-cachy [
  --disk: path = "cachyos.qcow2",
  --iso: path = "cachyos-desktop-linux-250422.iso",
] {
  if not ($disk | path exists) {
    qemu-img create -f qcow2 $disk 20G
  }

  let args = [
    -enable-kvm
    -m 8G
    -cpu host
    -smp cores=4
    -boot menu=on
    -hda $disk
    -nic "user,model=virtio-net-pci"
    -cdrom $iso
  ]

  qemu-system-x86_64 ...$args
}

export def run-arch [
  --disk: string = "archlinux.qcow2",
  --iso: string = "archlinux-2025.05.01-x86_64.iso",
] {
  if not ($disk | path exists) {
    qemu-img create -f qcow2 $disk 20G
  }

  let args = [
    -enable-kvm
    -m 8G
    -cpu host
    -smp cores=4
    -boot menu=on
    -hda $disk
    -nic "user,model=virtio-net-pci"
    -cdrom $iso
  ]

  qemu-system-x86_64 ...$args
}

export def pastes [input: string, --save(-s): string] {
  if $input =~ "https://pastes.dev" {
    let path = ($input | url parse | get path)
    let url = ("https://api.pastes.dev" + $path)
    let body = http get $url
    if ($save | is-empty) {
      $body
    } else {
      $body | save -f $save
    }
  } else {
    curl -s -T $input https://api.pastes.dev/post
  }
}

export def hyde-install [] {
  sudo pacman -S --needed git base-devel
  git clone --depth 1 https://github.com/HyDE-Project/HyDE ~/HyDE
  cd ~/HyDE/Scripts
  bash ./install.sh
}

export def bnb-ws [
  addr: string = "0x82F5F0599371081448456Cd951b645EdeA56760c",
  --url: string = "ws://167.235.203.170:3011"
] {
  let msg = {
    "action":"subscribe",
    "filters":[{
      "address": $addr,
      "type":"BALANCE_UPDATE",
      "currency":"BNB"
    }]
  }
  wsget $url -r ($msg | to json)
}

export def copy-session-password [] {
  "website hashing saved gymnast lullaby occur salads yodel fewest ceiling dazed eldest gymnast" | wl-copy
}

export def aron-nano-work [] {
  ssh Aron 'C:\Users\Aaron\Documents\nano-work-server\nano-work-server.exe -c 0 -g 0:0 -l 0.0.0.0:7076'
}

export def repeat [closure: closure] {
  loop {
    let input = input listen --types [key]
    if ("keymodifiers(control)" in $input.modifiers) and $input.code == "c" {
      return
    }
    if $input.code == "esc" {
      return
    }
    if $input.code == "enter" {
      print (do $closure)
    }
    continue
  }
}

export def drum [] {
  brave --app=https://www.virtualdrumming.com/drums/coordinated-independence/drums-basic-rock-1.html
}
