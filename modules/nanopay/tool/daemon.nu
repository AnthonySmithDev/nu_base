
def 'asset_type' [] {
   ['nano' 'bitcoin' 'lightning']
}

def 'account_type' [] {
   ['main' 'payment' 'funding']
}

def websocket [url: string] {
   wscat -c $url
}

export def pay [type: string@asset_type, address: string] {
   websocket $'ws://($env.HOST):3004/ws/v1/($type)/($address)'
}

export def nano [type: string@account_type] {
   websocket $'ws://($env.HOST):3007/ws/v1/($type)'
}

export def bitcoin [type: string@account_type] {
   websocket $'ws://($env.HOST):3008/ws/v1/($type)'
}

export def lightning [type: string@account_type] {
   websocket $'ws://($env.HOST):3009/ws/v1/($type)'
}
