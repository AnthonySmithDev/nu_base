
export def nano-work-server [] {
  ^nano-work-server --gpu 0:0 -l 0.0.0.0:7076
}

export def ollama-serve [] {
   OLLAMA_HOST="0.0.0.0:11434" ^ollama serve
}

export def mysql-server [] {
  docker run --rm -d --name mysql-server -p 3306:3306 -e MYSQL_ROOT_PASSWORD=pass -e MYSQL_DATABASE=example mysql:latest
}

def compose-file [os: string] {
  $env.HOME | path join nu/nu_files/docker/os/($os)/compose.yaml
}

def linux-versions [] {
  [
    [value, description];
    ["alma" "Alma Linux 2.2 GB"]
    ["alpine" "Alpine Linux 60 MB"]
    ["arch" "Arch Linux 1.2 GB"]
    ["cachy" "CachyOS 2.6 GB"]
    ["centos" "CentOS 7.0 GB"]
    ["debian" "Debian 3.3 GB"]
    ["fedora" "Fedora 2.3 GB"]
    ["gentoo" "Gentoo 3.6 GB"]
    ["kali" "Kali Linux 3.8 GB"]
    ["kubuntu" "Kubuntu 4.4 GB"]
    ["mint" "Linux Mint 2.8 GB"]
    ["manjaro" "Manjaro 4.1 GB"]
    ["mx" "MX Linux 2.2 GB"]
    ["nixos" "NixOS 2.4 GB"]
    ["suse" "OpenSUSE 1.0 GB"]
    ["oracle" "Oracle Linux 1.1 GB"]
    ["rocky" "Rocky Linux 2.1 GB"]
    ["slack" "Slackware 3.7 GB"]
    ["tails" "Tails 1.5 GB"]
    ["ubuntu" "Ubuntu Desktop 6.0 GB"]
    ["ubuntus" "Ubuntu Server 3.0 GB"]
    ["xubuntu" "Xubuntu 4.0 GB"]
  ]
}

export def --wrapped linux [
  ...args: string
  --iso(-i): string
  --name(-n): string
  --boot(-b): string@linux-versions = "ubuntu"
  --ram-size(-r): string = "4G"
  --cpu-cores(-c): string = "4"
  --disk-size(-d): string = "128G"
  --novnc-port(-n): string = "8006"
] {

  if $iso != null {
    $env.VOLUMEN_KEY = ($iso | path expand)
    $env.VOLUMEN_VALUE = "/boot.iso"
    $env.STORAGE = $name
  } else {
    $env.BOOT = $boot
    $env.STORAGE = $boot
  }

  $env.RAM_SIZE = $ram_size
  $env.CPU_CORES = $cpu_cores
  $env.DISK_SIZE = $disk_size

  docker compose --file (compose-file linux) ...$args 
}

def windows-versions [] {
  [
    [value, description];
    ["11" "Windows 11 Pro 5.4 GB"]
    ["11l" "Windows 11 LTSC 4.7 GB"]
    ["11e" "Windows 11 Enterprise 4.0 GB"]
    ["10" "Windows 10 Pro 5.7 GB"]
    ["10l" "Windows 10 LTSC 4.6 GB"]
    ["10e" "Windows 10 Enterprise 5.2 GB"]
  ]
}

export def --wrapped windows [
  ...args: string
  --iso(-i): string
  --name(-n): string
  --version(-v): string@windows-versions = "11"
  --ram-size(-r): string = "4G"
  --cpu-cores(-c): string = "4"
  --disk-size(-d): string = "128G"
  --username(-u): string = "admin"
  --password(-p): string = "admin"
  --novnc-port(-n): string = "8006"
  --rdp-port: string = "3389"
] {

  if $iso != null {
    $env.VOLUMEN_KEY = ($iso | path expand)
    $env.VOLUMEN_VALUE = "/boot.iso"
    $env.STORAGE = $name
  } else {
    $env.VERSION = $version
    $env.STORAGE = $version
  }

  $env.RAM_SIZE = $ram_size
  $env.CPU_CORES = $cpu_cores
  $env.DISK_SIZE = $disk_size
  $env.USERNAME = $username
  $env.PASSWORD = $password
  $env.NOVNC_PORT = $novnc_port
  $env.RDP_PORT = $rdp_port

  docker compose --file (compose-file windows) ...$args 
}

def macos-versions [] {
  [
    [value, description];
    ["15"	"macOS 15	Sequoia"]
    ["14"	"macOS 14	Sonoma"]
    ["13"	"macOS 13	Ventura"]
    ["12"	"macOS 12	Monterey"]
    ["11"	"macOS 11	Big Sur"]
  ]
}

export def --wrapped macos [
  ...args: string
  --version(-v): string@macos-versions = "15"
  --ram-size(-r): string = "8G"
  --cpu-cores(-c): string = "8"
  --disk-size(-d): string = "256G"
  --novnc-port(-n): string = "8006"
  --vnc-port: string = "5900"
] {

  $env.VERSION = $version
  $env.RAM_SIZE = $ram_size
  $env.CPU_CORES = $cpu_cores
  $env.DISK_SIZE = $disk_size
  $env.NOVNC_PORT = $novnc_port
  $env.VNC_PORT = $vnc_port

  docker compose --file (compose-file macos) ...$args 
}
