#!/usr/bin/env nu

def name [id: string] {
  rain client stats --id $id --json | from json | get Name
  # rain client list | from json | where ID == $id | first | get Name
}

def notify-success [id: string] {
  (
    notify-send
    --app-name "Rain"
    --icon $"($env.HOME)/.local/share/icons/rain.png"
    "Rain success"
    $"Torrent successfully added:\n(name $id)"
  )
}

def notify-error [url: string] {
  (
    notify-send
    --app-name "Rain"
    --icon $"($env.HOME)/.local/share/icons/rain.png"
    --urgency critical
    --expire-time 5000
    "Rain error"
    $"Failed to add torrent from:\n($url)"
  )
}

def main [url: string] {
  let id = random chars --length 4
  try {
    rain client add --id $id --torrent $url
    notify-success $id
  } catch {
    notify-error $url
  }
}
