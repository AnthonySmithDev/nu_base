
def --env role_add [role: string] {
  if $env.GPT_ROLE? == null {
    $env.GPT_ROLE = $role
  } else {
    $env.GPT_ROLE = $env.GPT_ROLE + "\n" + $role
  }
}

def role_get [] {
  if $env.GPT_ROLE? == null {
    return ""
  } else {
    return $env.GPT_ROLE
  }
}

export def --env code [] {
  role_add "Por favor, proporciona el código necesario en markdown sin ninguna explicación adicional. Gracias."
}

export def --env main [ ...prompt: string ] {
  if $env.GPT_UUID? == null {
    $env.GPT_UUID = (random uuid)
    mods --quiet --title $env.GPT_UUID (role_get) ...$prompt
  } else {
    mods --quiet --continue $env.GPT_UUID (role_get) ...$prompt
  }
}
