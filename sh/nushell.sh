#!/bin/bash

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

VERSION="0.106.1"
BASE_URL="https://github.com/nushell/nushell/releases/download/$VERSION"

ARCH=$(uname -m)
OS=$(uname -s)

case "$OS" in
    Darwin)
        case "$ARCH" in
            arm64) FILE_NAME="nu-$VERSION-aarch64-apple-darwin.tar.gz" ;;
            x86_64) FILE_NAME="nu-$VERSION-x86_64-apple-darwin.tar.gz" ;;
            *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
        esac
        ;;
    Linux)
        case "$ARCH" in
            aarch64) FILE_NAME="nu-$VERSION-aarch64-unknown-linux-gnu.tar.gz" ;;
            armv7l) FILE_NAME="nu-$VERSION-armv7-unknown-linux-gnueabihf.tar.gz" ;;
            x86_64) FILE_NAME="nu-$VERSION-x86_64-unknown-linux-gnu.tar.gz" ;;
            *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
        esac
        ;;
    MINGW*|MSYS*)
        case "$ARCH" in
            x86_64) FILE_NAME="nu-$VERSION-x86_64-pc-windows-msvc.zip" ;;
            *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
        esac
        ;;
    *)
        echo "Unsupported operating system: $OS"
        exit 1
        ;;
esac

DOWNLOAD_URL="$BASE_URL/$FILE_NAME"
CACHE_DOWNLOAD_DIR="$HOME/.cache/nushell/download"
CACHE_DOWNLOAD_FILE="$CACHE_DOWNLOAD_DIR/$FILE_NAME"
mkdir -p "$CACHE_DOWNLOAD_DIR"

if [ -f "$CACHE_DOWNLOAD_FILE" ]; then
    echo "File $FILE_NAME already exists. Will not download again."
    echo "$CACHE_DOWNLOAD_FILE"
else
    if ! check_internet_connection; then
        echo "Cannot proceed with download without internet connection."
        exit 1
    fi

    if command -v wget &> /dev/null; then
        wget --quiet --show-progress -O "$CACHE_DOWNLOAD_DIR/$FILE_NAME" "$DOWNLOAD_URL"
    elif command -v curl &> /dev/null; then
        curl -L -o "$CACHE_DOWNLOAD_DIR/$FILE_NAME" "$DOWNLOAD_URL"
    else
        echo "Neither wget nor curl found. Please install one of them."
        exit 1
    fi
fi

CACHE_EXTRACT_DIR="$HOME/.cache/nushell/extract"
mkdir -p "$CACHE_EXTRACT_DIR"

if [[ "$FILE_NAME" == *.tar.gz ]]; then
    tar -xzf "$CACHE_DOWNLOAD_DIR/$FILE_NAME" -C "$CACHE_EXTRACT_DIR"
elif [[ "$FILE_NAME" == *.zip ]]; then
    unzip "$CACHE_DOWNLOAD_DIR/$FILE_NAME" -d "$CACHE_EXTRACT_DIR"
else
    echo "Unsupported file format: $FILE_NAME"
    exit 1
fi

EXTRACTED_DIR=$(ls -d "$CACHE_EXTRACT_DIR"/* | head -n 1)
LOCAL_SHARED_DIR="$HOME/.usr/local/share/lib/nushell"
INSTALL_DIR="$LOCAL_SHARED_DIR/nushell_$VERSION"

mkdir -p "$LOCAL_SHARED_DIR"
rm -rf "$INSTALL_DIR"
mv "$EXTRACTED_DIR" "$INSTALL_DIR"

GLOBAL_BIN="/usr/local/bin"
LOCAL_BIN="$HOME/.usr/local/bin"
LOCAL_LIB="$HOME/.usr/local/lib"

mkdir -p "$LOCAL_BIN"
mkdir -p "$LOCAL_LIB"

sudo ln -sf "$INSTALL_DIR/nu" "$GLOBAL_BIN/nu"
ln -sf "$INSTALL_DIR/nu" "$LOCAL_BIN/nu"
ln -sf "$INSTALL_DIR" "$LOCAL_LIB/nushell"

if [ -L "$LOCAL_BIN/nu" ]; then
    echo ""
    echo "Nushell $VERSION has been installed successfully"
    echo "Symbolic link successfully created"
    echo "GLOBAL_BIN: $GLOBAL_BIN/nu"
    echo "LOCAL_BIN: $LOCAL_BIN/nu"
    echo "LOCAL_LIB: $LOCAL_LIB/nushell"
    echo "SHARED_LIB: $INSTALL_DIR"
    echo ""
else
    echo "Error creating symbolic link."
    exit 1
fi
