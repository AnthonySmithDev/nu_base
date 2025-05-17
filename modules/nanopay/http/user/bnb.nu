
def host [...path: string] {
  '/wallet/bnb' | append $path | path join
}

# Get BNB wallet address
export def 'address' [] {
  https get (host address) | get data
}

# Get BNB balance
export def 'balance' [] {
  https get (host balance) | get data
}

# Get token balance
export def 'token balance' [token: string] {
  https get (host $"balance/($token)") | get data
}

# Create token wallet
export def 'token create' [token: string] {
  let body = {
    tokenSymbol: $token
  }
  https post (host token/wallet) $body | get data
}

# Send BNB
export def 'send' [address: string, amount: string] {
  let body = {
    amount: $amount
    address: $address
  }
  https post (host send) $body | get data
}

# Batch send BNB (requires CSV file)
export def 'send batch' [file: string] {
  let file_content = (open $file)
  let form = {
    document: $file_content
  }
  https post (host send/batch) $form | get data
}

# Get transactions
export def 'tx' [page: int = 1, size: int = 10] {
  let query = {
    page: $page
    size: $size
  }
  https get (host tx) $query | get data
}

# Get transaction graph by type
export def 'graph type' [] {
  https get (host graph/type) | get data
}

# Get transaction graph by month
export def 'graph month' [type: int, year: int] {
  let year = ($year | default (date now | date format '%Y' | into int))
  let query = {
    txType: $type
    year: $year
  }
  https get (host graph/month) $query | get data
}

# Get multi-send jobs
export def 'multisend jobs' [] {
  https get (host multisend/jobs) | get data
}

# Get multi-send job status
export def 'multisend job status' [job_id: string] {
  https get (host $"multisend/jobs/($job_id)") | get data
}

# Get multi-send job logs
export def 'multisend job logs' [job_id: string] {
  https get (host $"multisend/jobs/($job_id)/logs") | get data
}

# Get user config
export def 'config get' [] {
  https get (host config) | get data
}

# Save user config
export def 'config save' [redirect: bool, swap: bool, ipn_url: string, redirect_address: string, fiat_currency: string] {
  let body = {
    redirectEnabled: $redirect
    swapEnabled: $swap
    ipnUrl: $ipn_url
    redirectAddress: $redirect_address
    fiatCurrency: $fiat_currency
  }
  https post (host config) $body | get data
}

# Create payment
export def 'payment create' [currency: string, amount: float] {
  let body = {
    currency: $currency
    amount: $amount
  }
  https post (host payment) $body | get data
}

# Get payment account
export def 'payment account' [wallet_id: string] {
  https get (host $"payment/($wallet_id)") | get data
}

# Consolidate funds
export def 'consolidate' [hot_percentage: float, cold_percentage: float] {
  let body = {
    hotPercentage: $hot_percentage
    coldPercentage: $cold_percentage
  }
  https post (host consolidate) $body | get data
}

# Get consolidation job info
export def 'consolidate job' [job_id: string] {
  https get (host $"consolidate/($job_id)") | get data
}

# Get consolidation job logs
export def 'consolidate logs' [job_id: string] {
  https get (host $"consolidate/($job_id)/logs") | get data
}

# Check internal transactions
export def 'internal txs' [address: string] {
  https get (host $"internal/($address)") | get data
}

# Create token multi-send
export def 'token multisend create' [token: string, ...recipients: any] {
  let body = {
    token: $token
    recipients: $recipients
  }
  https post (host token/multisend) $body | get data
}

# Process token multi-send
export def 'token multisend process' [job_id: string] {
  https post (host $"token/multisend/($job_id)") | get data
}

# Get token multi-send job status
export def 'token multisend status' [job_id: string] {
  https get (host $"token/multisend/($job_id)") | get data
}

# Get token multi-send job logs
export def 'token multisend logs' [job_id: string] {
  https get (host $"token/multisend/($job_id)/logs") | get data
}
