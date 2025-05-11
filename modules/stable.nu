
export def txt2img [prompt: string] {
  let body = { prompt: $prompt }
  let r = http post --content-type application/json http://r2v2:8081/sdapi/v1/txt2img $body
  for image in ($r | get images) {
    let filename = mktemp XXX.jpeg
    $image | decode base64 | save -p -f $filename
  }
}

export def img2img [init: path, prompt: string] {
  let body = { prompt: $prompt, init_images: [$"(open $init | encode base64)"]}
  let r = http post --content-type application/json http://r2v2:8081/sdapi/v1/img2img $body
  for image in ($r | get images) {
    let filename = mktemp XXX.jpeg
    $image | decode base64 | save -p -f $filename
  }
}
