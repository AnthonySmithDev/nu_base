
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

alias bhelp = bat --plain --language help

def shelp [cmd] {
  ^$cmd --help | bhelp
}

def json [] {
  to json | jless --mode line
}

def sjson [] {
  let input = $in
  let args = [
    "--to-clipboard"
    "--no-line-number"
    "--no-window-controls" 
    "--background" "#0B0E14" 
    "--language" "json"
  ]
  $input | to json | silicon $args
}

def sgo [] {
  let input = $in
  let args = [
    "--to-clipboard"
    "--no-line-number"
    "--no-window-controls" 
    "--background" "#0B0E14" 
    "--language" "go"
  ]
  $input | silicon $args
}

def highlight [--lines(-l): string] {
  let args = $in
  if not ($lines | is-empty) {
    ($args | append ["--highlight-lines" $lines])
  } else {
    $args
  }
}

def scode [
  input: string
  --lines (-l): string
] {
  mut args = [
    "--to-clipboard"
    "--no-window-controls"
    "--background" "#ABB8C3"
  ]
  silicon $input ($args | highlight -l $lines)
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

def --env ci [] {
  let path = gum file --file --directory
  if ($path | path type) == 'file' {
    hx $path
  } else if ($path | path type) == 'dir' {
    # cd $path
    with-env { PWD: $path } { nu }
  }
}
