
export def 'ps kill' [] {
  let line = (ps | select pid name | each {|e| $"($e.pid) ($e.name)"}| to text | fzf --exact)
  if ($line | is-empty) {
    return
  }
  $line | parse '{pid} {name}' | first | kill ($in.pid | into int)
}

export def 'conn ls' [] {
  let input = (^lsof -i -n -P)
  let header = ($input | lines
                       | take 1
                       | each {|| str downcase | str replace ' name$' ' name state' })
  let body = ($input | lines
                     | skip 1
                     | each {|| str replace '([^)])$' '$1 (NONE)' | str replace ' \((.+)\)$' ' $1' })
  [$header] | append $body
            | to text
            | detect columns
            | upsert 'pid' { |r| $r.pid | into int }
            | rename --column { name: connection }
            | reject 'command'
}
