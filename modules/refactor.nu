
export def code-role [] {
'Provide only code as output without any description.
Provide only code in plain text format without Markdown formatting.
Do not include symbols such as ``` or ```go.
If there is a lack of details, provide most logical solution.
You are not allowed to ask for more details.
For example if the prompt is "Hello world Golang", you should return "fmt.Println("Hello world")".'
}

export def "rename model" [] {
  ambr 'model/bun"' 'model/mongo"' internal/admin/domain/mongo
  ambr 'model/bun"' 'model/mongo"' internal/admin/usecase
}

export def "rename domain" [] {
  ambr 'internal/model/mongo"' 'internal/model/bun"' internal/admin/domain/
}

export def "rename usecase" [] {
  ambr 'internal/model/bun"' 'internal/model/mongo"' internal/user/usecase/
  ambr 'internal/model/bun"' 'internal/model/mongo"' internal/admin/usecase/

  ambr 'user/domain/bun"' 'user/domain/mongo"' internal/user/usecase/
  ambr 'admin/domain/bun"' 'admin/domain/mongo"' internal/admin/usecase/
}

export def "rename handler" [] {
  ambr 'model/bun"' 'model/mongo"' internal/controller/http/

  ambr 'user/domain/bun"' 'user/domain/mongo"' internal/controller/http/
  ambr 'admin/domain/bun"' 'admin/domain/mongo"' internal/controller/http/v1/handler/admin/
}

export def "rename repository" [] {
  ambr 'internal/user/domain"' 'internal/user/domain/bun"'
}

export def object [] {
  ambs 'bun.BaseModel' internal/model/mongo/
  ambs 'primitive.ObjectID' internal/model/mongo/

  ambr 'primitive.ObjectID' 'string' internal/model/mongo/
}

export def format [] {
	ambr '"go.mongodb.org/mongo-driver/bson/primitive"' '' internal/model/mongo/
  gofmt -w internal/model/mongo/
}

export def "rename admin" [] {
  ambr 'admin/domain"' 'admin/domain/bun"' internal/admin/repository/
  ambr 'admin/domain"' 'admin/domain/bun"' internal/admin/usecase/

  ambr 'model/mongo"' 'model/bun"' internal/admin/usecase/

  ambr 'admin/domain"' 'admin/domain/bun"' internal/controller/http/v1/handler/admin
  ambr 'admin/domain"' 'admin/domain/bun"' internal/controller/http/v1/middleware/admin
}

export def model [] {
  for $src in (ls internal/model/bun/ | get name) {
    let dst = ("internal/model/mongo/" | path join ($src | path basename))
    if ($dst | path exists) {
      continue
    }

    let text = "Combierte este modelo a mongo driver, convierte el ID  en un primitive.ObjectID:\n"
    open $src | mods --quiet (code-role) $text (open $src) | save $dst
    go fmt $dst
    bat --plain --paging never $dst
  }
}

export def repository [] {
  let example = "internal/admin/repository/mongo/support_message.go"

  for $src in (ls internal/admin/repository/bun/ | get name) {
    let basename = ($src | path basename)
    let model = ("internal/model/mongo/" | path join $basename)
    let dst = ("internal/admin/repository/mongo/" | path join $basename)
    if ($dst | path exists) {
      continue
    }

    mut query = [
      $"Eres un experto en golang" 
      $"Repositorio de ejemplo: \n(open $example)"
      "Guarda las collecciones que se necesiten"
      "Renombra la importacion de: "
      "/internal/model/bun a /internal/model/mongo,"
      "/internal/admin/domain/bun a /internal/admin/domain/mongo"
      $"Cambia el codigo de este repositorio a mongo: \n(open $src)"
    ]
    if ($model | path exists) {
      $query = ($query | append $"Este es su modelo: \n(open $model)")
    }

    mods --quiet (code-role) ...$query | tee { save --force $dst }
    try {
      go fmt $dst
    }

    hx $dst

    lint $dst
    
    loop {
      let input = (gum input)
      match $input {
        "ok" => {
          break
        },
        "change" => {
          $query = ($query | append $"no cambiaste nada, todo sigue igual, porfavor cambialo a mongo")
          continue
        },
        _ => {
          $query = ($query | append $input) 
        }
      }
    }
  }
}

def confirm [prompt: string] {
  try {
    gum confirm $prompt
    return true
  } catch {
    return false
  }
}

export def lint [dst: string] {
  loop {
    let lint = (golangci-lint run $dst | complete | get stdout)
    if ($lint | is-empty) {
      break
    }
    if not (confirm "verificar con el linter?") {
      break
    }
    print $lint
    mods --quiet (code-role) $"Del siguiente codigo: \n(open $dst)" $"soluciona los siguientes errores del codigo: ($lint)" | tee { save --force $dst }
  }
}
