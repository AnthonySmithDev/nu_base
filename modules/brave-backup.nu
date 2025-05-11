
export def main [
    url: string = "",
    --name-dir(-n): string = "Brave-Browser-X",
    --rm(-d),
    --snapshot(-s): string,
    --rollback(-r): int,
    --rls,
] {

  let config_dir = ($env.HOME | path join .config/BraveSoftware)
  let data_dir = ($config_dir | path join $name_dir)

  let backup_dir = ($config_dir | path join backup)
  mkdir $backup_dir

  if $rm {
      return (rm -rf $data_dir)
  }

  if $snapshot != null {
      let timestamp = (date now | format date "%Y%m%d_%H%M%S")
      let backup_file = ($backup_dir | path join $"($name_dir)_($timestamp)_($snapshot).tar")
      tar -cf $backup_file -C $config_dir $name_dir
      return $"Snapshot creado en: ($backup_file)"
  }

  if $rls {
      let pattern = ($backup_dir | path join $"($name_dir)_*.tar")
      let backups = (glob $pattern | sort -r | each { |f| $f | path basename })
      if ($backups | is-empty) {
          return "No hay snapshots disponibles"
      }
      return $backups
  }

  if $rollback != null {
      let pattern = ($backup_dir | path join $"($name_dir)_*.tar")
      let backups = (glob $pattern | sort -r)

      if ($backups | is-empty) {
          return "No hay snapshots para restaurar"
      }

      let backup_count = ($backups | length)
      if $rollback >= $backup_count {
          return $"Índice inválido. Solo hay ($backup_count) backups disponibles (0..($backup_count - 1))"
      }

      rm -rf $data_dir
      mkdir $data_dir
      tar -xf ($backups | get $rollback) -C $config_dir
      return $"Perfil restaurado desde: ($backups | get $rollback)"
  }

  job spawn { brave-browser --user-data-dir=($data_dir) $url }
}
