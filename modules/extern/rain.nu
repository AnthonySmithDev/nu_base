
# Completions for rain CLI
export extern "rain" [
    --debug(-d) # enable debug log
    --cpuprofile # write cpu profile to FILE (hidden)
    --memprofile # write memory profile to FILE (hidden)
    --blockprofile # enable blocking profiler (hidden)
    --pprof # run pprof server on ADDR (hidden)
    --help(-h) # show help
    --version(-v) # show version
    command?: string@rain_commands
]

def rain_commands [] {
    [
        "download",
        "magnet-to-torrent",
        "server",
        "client",
        "boltbrowser",
        "compact-database",
        "torrent",
        "bash-autocomplete"
    ]
}

# Completions for download command
export extern "rain download" [
    --config(-c): path # read config from FILE
    --torrent(-t): string # torrent file or URI (required)
    --seed(-s) # continue seeding after download is finished
    --resume(-r): path # path to .resume file
    --help(-h) # show help
]

# Completions for magnet-to-torrent command
export extern "rain magnet-to-torrent" [
    --config(-c): path # read config from FILE
    --magnet(-m): string # magnet link (required)
    --output(-o): path # output file
    --timeout(-t): duration # command fails if torrent cannot be downloaded after duration
    --help(-h) # show help
]

# Completions for server command
export extern "rain server" [
    --config(-c): path # read config from FILE
    --help(-h) # show help
]

# Completions for client command
export extern "rain client" [
    --url: string # URL of RPC server
    --timeout: duration # request timeout
    --help(-h) # show help
    command?: string@client_commands
]

def client_commands [] {
    [
        "version",
        "list",
        "add",
        "remove",
        "clean-database",
        "stats",
        "session-stats",
        "trackers",
        "webseeds",
        "files",
        "file-stats",
        "peers",
        "add-peer",
        "add-tracker",
        "announce",
        "verify",
        "start",
        "stop",
        "start-all",
        "stop-all",
        "move",
        "torrent",
        "magnet",
        "console"
    ]
}

# Completions for client subcommands
export extern "rain client version" [
    --help(-h) # show help
]

export extern "rain client list" [
    --help(-h) # show help
]

export extern "rain client add" [
    --torrent(-t): string # file or URI (required)
    --stopped # do not start torrent automatically
    --stop-after-download # stop the torrent after download is finished
    --stop-after-metadata # stop the torrent after metadata download is finished
    --id: string@get_torrent_ids # if id is not given, a unique id is automatically generated
    --help(-h) # show help
]

export extern "rain client remove" [
    --id: string@get_torrent_ids # torrent id (required)
    --keep-data # keep downloaded files
    --help(-h) # show help
]

export extern "rain client clean-database" [
    --help(-h) # show help
]

export extern "rain client stats" [
    --id: string@get_torrent_ids # torrent id (required)
    --json # print raw stats as JSON
    --help(-h) # show help
]

export extern "rain client session-stats" [
    --json # print raw stats as JSON
    --help(-h) # show help
]

export extern "rain client trackers" [
    --id: string@get_torrent_ids # torrent id (required)
    --help(-h) # show help
]

export extern "rain client webseeds" [
    --id: string@get_torrent_ids # torrent id (required)
    --help(-h) # show help
]

export extern "rain client files" [
    --id: string@get_torrent_ids # torrent id (required)
    --help(-h) # show help
]

export extern "rain client file-stats" [
    --id: string@get_torrent_ids # torrent id (required)
    --help(-h) # show help
]

export extern "rain client peers" [
    --id: string@get_torrent_ids # torrent id (required)
    --help(-h) # show help
]

export extern "rain client add-peer" [
    --id: string@get_torrent_ids # torrent id (required)
    --addr: string # peer address in host:port format (required)
    --help(-h) # show help
]

export extern "rain client add-tracker" [
    --id: string@get_torrent_ids # torrent id (required)
    --tracker(-t): string # tracker URL (required)
    --help(-h) # show help
]

export extern "rain client announce" [
    --id: string@get_torrent_ids # torrent id (required)
    --help(-h) # show help
]

export extern "rain client verify" [
    --id: string@get_torrent_ids # torrent id (required)
    --help(-h) # show help
]

export extern "rain client start" [
    --id: string@get_torrent_ids # torrent id (required)
    --help(-h) # show help
]

export extern "rain client stop" [
    --id: string@get_torrent_ids # torrent id (required)
    --help(-h) # show help
]

export extern "rain client start-all" [
    --help(-h) # show help
]

export extern "rain client stop-all" [
    --help(-h) # show help
]

export extern "rain client move" [
    --id: string@get_torrent_ids # torrent id (required)
    --target: string # target server in host:port format (required)
    --help(-h) # show help
]

export extern "rain client torrent" [
    --id: string@get_torrent_ids # torrent id (required)
    --out(-o): path # output file (required)
    --help(-h) # show help
]

export extern "rain client magnet" [
    --id: string@get_torrent_ids # torrent id (required)
    --help(-h) # show help
]

export extern "rain client console" [
    --columns: string # columns to display
    --help(-h) # show help
]

# Completions for boltbrowser command
export extern "rain boltbrowser" [
    --file(-f): path # database file (required)
    --help(-h) # show help
]

# Completions for compact-database command
export extern "rain compact-database" [
    --config(-c): path # read config from FILE
    --help(-h) # show help
]

# Completions for torrent command
export extern "rain torrent" [
    --help(-h) # show help
    command?: string@torrent_commands
]

def torrent_commands [] {
    [
        "show",
        "infohash",
        "create"
    ]
}

# Completions for torrent subcommands
export extern "rain torrent show" [
    --file(-f): path # torrent file (required)
    --help(-h) # show help
]

export extern "rain torrent infohash" [
    --file(-f): path # torrent file (required)
    --help(-h) # show help
]

export extern "rain torrent create" [
    --file(-f): path # include this file or directory in torrent (required, multiple allowed)
    --out(-o): path # save generated torrent to this FILE (required)
    --root(-r): path # file paths given become relative to the root
    --name(-n): string # set name of torrent
    --private(-p) # create torrent for private trackers
    --piece-length(-l): int # override default piece length (in KB)
    --comment(-c): string # add COMMENT to torrent
    --tracker(-t): string # add tracker URL (multiple allowed)
    --webseed(-w): string # add webseed URL (multiple allowed)
    --help(-h) # show help
]

def get_torrent_ids [] {
    try { rain client list | from json | select ID Name | rename value description }
}

