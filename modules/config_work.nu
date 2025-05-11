
def bind [dir_src: string, dir_dst: string, file_src: string, file_dst: string] {
  let path_src = ($env.NU_WORK_PATH | path join files config $dir_src $file_src)

  let dir = ($env.HOME | path join $dir_dst)
  if not ($dir | path exists) {
    mkdir $dir
  }

  let path_dst = ($dir | path join $file_dst)
  if ($path_dst | path exists) {
    rm -f $path_dst
  }

  ln -sf $path_src $path_dst
}

export def bitcoin [] {
  bind bitcoin .bitcoin client.conf bitcoin.conf
}

export def kube [] {
  bind kube .kube config config
}

export def gitlab [] {
  glab config set -g -h $env.GITLAB_HOST token $env.GITLAB_TOKEN
  glab config set -g -h $env.GITLAB_HOST api_protocol http
  glab config set -g -h $env.GITLAB_HOST git_protocol ssh
}

export def work [] {
  bitcoin
  gitlab
  kube
}
