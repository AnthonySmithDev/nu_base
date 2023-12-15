mkdir -p ~/.local/bin

# Nushell
version="0.88.1"
wget --quiet --show-progress "https://github.com/nushell/nushell/releases/download/$version/nu-$version-x86_64-unknown-linux-gnu.tar.gz"
tar -xf "nu-$version-x86_64-unknown-linux-gnu.tar.gz"
rm "nu-$version-x86_64-unknown-linux-gnu.tar.gz"
mv "nu-$version-x86_64-unknown-linux-gnu/nu" ~/.local/bin/nu
rm -rf "nu-$version-x86_64-unknown-linux-gnu"

if [ "$1" == "--remote" ]; then
  ~/.local/bin/nu ~/.local/nu_base/bash/script.nu --download --config
else
  ~/.local/bin/nu ~/nushell/nu_base/bash/script.nu --download --config --link
fi
