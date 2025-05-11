use connect.nu

use faker/
use btc.nu

use nano.nu
nano set payzum

# use ws2http.nu
# use ws.nu
# use r2.nu

# use schema.nu
use config.nu

use mongo.nu
# use refactor.nu

use kube

# use payzum/docker/database.nu
# use payzum/docker/backend.nu
# use payzum/docker/frontend.nu

# use payzum/tool/okx.nu
# use payzum/tool/binance.nu

# use payzum/rest/p2p
# use payzum/rest/user
# use payzum/rest/admin
# use payzum/rest/upload

use project/nanopay
use project/nanopay/mode.nu
mode load

source project/nanopay/alias.nu
overlay use project/nanopay/http
