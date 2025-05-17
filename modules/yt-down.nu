
def move [] {
  for $dir in (ls | where type == dir | get name) {
    for $file in (ls $dir | get name) {
      let new = $"($file | path dirname) ($file | path basename)"
      mv $file $new
    }
    rm $dir
  }
}

export def main [batch_file: string] {
  let args = [
    # --quiet
    # --progress
    --max-filesize 1G
    --match-filter "duration < 1800"
    --write-thumbnail
    --restrict-filenames
    --write-all-thumbnails
    --concurrent-fragments 50
    --batch-file $batch_file
    --download-archive archive.txt
    --output "%(uploader)s %(title)s [%(id)s].%(ext)s"
    # --output "%(uploader)s/%(upload_date>%Y)s/%(title)s [%(id)s].%(ext)s"
  ]
  yt-dlp ...$args
}
