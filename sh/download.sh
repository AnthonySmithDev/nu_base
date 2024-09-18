version="0.98.0"
bin="$HOME/.local/bin"
share="$bin/share"
path="$share/nu_$version"

mkdir -p "$share"

download() {
  if [ ! -e "$path" ]; then
    echo "Starting to download nushell nu_$version"

    wget --quiet --show-progress "https://github.com/nushell/nushell/releases/download/$version/nu-$version-x86_64-unknown-linux-gnu.tar.gz"
    tar -xf "nu-$version-x86_64-unknown-linux-gnu.tar.gz"
    rm "nu-$version-x86_64-unknown-linux-gnu.tar.gz"
    mv "nu-$version-x86_64-unknown-linux-gnu/nu" $path
    rm -rf "nu-$version-x86_64-unknown-linux-gnu"
  else
    echo "Nushell is now downloaded nu_$version"
  fi

  ln -sf "$path" "$bin/nu"
}

ping -c 1 google.com >/dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "You are connected to the internet."
  download
else
  echo "You are not connected to the internet."
fi
