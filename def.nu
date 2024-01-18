
def 'edit env' [] {
  hx ($env.REPO_PATH | path join 'nushell' 'env.nu')
}

def 'edit alias' [] {
  hx ($env.REPO_PATH | path join 'nushell' 'alias.nu')
}

def 'edit def' [] {
  hx ($env.REPO_PATH | path join 'nushell' 'def.nu')
}

def 'edit init' [] {
  hx ($env.REPO_PATH | path join 'nushell' 'init')
}

def 'edit module' [] {
  hx ($env.REPO_PATH | path join 'nushell' 'module')
}

def 'edit nu' [] {
  hx ($env.REPO_PATH | path join 'nushell')
}

def seed [] {
  cat /dev/urandom | tr -dc '0-9A-F' | head -c 64
}

def 'chmod nu_base' [] {
  chmod +x bash/shell.sh
  chmod +x bash/install.sh

  fd --type file --exec chmod 666 {}
  fd --type dir --exec chmod 755 {}
}

def trans [ ...text: string ] {
  docker run -it --rm soimort/translate-shell -b :es ($text | str join ' ')
}

def 'nu gitignore list' [] {
  http get 'https://www.toptal.com/developers/gitignore/api/list?format=lines' | lines
}

def gitignore [lang: string@'nu gitignore list'] {
  http get $'https://www.toptal.com/developers/gitignore/api/($lang)' | save .gitignore
}

def help! [cmd?: string] {
  let pipe = $in

  if $pipe != null {
    $pipe | bat --plain --language help
    return
  }

  if $cmd != null {
    if (which bat | is-empty) {
      ^$cmd --help
    } else {
      ^$cmd --help | bat --plain --language help
    }
    return
  }
}

def json [] {
  to json | jless --mode line
}

def "sc json" [] {
  let input = $in
  let args = [
    "--to-clipboard"
    "--no-line-number"
    "--no-window-controls" 
    "--background" "#0B0E14" 
    "--language" "json"
  ]
  $input | to json | silicon ...$args
}

def "sc go" [] {
  let input = $in
  let args = [
    "--to-clipboard"
    "--no-line-number"
    "--no-window-controls" 
    "--background" "#0B0E14" 
    "--language" "go"
  ]
  $input | silicon ...$args
}

def "sc js" [] {
  let input = $in
  let args = [
    "--to-clipboard"
    "--no-line-number"
    "--no-window-controls" 
    "--background" "#0B0E14" 
    "--language" "js"
  ]
  $input | silicon ...$args
}

def run-openai [] {
  let models = [
    llama2
    mistral
    codellama
    llama2-uncensored
    vicuna
    llava
  ]

  let model = (gum choose $models)

  if (^which ollama | is-empty) {
    print 'download ollama'
    return
  }
  if (^which litellm | is-empty) {
    print 'download litellm'
    return
  }
  if (ps | where name =~ ollama | is-empty) {
    bash -c 'nohup ollama serve &' 
  }
  if (ollama list | find $model | is-empty) {
    ollama pull $model
  }
  litellm --model ("ollama" | path join $model) --api_base http://localhost:11434
}

def vieb [
  --left(-l)
  --right(-r)
] {
  if $left {
    bg vieb --datafolder=~/.config/ViebLeft --config-file=~/.config/Vieb/viebrc
    return
  }
  if $right {
    bg vieb --datafolder=~/.config/ViebRight --config-file=~/.config/Vieb/viebrc
    return
  }
  bg vieb
}

def brave [
  url?: string
  --left(-l)
  --right(-r)
  --proxy(-p)
] {
  mut args = []
  if $proxy {
    $args = ($args | append '--proxy-server=localhost:8080')
  }
  if ($url != null) {
    $args = ($args | append $url)
  }
  if $left {
    let data = ($env.HOME | path join .config brave-browser-left)
    bg brave-browser --user-data-dir=($data) ...$args
    return
  }
  if $right {
    let data = ($env.HOME | path join .config brave-browser-right)
    bg brave-browser --user-data-dir=($data) ...$args
    return
  }
  bg brave-browser ...$args
}

def chrome [
  url?: string
  --left(-l)
  --right(-r)
  --proxy(-p)
] {
  mut args = []
  if $proxy {
    $args = ($args | append '--proxy-server=localhost:8080')
  }
  if ($url != null) {
    $args = ($args | append $url)
  }
  if $left {
    let data = ($env.HOME | path join .config google-chrome-left)
    bg google-chrome --user-data-dir=($data) ...$args
    return
  }
  if $right {
    let data = ($env.HOME | path join .config google-chrome-right)
    bg google-chrome --user-data-dir=($data) ...$args
    return
  }
  bg google-chrome ...$args
}

def mitmproxy-crt [] {
  let src = ($env.HOME | path join .mitmproxy mitmproxy-ca-cert.pem)
  let dest = ($env.HOME | path join Documents mitmproxy.pem)
  if not ($src | path exists) {
    return
  }
  cp $src $dest
  sudo cp $src /usr/local/share/ca-certificates/mitmproxy.crt
  sudo update-ca-certificates
}

def proxify-crt [] {
  let src = ($env.HOME | path join .config proxify cacert.pem)
  let dest = ($env.HOME | path join Documents proxify.pem)
  if not ($src | path exists) {
    return
  }
  cp $src $dest
  sudo cp $src /usr/local/share/ca-certificates/proxify.crt
  sudo update-ca-certificates
}

def --env ci [] {
  let path = gum file --file --directory
  if ($path | path type) == 'file' {
    hx $path
  } else if ($path | path type) == 'dir' {
    # cd $path
    with-env { PWD: $path } { nu }
  }
}

def --wrapped bg [...rest] {
  let cmd = $"($rest | str join ' ') > /dev/null 2>&1 &"
  bash -c $cmd
}
