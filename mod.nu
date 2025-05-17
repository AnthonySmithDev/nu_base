
# const NU_LIB_DIRS = [
#   '~/nu/nu_base/modules'
# ]

source autoload/mod.nu

source env.nu
source def.nu

source wrapped.nu
source builtin.nu

source alias.nu

source alias/git.nu
source alias/zellij.nu

use ctx.nu
use file-manager.nu
source alias/file-manager.nu

use modules/nanopay/mode.nu
mode load
use modules/faker
use modules/nanopay/http/user
use modules/nanopay
