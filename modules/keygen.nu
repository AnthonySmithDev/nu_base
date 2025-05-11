
export-env {
  $env.SSH_KEY_ID = ($env.HOME | path join .ssh/id_ed25519)
}

export def seed [] {
  "inquiry unveil motor lock exchange heart occur enhance below tenant front regular only suspect either ranch chat fish syrup cruise bronze ozone later filter"
}

export def phrase [] {
  if ($env.SSH_KEY_ID | path exists) {
    melt ~/.ssh/id_ed25519
  } else {
    print "ssh file does not exists"
  }
}

export def restore [] {
  mkdir ~/.ssh
  if not ($env.SSH_KEY_ID | path exists) {
    seed | melt restore ~/.ssh/id_ed25519
  } else {
    print "ssh file already exists"
  }
}

export def gen [] {
  if not ($env.SSH_KEY_ID | path exists) {
    ssh-keygen -t ed25519 -C 'anthonyasdeveloper@gmail.com' -f $env.SSH_KEY_ID -N ""
  } else {
    print "ssh file already exists"
  }
}
