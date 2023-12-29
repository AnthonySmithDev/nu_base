
export def riv [] {
  cargo install --git https://github.com/Davejkane/riv
}

export def libc [] {
  # sudo apt install gawk bison gcc make wget tar -y
  cd $env.HOME
  wget "http://ftp.gnu.org/gnu/libc/glibc-2.34.tar.gz"
  tar zxvf glibc-2.34.tar.gz
  mkdir glibc-2.34-build
  cd glibc-2.34-build
  ../glibc-2.34/configure --prefix=/usr
  make
  sudo make install
}

export def vimiv [] {
  let dir = (mktemp -d)
  git clone https://github.com/karlch/vimiv-qt $dir
  mv ($dir | path join misc Makefile) $dir
  PWD=$dir sudo make install
}

export def helix [] {
  let path = (mktemp -d)
  git clone https://github.com/helix-editor/helix $path
  cargo install --path ($path | path join helix-term) --locked
  mv ($path | path join runtime) $env.HELIX_RUNTIME
}

export def hargo [] {
  let dir = (mktemp -d)
  git clone https://github.com/mrichman/hargo.git $dir
  PWD=$dir make install
}
