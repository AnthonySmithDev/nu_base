
def nano-rpc [body: record] {
   http post -u $env.NANO_USER -p $env.NANO_PASS -t 'application/json' $env.NANO_RPC $body
}

export def account-balance [account: string] {
   nano-rpc {
      action: 'account_balance'
      account: $account
      include_only_confirmed: 'false'
   }
}

export def account-block-count [account: string] {
   nano-rpc {
      action: 'account_block_count'
      account: $account
   }
}

export def account-history [account: string] {
   nano-rpc {
      action: 'account_history'
      account: $account
      count: -1
   }
}

export def account-info [account: string] {
   nano-rpc {
      action: 'account_info'
      account: $account
   }
}

export def block-count [] {
   nano-rpc {
      action: 'block_count'
   }
}

export def block-info [hash: string] {
   nano-rpc {
      action: 'block_info'
      json_block: 'true'
      hash: $hash
   }
}

export def deterministic-key [seed: string, index: int] {
   nano-rpc {
      action: 'deterministic_key'
      seed: $seed
      index: $index
   }
}

export def key-create [] {
   nano-rpc {
      action: 'key_create'
   }
}

export def key-expand [key: string] {
   nano-rpc {
      action: 'key_expand'
      key: $key
   }
}

export def receivable [account: string] {
   nano-rpc {
      action: 'receivable'
      account: $account
      source: 'true'
      sorting: 'true',
      include_active: 'true'
      include_only_confirmed: 'false'
   }
}

export def telemetry [] {
   nano-rpc {
      action: 'telemetry'
   }
}

export def version [] {
   nano-rpc {
      action: 'version'
   }
}

export def unchecked [] {
   nano-rpc {
      action: 'unchecked'
      json_block: 'true'
   }
}

export def work-peers [] {
   nano-rpc {
      action: 'work_peers'
   }
}

export def work-peer-add [address: string, port: int] {
   nano-rpc {
      action: 'work_peer_add'
      address: $address
      port: $port
   }
}

export def work-peer-clear [] {
   nano-rpc {
      action: 'work_peer_clear'
   }
}

export def work-generate [hash: string] {
   nano-rpc {
      action: 'work_generate'
      hash: $hash
   }
}

export def work-cancel [hash: string] {
   nano-rpc {
      action: 'work_cancel'
      hash: $hash
   }
}

export def nano-to-raw [amount: string] {
   nano-rpc {
      action: 'nano_to_raw'
      amount: $amount
   }
}

export def raw-to-nano [amount: string] {
   nano-rpc {
      action: 'raw_to_nano'
      amount: $amount
   }
}

export def work-benchmark [count: int] {
   http post -u $env.NANO_USER -p $env.NANO_PASS -t 'application/json' $env.NANO_WORK {
      action: 'benchmark'
      count: $count
   }
}

export def ledger-download [] {
   let url = (http get https://s3.us-east-2.amazonaws.com/repo.nano.org/snapshots/latest | str trim)
   https download $url
}

export def subscribe [...accounts: string] {
   mut json = { action: "subscribe", topic: "confirmation" }
   if ($accounts | is-not-empty) {
      $json = ($json | insert options { accounts: $accounts })
   }
   return ($json | to json)
}

export def wscat [...accounts: string] {
   print $env.NANO_WS
   let msg = (subscribe ...$accounts)
   print $msg
   ^wscat --connect $env.NANO_WS --wait 1000 --execute $msg
}

export def wsget [...accounts: string] {
   print $env.NANO_WS
   let msg = (subscribe ...$accounts)
   ^wsget $env.NANO_WS --request $msg
}

export alias ws = wsget

const min = 0.000001

export def uri [address: string, amount: float = $min, label: string = "", message: string = ""] {
   let query = { amount: ($amount * (10.0 ** 30)), label: $label, message: $message }
   return $"nano:($address)?($query | url build-query)"
}

export def qr [address: string, amount: float = $min, label: string = "", message: string = ""] {
   let uri = (uri $address $amount $label $message)
   # $uri | qrencode -t ANSI -s 1 -m 1
   qrrs $uri -m 1
}

export def nodes [] {
   {
      "payzum": {
         "user": "node"
         "pass": "Temporal1!"
         "ws": "wss://nano-ws-n1.payzum.com"
         "rpc": "https://nano-http-n1.payzum.com"
      }
      "yoda": {
         "user": ""
         "pass": ""
         "ws": "ws://yoda:7078"
         "rpc": "http://yoda:7076"
      }
      "nanopay": {
         "user": ""
         "pass": ""
         "ws": "wss://nano-yoda1.nanopay.one"
         "rpc": ""
      }
   }
}

export def names [] {
   nodes | columns
}

export def --env set [name: string@names] {
   let nano = (nodes | get $name)
   $env.NANO_USER = $nano.user
   $env.NANO_PASS = $nano.pass
   $env.NANO_WS = $nano.ws
   $env.NANO_RPC = $nano.rpc

   $env.NANO_WORK = $nano.rpc
   # $env.NANO_WORK = 'http://192.168.0.23:7076'
   # $env.NANO_WORK = 'http://100.74.189.100:3090' # jose antonio
   # $env.NANO_WORK = 'http://100.98.177.106:7076' # jose luis
   # $env.NANO_WORK = 'http://100.65.103.111:7076' # aron
}
