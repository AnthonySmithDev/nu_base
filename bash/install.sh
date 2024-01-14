
dir="tmp"
file="nu"
path="./$dir/$file"

download() {
  mkdir -p $dir

  # Nushell
  version="0.89.0"
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
  $path $script --remote
else
  $path $script
fi
