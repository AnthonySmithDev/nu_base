
export def nano-work-server [] {
  ^nano-work-server --gpu 0:0 -l 0.0.0.0:7076
}

export def ollama-serve [] {
   OLLAMA_HOST="0.0.0.0:11434" ^ollama serve
}

export def mysql-server [] {
  docker run --rm -d --name mysql-server -p 3306:3306 -e MYSQL_ROOT_PASSWORD=pass -e MYSQL_DATABASE=example mysql:latest
}
