
def nano-rpc [body: record, --debug(-d)] {
   if $debug {
      print $body
   }
   let data = http post -u $env.NANO_USER -p $env.NANO_PASS -t "application/json" $env.NANO_RPC $body
   if "error" in $data {
      error make -u { msg: $data.error }
   }
   if $debug {
      print $data
   }
   return $data
}

export def account-balance [account: string] {
   nano-rpc {
      action: "account_balance"
      account: $account
      include_only_confirmed: "false"
   }
}

export def balance [account: string] {
   raw_to_nano (account-balance $account | get balance)
}

export def account-block-count [account: string] {
   nano-rpc {
      action: "account_block_count"
      account: $account
   }
}

export def account-history [account: string, --count(-c): int = -1] {
   nano-rpc {
      action: "account_history"
      account: $account
      count: $count
   }
}

export def account-info [account: string] {
   nano-rpc {
      action: "account_info"
      representative: "true"
      account: $account
   }
}

export def block-count [] {
   nano-rpc {
      action: "block_count"
   }
}

export def block-info [hash: string] {
   nano-rpc {
      action: "block_info"
      json_block: "true"
      hash: $hash
   }
}

export def block-create [previous: string, account: string, representative: string, balance: string, link: string, key: string] {
   nano-rpc {
      action: "block_create"
      json_block: "true"
      type: "state"
      previous: $previous
      account: $account
      representative: $representative
      balance: $balance
      link: $link
      key: $key
   }
}

export def deterministic-key [seed: string, index: int = 0] {
   nano-rpc {
      action: "deterministic_key"
      seed: $seed
      index: $index
   }
}

export def key-create [] {
   nano-rpc {
      action: "key_create"
   }
}

export def key-expand [key: string] {
   nano-rpc {
      action: "key_expand"
      key: $key
   }
}

export def receivable [account: string] {
   nano-rpc {
      action: "receivable"
      account: $account
      source: "true"
      sorting: "true",
      include_active: "true"
      include_only_confirmed: "false"
   } | to-receivable
}

def to-receivable [] {
   get blocks | transpose key value | each {|row| { block: $row.key, ...$row.value } }
}

def process_subtype [] {
   [send receive open change epoch]
}

export def process [subtype: string@process_subtype, block: record] {
   nano-rpc {
     action: "process",
     json_block: "true",
     subtype: $subtype,
     block: $block
   }
}

export def telemetry [] {
   nano-rpc {
      action: "telemetry"
   }
}

export def version [] {
   nano-rpc {
      action: "version"
   }
}

export def unchecked [] {
   nano-rpc {
      action: "unchecked"
      json_block: "true"
   }
}

export def work-peers [] {
   nano-rpc {
      action: "work_peers"
   }
}

export def work-peer-add [address: string, port: int] {
   nano-rpc {
      action: "work_peer_add"
      address: $address
      port: $port
   }
}

export def work-peer-clear [] {
   nano-rpc {
      action: "work_peer_clear"
   }
}

export def work-generate [hash: string] {
   nano-rpc {
      action: "work_generate"
      hash: $hash
   }
}

export def work-cancel [hash: string] {
   nano-rpc {
      action: "work_cancel"
      hash: $hash
   }
}

export def nano-to-raw [amount: string] {
   nano-rpc {
      action: "nano_to_raw"
      amount: $amount
   }
}

export def raw-to-nano [amount: string] {
   nano-rpc {
      action: "raw_to_nano"
      amount: $amount
   }
}

export def raw_to_nano [amount: string] {
   calc $"round\(\(($amount) / 10^30), 10)" | str trim
}

export def nano_to_raw [amount: string] {
   calc $"($amount) * 10^30" | str trim
}

export def raw_add [...rest: string] {
   calc ([$in ...$rest] | str join " + ") | str trim
}

export def raw_sub [...rest: string] {
   calc ([$in ...$rest] | str join " - ") | str trim
}

export def work-benchmark [count: int] {
   http post -u $env.NANO_USER -p $env.NANO_PASS -t "application/json" $env.NANO_WORK {
      action: "benchmark"
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

export def account_info [account: string] {
   try {
      account-info $account
   } catch {
      {
         "frontier": "0"
         "balance": "0"
         "representative": $env.NANO_REPRESENTATIVE
      }
   }
}

export def receive [--private(-p): string] {
   let private = ($private | default $env.NANO_PRIVATE)
   let receivables = (receivable $env.NANO_ACCOUNT)
   mut account = account_info $env.NANO_ACCOUNT
   mut balance = $account.balance

   for $receivable in $receivables {
      $balance = ($balance | raw_add $receivable.amount)
      let block = block-create $account.frontier $env.NANO_ACCOUNT $account.representative $balance $receivable.block $private
      let subtype = (if $account.frontier == "0" { "open" } else { "receive" })
      let process = process $subtype $block.block
      $account.frontier = $process.hash
      print $receivable
   }
}

export def send [to_address: string, amount: float = 0.000001, --private(-p): string, --all(-a)] {
   let private = ($private | default $env.NANO_PRIVATE)
   let address = key-expand $private | get account
   let account = account-info $address
   let balance = raw_to_nano $account.balance | into float
   let amount = if $all { balance $address | into float } else { $amount }
   if $amount == 0 {
      return {error: "Amount is zero", balance: $"($balance) NANO"}
   }
   if $balance < $amount {
      return {error: "Insufficient balance", balance: $"($balance) NANO", amount: $"($amount) NANO"}
   }
   let balance_raw = nano_to_raw ($balance - $amount | to text)
   let block = block-create $account.frontier $address $account.representative $balance_raw $to_address $private
   process send $block.block
}

export def seed-create [] {
   open /dev/urandom | tr -dc '0-9A-F' | head -c 64
}

export def seed-derived [from_seed: string, --max-index(-m): int = 100, --full(-f)] {
   seq 0 $max_index | each {|index|
      let key = deterministic-key $from_seed $index
      let balance = (balance $key.account)
      if $full {
         {private: $key.private, address: $key.account, balance: $balance}
      } else {
         {address: $key.account, balance: $balance}
      }
   }
}

export def seed-send [from_seed: string, to_address: string, --max-index(-m): int = 100] {
   for $account in (seed-derived $from_seed --max-index $max_index --full) {
      if $account.balance == "0" {
         continue
      }
      print (send $to_address ($account.balance | into float) --private $account.private)
   }
}
