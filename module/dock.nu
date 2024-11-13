
export def --wrapped ps [ ...rest ] {
  ^docker ps ...$rest | from ssv --aligned-columns
}

export def --wrapped volumes [ ...rest ] {
  ^docker volume ls ...$rest | from ssv --aligned-columns
}

export def --wrapped images [ ...rest ] {
  ^docker images ...$rest | from ssv --aligned-columns
}

export def --wrapped networks [ ...rest ] {
  ^docker network ls ...$rest | from ssv --aligned-columns
}

export def 'container exists' [ name: string ] {
  ps | where NAMES =~ $name | is-not-empty
}

export def 'volume exists' [ name: string ] {
  volumes | where 'VOLUME NAME' =~ $name | is-not-empty
}

export def 'image exists' [ name: string ] {
  images | where REPOSITORY =~ $name | is-not-empty
}

export def 'network exists' [ name: string ] {
  networks | where NAME =~ $name | is-not-empty
}
