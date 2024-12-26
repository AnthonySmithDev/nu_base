version="0.101.0"

src_dir="$HOME/.usr/local/share"
src_file="$src_dir/nu_$version"
mkdir -p $src_dir

dst_dir="$HOME/.usr/local/bin"
dst_file="$dst_dir/nu"
mkdir -p $dst_dir

download() {
  if [ ! -e "$src_file" ]; then
    echo "Starting to download nushell nu_$version"

    wget --quiet --show-progress "https://github.com/nushell/nushell/releases/download/$version/nu-$version-x86_64-unknown-linux-gnu.tar.gz"
    tar -xf "nu-$version-x86_64-unknown-linux-gnu.tar.gz"
    rm "nu-$version-x86_64-unknown-linux-gnu.tar.gz"
    mv "nu-$version-x86_64-unknown-linux-gnu/nu" $src_file
    rm -rf "nu-$version-x86_64-unknown-linux-gnu"
  else
    echo "Nushell is now downloaded nu_$version"
  fi

  ln -sf $src_file $dst_file
}

ping -c 1 google.com >/dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "You are connected to the internet."
  download
else
  echo "You are not connected to the internet."
fi
