
export-env {
  $env.DOCKER_FILES = ($env.NU_BASE_PATH | path join files docker)
}

export def air [] {
  docker build -t local/air:latest ($env.DOCKER_FILES | path join air)
}

export def lazyvim [] {
  docker build -t local/lazyvim:latest ($env.DOCKER_FILES | path join lazyvim)
}

export def astronvim [] {
  docker build -t local/astronvim:latest ($env.DOCKER_FILES | path join astronvim)
}

export def lunarvim [] {
  docker build -t local/lunarvim:latest ($env.DOCKER_FILES | path join lunarvim)
}

export def nvchad [] {
  docker build -t local/nvchad:latest ($env.DOCKER_FILES | path join nvchad)
}

export def clean [] {
  docker image rm ...(docker images | from ssv | where TAG == <none> | get "IMAGE ID")
}
