source env.nu
source def.nu

source init/source.nu
source extern/source.nu

source alias.nu

def load [] {
  let path = ($env.NU_BASE_PATH | path join module source.nu)
  nu -e $"source ($path)"
}
