
export def 'example path' [s: string = ""] {
  $env.HOME | path join Documents/gitlab/payzum-backend/payzum-backend-main $s
}

export def 'project path' [s: string = ""] {
  $env.HOME | path join Documents/gitlab/payzum-backend/payzum-backend-nanod $s
}

export def 'edit domain' [count: int = 25 --skip: int = 0] {
  for file in (ls (example path internal/user/domain/mongo/) | get name | skip $skip | first $count) {
    gofmt -w $file
    goimports -w $file
    ^ox $file
  }
}

export def 'edit repository' [count: int = 25 --skip: int = 0] {
  for file in (ls (example path internal/user/repository/mongo/) | get name | skip $skip | first $count) {
    gofmt -w $file
    goimports -w $file
    hx $file
  }
}

export def 'create model' [count: int = 10 --skip: int = 0] {
  let bun = ("~/payzum/example-model-bun.txt" | path expand)
  if ($bun | path exists) {
    rm $bun
  }
  let files = (ls (example path internal/model/bun/) | get name | first $count)
  for $file in $files {
    open $file | save -a $bun
  }

  let mongo = ("~/payzum/example-model-mongo.txt" | path expand)
  if ($mongo | path exists) {
    rm $mongo
  }
  let files = (ls (example path internal/model/mongo/) | get name | first $count)
  for $file in $files {
    open $file | save -a $mongo
  }
}

export def 'create domain' [count: int = 10] {
  let bun = ("~/payzum/example-domain-bun.txt" | path expand)
  if ($bun | path exists) {
    rm $bun
  }
  let files = (ls (example path internal/user/domain/bun/) | get name | first $count)
  for $file in $files {
    open $file | save -a $bun
  }

  let mongo = ("~/payzum/example-domain-mongo.txt" | path expand)
  if ($mongo | path exists) {
    rm $mongo
  }
  let files = (ls (example path internal/user/domain/mongo/) | get name | first $count)
  for $file in $files {
    open $file | save -a $mongo
  }
}

export def 'create repository' [count: int = 10] {
  let bun = ("~/payzum/example-repository-bun.txt" | path expand)
  if ($bun | path exists) {
    rm $bun
  }
  let files = (ls (example path internal/user/repository/bun/) | get name | first $count)
  for $file in $files {
    open $file | save -a $bun
  }

  let mongo = ("~/payzum/example-repository-mongo.txt" | path expand)
  if ($mongo | path exists) {
    rm $mongo
  }
  let files = (ls (example path internal/user/repository/mongo/) | get name | first $count)
  for $file in $files {
    open $file | save -a $mongo
  }
}

export def 'role code' [] {
  [
    'Provide only code as output without any description.'
    'Provide only code in plain text format without Markdown formatting.'
    'Do not include symbols such as ``` or ```go.'
    'If there is a lack of details, provide most logical solution.'
    'You are not allowed to ask for more details.'
    # 'For example if the prompt is "Hello world Golang", you should return "fmt.Println("Hello world")".'
  ]
}

export def 'prompt repository' [] {
  [
    "estos son mis modelos de mysql: "
    $"(open ~/payzum/example-model-bun.txt)"
    "estos son mis repositorios de mysql: "
    $"(open ~/payzum/example-repository-bun.txt)"
    "estos son mis modelos de mongo: "
    $"(open ~/payzum/example-model-mongo.txt)"
    "estos son mis repositorios de mongo: "
    $"(open ~/payzum/example-repository-mongo.txt)"
  ]
}

export def 'prompt domain' [] {
  [
    "estos son mis modelos de bun: "
    $"(open ~/payzum/example-model-bun.txt)"
    "estos son mis modelos de mongo: "
    $"(open ~/payzum/example-model-mongo.txt)"
  ]
}

export def 'rename model' [] {
}

export def 'rename domain' [] {
  ambr 'internal/domain"' 'internal/domain/bun"' (project path internal/repository)
  ambr 'internal/domain"' 'internal/domain/bun"' (project path internal/usecase)
  ambr 'internal/domain"' 'internal/domain/bun"' (project path internal/handler)
}

export def 'rename repository' [] {
  ambr 'internal/repository/bun"' 'internal/repository/bun"' (project path)
}

export def 'rename usecase' [] {
}

export def 'create new domain' [] {
  let files = (ls (project path internal/domain/bun) | get name)
  for $file in $files {
    let basename = ($file | path basename)
    let dst = (project path internal/domain/mongo | path join $basename)
    if ($dst | path exists) {
      continue
    }
    mods --quiet ...(prompt domain) toma como ejemplo estos domain para convertirme este dominio de bun a mongo: (open $file) ...(role code) | tee { save --force $dst }
    try {
      gofmt -w $dst
      goimports -w $dst
    }
    hx $dst
    # return
  }
  return "ok"
}

export def 'create new repository' [] {
  let files = (ls (project path internal/repository/bun) | get name)
  for $file in $files {
    let basename = ($file | path basename)
    let dst = (project path internal/repository/mongo | path join $basename)
    if ($dst | path exists) {
      continue
    }
    mods --quiet ...(prompt repository) tomo como ejemplo mis repositorio y modelos para convertirme este codigo de bun a mongo: (open $file) ...(role code) | tee { save --force $dst }
    try {
      gofmt -w $dst
      goimports -w $dst
    }
    hx $dst
    # return
  }
  return "ok"
}
