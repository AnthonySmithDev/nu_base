
export def --wrapped ps [ ...rest ] {
  ^docker ps ...$rest | from ssv --aligned-columns
}

export def --wrapped 'volume ls' [ ...rest ] {
  ^docker volume ls ...$rest | from ssv --aligned-columns
}

export def 'container exists' [ name: string ] {
  ps | where NAMES =~ $name | is-not-empty
}

export def 'volume exists' [ name: string ] {
  volume ls | where NAMES =~ $name | is-not-empty
}
