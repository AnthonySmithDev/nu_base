
let docker = ($env.REPO_PATH | path join docker)

with-env {PWD: ($docker | path join lazyvim)} {
  docker build -t lazyvim:latest .
}

with-env {PWD: ($docker | path join astronvim)} {
  docker build -t astronvim:latest .
}

with-env {PWD: ($docker | path join lunarvim)} {
  docker build -t lunarvim:latest .
}

with-env {PWD: ($docker | path join nvchad)} {
  docker build -t nvchad:latest .
}
