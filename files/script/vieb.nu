#!/usr/bin/env nu

export def main [path: path] {
  alacritty --command hx $path
}
