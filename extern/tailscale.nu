
export extern main [
  --socket: string
  # path to tailscaled socket (default /var/run/tailscale/tailscaled.sock)
]

# Connect to Tailscale, logging in if needed
export extern up []

# Disconnect from Tailscale
export extern down []

# Change specified preferences
export extern set []

# Log in to a Tailscale account
export extern login []

# Disconnect from Tailscale and expire current node key
export extern logout []

# Switches to a different Tailscale account
export extern switch []

# [ALPHA] Configure the host to enable more Tailscale features
export extern configure []

# Print an analysis of local network conditions
export extern netcheck []

# Show Tailscale IP addresses
export extern ip []

# Show state of tailscaled and its connections
export extern status []

# Ping a host at the Tailscale layer, see how it routed
export extern ping []

# Connect to a port on a host, connected to stdin/stdout
export extern nc []

# SSH to a Tailscale machine
export extern ssh []

# Serve content and local servers on the internet
export extern funnel []

# Serve content and local servers on your tailnet
export extern serve []

# Print Tailscale version
export extern version []

# Run a web server for controlling Tailscale
export extern web []

# Send or receive files
export extern file []

# Print a shareable identifier to help diagnose issues
export extern bugreport []

# Get TLS certs
export extern cert []

# Manage tailnet lock
export extern lock []

# Get open source license information
export extern licenses []

# Show machines on your tailnet configured as exit nodes
export extern exit-node []

# [BETA] Update Tailscale to the latest/different version
export extern update []

# Show the machine and user associated with a Tailscale IP (v4 or v6)
export extern whois []
