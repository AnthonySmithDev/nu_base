
dir="tmp"
file="nu"
path="./$dir/$file"

download() {
  if [ ! -d $tmp ]; then
    mkdir -p $dir
  fi

  # Nushell
  version="0.88.1"
  wget --quiet --show-progress "https://github.com/nushell/nushell/releases/download/$version/nu-$version-x86_64-unknown-linux-gnu.tar.gz"
  tar -xf "nu-$version-x86_64-unknown-linux-gnu.tar.gz"
  rm "nu-$version-x86_64-unknown-linux-gnu.tar.gz"
  mv "nu-$version-x86_64-unknown-linux-gnu/nu" $path
  rm -rf "nu-$version-x86_64-unknown-linux-gnu"
}

if [ ! -f $path ]; then
  download
fi

script="$PWD/$(dirname "$0")/script.nu"

if [ "$1" == "--remote" ]; then
  $path $script --download --config
else
  $path $script --download --config --link
fi
