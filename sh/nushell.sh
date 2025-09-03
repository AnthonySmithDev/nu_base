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

VERSION="0.107.0"
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
CACHE_DOWNLOAD_DIR_PATH="$HOME/.cache/nushell/download"
CACHE_DOWNLOAD_FILE_PATH="$CACHE_DOWNLOAD_DIR_PATH/$FILE_NAME"
mkdir -p "$CACHE_DOWNLOAD_DIR_PATH"

if [ -f "$CACHE_DOWNLOAD_FILE_PATH" ]; then
    echo "File $FILE_NAME already exists. Will not download again."
    echo "$CACHE_DOWNLOAD_FILE_PATH"
else
    if ! check_internet_connection; then
        echo "Cannot proceed with download without internet connection."
        exit 1
    fi

    if command -v wget &> /dev/null; then
        wget --quiet --show-progress -O "$CACHE_DOWNLOAD_DIR_PATH/$FILE_NAME" "$DOWNLOAD_URL"
    elif command -v curl &> /dev/null; then
        curl -L -o "$CACHE_DOWNLOAD_DIR_PATH/$FILE_NAME" "$DOWNLOAD_URL"
    else
        echo "Neither wget nor curl found. Please install one of them."
        exit 1
    fi
fi

CACHE_EXTRACT_PATH="$HOME/.cache/nushell/extract"
mkdir -p "$CACHE_EXTRACT_PATH"

if [[ "$FILE_NAME" == *.tar.gz ]]; then
    tar -xzf "$CACHE_DOWNLOAD_DIR_PATH/$FILE_NAME" -C "$CACHE_EXTRACT_PATH"
elif [[ "$FILE_NAME" == *.zip ]]; then
    unzip "$CACHE_DOWNLOAD_DIR_PATH/$FILE_NAME" -d "$CACHE_EXTRACT_PATH"
else
    echo "Unsupported file format: $FILE_NAME"
    exit 1
fi

EXTRACTED_DIR=$(ls -d "$CACHE_EXTRACT_PATH"/* | head -n 1)
LOCAL_SHARE_PATH="$HOME/.usr/local/share/lib/nushell"
SHARE_LIB_PATH="$LOCAL_SHARE_PATH/nushell_$VERSION"

mkdir -p "$LOCAL_SHARE_PATH"
rm -rf "$SHARE_LIB_PATH"
mv "$EXTRACTED_DIR" "$SHARE_LIB_PATH"

LOCAL_LIB_PATH="$HOME/.usr/local/lib"
mkdir -p "$LOCAL_LIB_PATH"
rm -rf "$LOCAL_LIB_PATH/nushell"
ln -sf "$SHARE_LIB_PATH" "$LOCAL_LIB_PATH/nushell"

GLOBAL_BIN_PATH="/usr/local/bin"
sudo ln -sf "$LOCAL_LIB_PATH/nushell/nu" "$GLOBAL_BIN_PATH/nu"

if [ -L "$GLOBAL_BIN_PATH/nu" ]; then
    echo ""
    echo "Nushell $VERSION has been installed successfully"
    echo "Symbolic link successfully created"
    echo "SHARE_LIB_PATH: $SHARE_LIB_PATH"
    echo "LOCAL_LIB_PATH: $LOCAL_LIB_PATH/nushell"
    echo "GLOBAL_BIN_PATH: $GLOBAL_BIN_PATH/nu"
    echo ""
else
    echo "Error creating symbolic link."
    exit 1
fi
