
def request [body: record] {
  http post --content-type application/json http://localhost:3011/api/v1/user $body
}

export def order_create [id: string, orderId: string] {
  request {
    "for_id": [$id],
    "method": "/order/create"
    "params": {
      order_id: $orderId
    }
  }
}

export def order_cancel [id: string, orderId: string] {
  request {
    "for_id": [$id],
    "method": "/order/cancel"
    "params": {
      order_id: $orderId
    }
  }
}

export def order_notify [id: string, orderId: string] {
  request {
    "for_id": [$id],
    "method": "/order/notify"
    "params": {
      order_id: $orderId
    }
  }
}

export def order_release [id: string, orderId: string] {
  request {
    "for_id": [$id],
    "method": "/order/release"
    "params": {
      order_id: $orderId
    }
  }
}

export def order_report [id: string, orderId: string] {
  request {
    "for_id": [$id],
    "method": "/order/report"
    "params": {
      order_id: $orderId
    }
  }
}

export def order_cancel_time [id: string, orderId: string] {
  request {
    "for_id": [$id],
    "method": "/order/cancel/time"
    "params": {
      order_id: $orderId
    }
  }
}
