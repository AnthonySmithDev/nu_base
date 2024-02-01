
dir="$HOME/.local/bin"
file="nu"
path="$dir/$file"

mkdir -p $dir

download() {
  version="0.89.0"
  wget --quiet --show-progress "https://github.com/nushell/nushell/releases/download/$version/nu-$version-x86_64-unknown-linux-gnu.tar.gz"
  tar -xf "nu-$version-x86_64-unknown-linux-gnu.tar.gz"
  rm "nu-$version-x86_64-unknown-linux-gnu.tar.gz"
  mv "nu-$version-x86_64-unknown-linux-gnu/nu" $path
  rm -rf "nu-$version-x86_64-unknown-linux-gnu"
}

ping -c 1 google.com >/dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "You are connected to the internet."
  if [ ! -f $path ]; then
    echo "Starting to download nushell"
    download
  else
    echo "Nushell is now downloaded"
  fi
else
  echo "You are not connected to the internet."
fi
