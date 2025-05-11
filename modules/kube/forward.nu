
export def redis [] {
  services port-forward redis-payzum 16380 6379
}

export def mysql [] {
  services port-forward mariadb-payzum 13307 3306
}

export def mongo [] {
  services port-forward mongo-payzum 17018 27017
}

export def user [] {
  services port-forward backend-main 13000 3000
}

export def p2p [] {
  services port-forward backend-p2p 13010 3010
}
