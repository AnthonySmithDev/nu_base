
def prefixes [] {
  [ Crypto Bit Trade Coin Crypt Money Binance P2P Buy Sell Invest Trade Earn Pro X Digital Trust Ex Power Quick ]
}

def suffixes [] {
  [ FX Trader Pro Expert Coin Investor Crypto Market P2P Money Trade Binance Buy Sell Profit Master Guru Whale Enthusiast Speculator ]
}

export def prefix [] {
  let list = prefixes
  let max = ($list | length) - 1
  let index = random int 0..$max
  return ($list | get $index)
}

export def suffix [] {
  let list = suffixes
  let max = ($list | length) - 1
  let index = random int 0..$max
  return ($list | get $index)
}

export def nickname [] {
  return ((prefix) + (suffix))
}
