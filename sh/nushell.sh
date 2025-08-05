#!/bin/bash

# Function to check internet connection
check_internet_connection() {
    echo "Checking internet connection..."

    local ping_cmd="ping -c 1 -W 3 google.com"
    if [[ "$(uname -s)" =~ ^(CYGWIN|MINGW|MSYS).* ]]; then
        ping_cmd="ping -n 1 -w 3000 google.com"
    fi

    if $ping_cmd &> /dev/null; then
        echo "Internet connection detected."
        return 0
    else
        echo "Could not establish internet connection."
        return 1
    fi
}

# Nushell version to download
VERSION="0.106.0"
BASE_URL="https://github.com/nushell/nushell/releases/download/$VERSION"

# Determine architecture and operating system
ARCH=$(uname -m)
OS=$(uname -s)

# Map architecture and OS to filename
case "$OS" in
    Darwin)
        case "$ARCH" in
            arm64) FILE="nu-$VERSION-aarch64-apple-darwin.tar.gz" ;;
            x86_64) FILE="nu-$VERSION-x86_64-apple-darwin.tar.gz" ;;
            *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
        esac
        ;;
    Linux)
        case "$ARCH" in
            aarch64) FILE="nu-$VERSION-aarch64-unknown-linux-gnu.tar.gz" ;;
            armv7l) FILE="nu-$VERSION-armv7-unknown-linux-gnueabihf.tar.gz" ;;
            x86_64) FILE="nu-$VERSION-x86_64-unknown-linux-gnu.tar.gz" ;;
            *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
        esac
        ;;
    MINGW*|MSYS*)
        case "$ARCH" in
            x86_64) FILE="nu-$VERSION-x86_64-pc-windows-msvc.zip" ;;
            *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
        esac
        ;;
    *)
        echo "Unsupported operating system: $OS"
        exit 1
        ;;
esac

# Complete download URL
DOWNLOAD_URL="$BASE_URL/$FILE"

# Temporary download directory
HOME_TMP_FILE="$HOME/tmp/file"
mkdir -p "$HOME_TMP_FILE"

# Check if file already exists
if [ -f "$HOME_TMP_FILE/$FILE" ]; then
    echo "File $FILE already exists in $HOME_TMP_FILE. Will not download again."
else
    # Check internet connection before downloading
    if ! check_internet_connection; then
        echo "Cannot proceed with download without internet connection."
        exit 1
    fi

    # Download the file
    if command -v wget &> /dev/null; then
        wget --quiet --show-progress -O "$HOME_TMP_FILE/$FILE" "$DOWNLOAD_URL"
    elif command -v curl &> /dev/null; then
        curl -L -o "$HOME_TMP_FILE/$FILE" "$DOWNLOAD_URL"
    else
        echo "Neither wget nor curl found. Please install one of them."
        exit 1
    fi
fi

# Temporary extraction directory
HOME_TMP_DIR="$HOME/tmp/dir"
mkdir -p "$HOME_TMP_DIR"

TEMP_DIR=$(mktemp -d "$HOME_TMP_DIR/nushell_XXXXXX")

# Extract the file
if [[ "$FILE" == *.tar.gz ]]; then
    tar -xzf "$HOME_TMP_FILE/$FILE" -C "$TEMP_DIR"
elif [[ "$FILE" == *.zip ]]; then
    unzip "$HOME_TMP_FILE/$FILE" -d "$TEMP_DIR"
else
    echo "Unsupported file format: $FILE"
    exit 1
fi

# Get the extracted folder name
EXTRACTED_FOLDER=$(ls -d "$TEMP_DIR"/* | head -n 1)
EXTRACTED_FOLDER=$(basename "$EXTRACTED_FOLDER")

# Move extracted folder to final directory
SHARED_DIR="$HOME/.usr/local/share/lib/nushell"
mkdir -p "$SHARED_DIR"

INSTALL_DIR="$SHARED_DIR/nushell_$VERSION"
rm -rf "$INSTALL_DIR"

mv "$TEMP_DIR/$EXTRACTED_FOLDER" "$INSTALL_DIR"

# Clean up
rm -rf "$TEMP_DIR"

echo "Nushell $VERSION has been installed in $INSTALL_DIR"

# Create destination directory if it doesn't exist
mkdir -p ~/.usr/local/bin

# Create symbolic link
ln -sf "$INSTALL_DIR/nu" ~/.usr/local/bin/nu
sudo ln -sf "$INSTALL_DIR/nu" /usr/local/bin/nu

# Verify symbolic link was created successfully
if [ -L ~/.usr/local/bin/nu ]; then
    echo "Symbolic link successfully created at ~/.usr/local/bin/nu"
else
    echo "Error creating symbolic link."
    exit 1
fi
