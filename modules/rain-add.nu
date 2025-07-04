#!/usr/bin/env nu

def main [url: string] {
  let id = random chars --length 8
  rain client add --id $id --torrent $url
  let name = (rain client list | from json | where ID == $id | first | get Name)
  (
    notify-send
    --app-name "Rain"
    --icon $"($env.HOME)/.local/share/icons/rain.png"
    "Rain add torrent"
    $"Torrent successfully added ($name)"
  )
}
