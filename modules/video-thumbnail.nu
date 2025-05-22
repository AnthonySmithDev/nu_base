
export def main [
    video_path: path,
    --output (-o): path,
    --time (-t): string = "00:00:10",
    --width (-w): int = 320,
    --quality (-q): int = 5,
] {
    if (which ffmpeg | is-empty) {
        error make {msg: "ffmpeg no está instalado o no está en el PATH"}
    }

    if not ($video_path | path exists) {
        error make {msg: $"El archivo ($video_path) no existe"}
    }

    let thumbnail = ($output | default (mktemp -t --suffix .png))

    let ffmpeg_args = [
        "-v", "quiet",
        "-ss", $time,
        "-i", $video_path,
        "-vframes", "1",
        "-q:v", $quality,
        "-vf", $"scale=($width):-2:flags=fast_bilinear",
        "-y", $thumbnail
    ]
    try {
        ^ffmpeg ...$ffmpeg_args
    } catch {|err|
        error make -u { msg: $err.msg }
    }
    kitten icat $thumbnail
}
