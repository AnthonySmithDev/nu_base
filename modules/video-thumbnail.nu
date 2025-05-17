
export def main [
    video_path: path,  # Ruta al archivo de video
    --output (-o): path = "thumbnail.jpg",  # Ruta de salida (por defecto: thumbnail.jpg)
    --time (-t): string = "00:00:05",  # Tiempo del video para capturar (por defecto: 5 segundos)
    --width (-w): int = 320,  # Ancho del thumbnail (por defecto: 320px)
    --quality (-q): int = 5  # Calidad (1-31, donde 1 es mejor, por defecto: 5)
] {
    # Verificar que ffmpeg esté instalado
    if not (which ffmpeg | is-empty) {
        error make {msg: "ffmpeg no está instalado o no está en el PATH"}
    }

    # Verificar que el archivo de video exista
    if not ($video_path | path exists) {
        error make {msg: $"El archivo ($video_path) no existe"}
    }

    # Ejecutar ffmpeg para generar el thumbnail
    let ffmpeg_args = [
        "-v", "quiet",
        "-ss", $time,
        "-i", $video_path,
        "-vframes", "1",
        "-q:v", $quality,
        "-vf", $"scale=($width):-2:flags=fast_bilinear",
        "-y", $output
    ]

    let result = (^ffmpeg ...$ffmpeg_args | complete)

    if $result.exit_code != 0 {
        error make {msg: $"Error al generar el thumbnail: ($result.stderr)"}
    } else {
        $"Thumbnail generado correctamente en ($output)"
    }
}
