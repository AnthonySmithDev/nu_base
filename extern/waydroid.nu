
def subaction [] {
  [status,log,init,upgrade,session,container,app,prop,show-full-ui,first-launch,shell,logcat]
}

export extern main [
  --help(-h)            # show this help message and exit
  --version(-V)         # show program's version number and exit
  --log(-l): string     # path to log file
  --details-to-stdout   # print details (e.g. build output) to stdout, instead
                        # of writing to the log
  --verbose(-v)         # write even more to the logfiles (this may reduce
                        # performance)
  --quiet(-q)           # do not output any log messages
  --wait(-w)            # wait for init before running
]

# quick check for the waydroid
export extern status [
  --help(-h) # show this help message and exit
]

# follow the waydroid logfile
export extern log [
  --help(-h)  # show this help message and exit
  --lines(-n) # count of initial output lines
  --clear(-c) # clear the log
]

def rom_type [] {
  [lineage bliss OTA]
}

def system_type [] {
  [VANILLA FOSS GAPPS]
}

# set up waydroid specific configs and install images
export extern init [
  --help(-h)                            # show this help message and exit
  --images_path(-i): string             # custom path to waydroid images (default in
                                        # /var/lib/waydroid/images)
  --force(-f)                           # re-initialize configs and images
  --system_channel(-c): string          # custom system channel (options: OTA channel URL;
                                        # default is Official OTA server)
  --vendor_channel(-v): string          # custom vendor channel (options: OTA channel URL;
                                        # default is Official OTA server)
  --rom_type(-r): string@rom_type       # rom type (options: "lineage", "bliss" or OTA channel
                                        # URL; default is LineageOS)
  --system_type(-s): string@system_type # system type (options: VANILLA, FOSS or GAPPS; default
                                        # is VANILLA)
]

# upgrade images
export extern upgrade [
  --help(-h)     # show this help message and exit
  --offline(-o)  # just for updating configs
]

def session_subaction [] {
  [
    {value: "start", description: "start session"}
    {value: "stop", description: "stop session"}
  ]
}

# session controller
export extern session [
  subaction: string@session_subaction
  --help(-h) # show this help message and exit
]

def container_subaction [] {
  [
    {value: "start", description: "start container"}
    {value: "stop", description: "stop container"}
    {value: "restart", description: "restart container"}
    {value: "freeze", description: "freeze container"}
    {value: "unfreeze", description: "unfreeze container"}
  ]
}

# container controller
export extern container [
  subaction: string@container_subaction
  --help(-h) # show this help message and exit
]

def app_subaction [] {
  [
    {value: "install", description: "push a single package to the container and install it"}
    {value: "remove", description: "remove single app package from the container"}
    {value: "launch", description: "start single application"}
    {value: "intent", description: "start single application"}
    {value: "list", description: "list installed applications"}
  ]
}

# applications controller
export extern app [
  subaction: string@app_subaction
  --help(-h) # show this help message and exit
]

def prop_subaction [] {
  [
    {value: "get", description: "get value of property from container"}
    {value: "set", description: "set value to property on container"}
  ]
}

# android properties controller
export extern prop [
  subaction: string@prop_subaction
  key: string # key of the property to get or set
  --help(-h)  # show this help message and exit
]

# show android full screen in window
export extern show-full-ui [
  --help(-h) # show this help message and exit
]

# initialize waydroid and start it
export extern first-launch [
  --help(-h) # show this help message and exit
]

# run remote shell command
export extern shell [
  ...COMMAND: string    # command to run
  --help(-h)            # show this help message and exit
  --uid(-u): int        # the UID to run as (also sets GID to the same value if
                        # -g is not set)
  --gid(-g): int        # the GID to run as
  --context(-s): string # CONTEXT
                        # transition to the specified SELinux or AppArmor
                        # security context. No-op if -L is supplied.
  --nolsm(-L)           # tell LXC not to perform security domain transition
                        # related to mandatory access control (e.g. SELinux,
                        # AppArmor). If this option is supplied, LXC won't apply
                        # a container-wide seccomp filter to the executed
                        # program. This is a dangerous option that can result in
                        # leaking privileges to the container!!!
  --allcaps(-C)         # tell LXC not to drop capabilities. This is a dangerous
                        # option that can result in leaking privileges to the
                        # container!!!
  --nocgroup(-G)        # tell LXC not to switch to the container cgroup. This
                        # is a dangerous option that can result in leaking
                        # privileges to the container!!!
]

# show android logcat
export extern logcat [
  --help(-h) # show this help message and exit
]
