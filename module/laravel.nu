
export def build [name: string] {
  curl -s ("https://laravel.build/" + $name) | bash
}
