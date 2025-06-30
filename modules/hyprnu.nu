#!/usr/bin/env nu
#
$env.HYPR_HOME = ($env.HOME | path join .hypr)

# hyprctl --batch "dispatch togglefloating; dispatch resizeactive exact 95% 95%; dispatch centerwindow"

export def main [] {
  mkdir $env.HYPR_HOME

  let clients = (hyprctl clients -j | from json)
  let client = ($clients | where class == mpv | get 0?)
  let filename = ($env.HYPR_HOME | path join $"($client.address).json")

  if $client.floating {
    hyprctl dispatch settiled address:($client.address)
    if ($filename | path exists) {
      let client = open $filename
      hyprctl dispatch movewindow $client.at.0 $client.at.1, address:($client.address)
    } else {
      notify-send "not exists"
    }
  } else {
    $client | save --force $filename
    hyprctl dispatch setfloating address:($client.address)
  }
}
