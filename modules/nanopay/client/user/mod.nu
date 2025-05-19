
export use jwt.nu
export use https.nu
export use form.nu

export use auth.nu
export use account.nu
export use kyc.nu
export use api.nu
export use security.nu
export use device.nu
export use activity.nu
export use wallet.nu
export use bnb.nu

export use support
export use merchant

export def --env anthony [] {
  auth signin anthony
}

export def --env smith [] {
  auth signin smith
}

export def --env aguirre [] {
  auth signin aguirre
}

export def --env bejar [] {
  auth signin bejar
}

export def --env jean [] {
  $env.NANOPAY_USER_PASS = "A1111111"
  auth signin jeanmg25
}
