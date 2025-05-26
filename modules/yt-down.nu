
def move [] {
  for $dir in (ls | where type == dir | get name) {
    for $file in (ls $dir | get name) {
      let new = $"($file | path dirname) ($file | path basename)"
      mv $file $new
    }
    rm $dir
  }
}

export def main [
  batch_file: string,
  --limit-rate: string = "1M",
  --max-filesize: string = "500M"
  --max-minute(-m): int = 18,
  --concurrent(-c): int = 10,
] {
  let args = [
    # --quiet
    # --progress
    --limit-rate $limit_rate
    --max-filesize $max_filesize
    --concurrent-fragments $concurrent
    --match-filter $"duration < ($max_minute * 60)"
    --write-thumbnail
    --restrict-filenames
    --paths "thumbnail:thumbnails"  
    # --write-all-thumbnails
    --download-sections "*10:"
    --batch-file $batch_file
    --download-archive ../archive.txt
    --output "%(uploader)s _ %(upload_date>%Y)s _ %(title)s [%(id)s].%(ext)s"
  ]
  yt-dlp ...$args
}
