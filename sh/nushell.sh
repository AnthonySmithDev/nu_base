#!/bin/bash

# Función para verificar la conexión a Internet
check_internet_connection() {
    echo "Verificando conexión a Internet..."
    if ping -n 1 -w 2000 google.com &> /dev/null; then
        echo "Conexión a Internet detectada."
        return 0
    else
        echo "No se pudo establecer conexión a Internet."
        return 1
    fi
}

# Versión de Nushell a descargar
VERSION="0.102.0"

# URL base para las descargas
BASE_URL="https://github.com/nushell/nushell/releases/download/$VERSION"

# Determinar la arquitectura y el sistema operativo
ARCH=$(uname -m)
OS=$(uname -s)

# Mapear la arquitectura y el sistema operativo al nombre del archivo
case "$OS" in
    Darwin)
        case "$ARCH" in
            arm64) FILE="nu-$VERSION-aarch64-apple-darwin.tar.gz" ;;
            x86_64) FILE="nu-$VERSION-x86_64-apple-darwin.tar.gz" ;;
            *) echo "Arquitectura no soportada: $ARCH"; exit 1 ;;
        esac
        ;;
    Linux)
        case "$ARCH" in
            aarch64) FILE="nu-$VERSION-aarch64-unknown-linux-gnu.tar.gz" ;;
            armv7l) FILE="nu-$VERSION-armv7-unknown-linux-gnueabihf.tar.gz" ;;
            x86_64) FILE="nu-$VERSION-x86_64-unknown-linux-gnu.tar.gz" ;;
            *) echo "Arquitectura no soportada: $ARCH"; exit 1 ;;
        esac
        ;;
    MINGW*|MSYS*)
        case "$ARCH" in
            x86_64) FILE="nu-$VERSION-x86_64-pc-windows-msvc.zip" ;;
            *) echo "Arquitectura no soportada: $ARCH"; exit 1 ;;
        esac
        ;;
    *)
        echo "Sistema operativo no soportado: $OS"
        exit 1
        ;;
esac

# URL completa del archivo a descargar
DOWNLOAD_URL="$BASE_URL/$FILE"

# Directorio temporal para la descarga
DOWNLOAD_DIR="$HOME/tmp/file"
mkdir -p "$DOWNLOAD_DIR"

# Verificar si el archivo ya existe
if [ -f "$DOWNLOAD_DIR/$FILE" ]; then
    echo "El archivo $FILE ya existe en $DOWNLOAD_DIR. No se descargará nuevamente."
else
    # Verificar conexión a Internet antes de descargar
    if ! check_internet_connection; then
        echo "No se puede proceder con la descarga sin conexión a Internet."
        exit 1
    fi

    # Descargar el archivo
    if command -v wget &> /dev/null; then
        wget --quiet --show-progress -O "$DOWNLOAD_DIR/$FILE" "$DOWNLOAD_URL"
    elif command -v curl &> /dev/null; then
        curl -L -o "$DOWNLOAD_DIR/$FILE" "$DOWNLOAD_URL"
    else
        echo "No se encontró ni wget ni curl. Por favor, instala uno de ellos."
        exit 1
    fi
fi

# Directorio temporal para la descompresión
TEMP_DIR=$(mktemp -d "$HOME/tmp/dir/nushell_XXXXXX")

# Descomprimir el archivo
if [[ "$FILE" == *.tar.gz ]]; then
    tar -xzf "$DOWNLOAD_DIR/$FILE" -C "$TEMP_DIR"
elif [[ "$FILE" == *.zip ]]; then
    unzip "$DOWNLOAD_DIR/$FILE" -d "$TEMP_DIR"
else
    echo "Formato de archivo no soportado: $FILE"
    exit 1
fi

# Obtener el nombre de la carpeta descomprimida
EXTRACTED_FOLDER=$(ls -d "$TEMP_DIR"/* | head -n 1)
EXTRACTED_FOLDER=$(basename "$EXTRACTED_FOLDER")

# Mover la carpeta descomprimida al directorio final
SHARED_DIR="$HOME/.usr/local/share"
mkdir -p "$SHARED_DIR"

INSTALL_DIR="$SHARED_DIR/nushell_$VERSION"
rm -rf "$INSTALL_DIR"

mv "$TEMP_DIR/$EXTRACTED_FOLDER" "$INSTALL_DIR"

# Limpiar
rm -rf "$TEMP_DIR"

echo "Nushell $VERSION ha sido instalado en $INSTALL_DIR"

# Crear el directorio de destino si no existe
mkdir -p ~/.usr/local/bin

# Crear el enlace simbólico
ln -sf "$INSTALL_DIR/nu" ~/.usr/local/bin/nu

# Verificar que el enlace simbólico se haya creado correctamente
if [ -L ~/.usr/local/bin/nu ]; then
    echo "Enlace simbólico creado correctamente en ~/.usr/local/bin/nu"
else
    echo "Error al crear el enlace simbólico."
    exit 1
fi
