
def commands [] {
  ^bitcoin-cli help | lines | each {|e|
    if ($e | is-empty) {
      return null
    }
    if ($e | str contains "==") {
      return null
    }
    return ($e | split row " " | first)
  }
}

export def --wrapped cli [command: string@commands, ...params: string] {
  let args = [
    -rpcconnect=($env.BITCOIN_RPC_HOST)
    -rpcport=($env.BITCOIN_RPC_PORT)
    -rpcuser=($env.BITCOIN_RPC_USER)
    -rpcpassword=($env.BITCOIN_RPC_PASS)
  ]
  ^bitcoin-cli --testnet ...$args $command ...$params
}

export def rpc [method: string@commands, ...params: any] {
  let url = {
    "scheme": "http",
    "username": $env.BITCOIN_RPC_USER,
    "password": $env.BITCOIN_RPC_PASS,
    "host": $env.BITCOIN_RPC_HOST,
    "port": $env.BITCOIN_RPC_PORT,
  }

  let body = {
    id: "rpc",
    jsonrpc: "1.0",
    method: $method,
    params: $params,
  }

  let resp = http post --allow-errors ($url | url join) ($body | to json)
  if ($resp.error | is-not-empty) {
    return $resp.error
  }
  return $resp.result
}

def getblockcount [] {
  [(rpc getblockcount)]
}

export def block [height: int@getblockcount, tx?: string] {
  let hash = (rpc getblockhash $height)
  let txs = (rpc getblock $hash 3 | get tx)
  if ($tx | is-empty) {
    return $txs
  }
  for $it in ($txs | enumerate) {
    if $it.item.txid == $tx {
      return ($it.item | insert "index" $it.index)
    }
  }
}

export def mem [tx?: string] {
  let mempool = (rpc getrawmempool)
  if ($tx | is-empty) {
    return $mempool
  }
  for $it in ($mempool | enumerate) {
    if $it.item == $tx {
      return $it.index
    }
  }
}

export def tx [tx?: string] {
  curl -sSL https://mempool.space/testnet/api/tx/($tx) | from json
}

export def 'address txs' [address: string] {
  curl -sSL $"https://mempool.space/testnet/api/address/($address)/txs" | from json
}

export def 'address utxo' [address: string] {
  curl -sSL $"https://mempool.space/testnet/api/address/($address)/utxo" | from json
}

export def 'create tx' [] {
  cli createrawtransaction ''
}
