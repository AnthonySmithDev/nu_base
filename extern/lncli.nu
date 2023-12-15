# NAME:
   # lncli - control plane for your Lightning Network Daemon (lnd)

# USAGE:
   # lncli [global options] command [command options] [arguments...]

# VERSION:
   # 0.16.4-beta commit=v0.16.4-beta

# COMMANDS:
 export extern "lncli getinfo" []          # Returns basic information related to the active daemon.
 export extern "lncli getrecoveryinfo" []  # Display information about an ongoing recovery attempt.
 export extern "lncli debuglevel" []       # Set the debug level.
 export extern "lncli stop" []             # Stop and shutdown the daemon.
 export extern "lncli version" []          # Display lncli and lnd version info.
 export extern "lncli sendcustom" []
 export extern "lncli subscribecustom" []
 export extern "lncli help" []             # Shows a list of commands or help for one command

# Autopilot:
export extern "lncli autopilot" [] # Interact with a running autopilot.

# Channels:
export extern "lncli openchannel" []       # Open a channel to a node or an existing peer.
export extern "lncli batchopenchannel" []  # Open multiple channels to existing peers in a single transaction.
export extern "lncli closechannel" []      # Close an existing channel.
export extern "lncli closeallchannels" []  # Close all existing channels.
export extern "lncli abandonchannel" []    # Abandons an existing channel.
export extern "lncli channelbalance" []    # Returns the sum of the total available channel balance across all open channels.
export extern "lncli pendingchannels" []   # Display information pertaining to pending channels.
export extern "lncli listchannels" []      # List all open channels.
export extern "lncli closedchannels" []    # List all closed channels.
export extern "lncli getnetworkinfo" []    # Get statistical information about the current state of the network.
export extern "lncli feereport" []         # Display the current fee policies of all active channels.
export extern "lncli updatechanpolicy" []  # Update the channel policy for all channels, or a single channel.
export extern "lncli exportchanbackup" []  # Obtain a static channel back up for a selected channels, or all known channels.
export extern "lncli verifychanbackup" []  # Verify an existing channel backup.
export extern "lncli restorechanbackup" [] # Restore an existing single or multi-channel static channel backup.
export extern "lncli listaliases" []       # List all aliases.
export extern "lncli updatechanstatus" []  # Set the status of an existing channel on the network.

# Graph:
export extern "lncli describegraph" []  # Describe the network graph.
export extern "lncli getnodemetrics" [] # Get node metrics.
export extern "lncli getchaninfo" []    # Get the state of a channel.
export extern "lncli getnodeinfo" []    # Get information on a specific node.

# Invoices:
export extern "lncli addinvoice" []     # Add a new invoice.
export extern "lncli lookupinvoice" []  # Lookup an existing invoice by its payment hash.
export extern "lncli listinvoices" []   # List all invoices currently stored within the database. Any active debug invoices are ignored.
export extern "lncli decodepayreq" []   # Decode a payment request.
export extern "lncli cancelinvoice" []  # Cancels a (hold) invoice.
export extern "lncli addholdinvoice" [] # Add a new hold invoice.
export extern "lncli settleinvoice" []  # Reveal a preimage and use it to settle the corresponding invoice.

# Macaroons:
export extern "bakemacaroon" []      # Bakes a new macaroon with the provided list of permissions and restrictions.
export extern "listmacaroonids" []   # List all macaroons root key IDs in use.
export extern "deletemacaroonid" []  # Delete a specific macaroon ID.
export extern "listpermissions" []   # Lists all RPC method URIs and the macaroon permissions they require to be invoked.
export extern "printmacaroon" []     # Print the content of a macaroon in a human readable format.
export extern "constrainmacaroon" [] # Adds one or more restriction(s) to an existing macaroon

# Mission Control:
export extern "lncli querymc" []  # Query the internal mission control state.
export extern "lncli resetmc" []  # Reset internal mission control state.
export extern "lncli getmccfg" [] # Display mission control's config.
export extern "lncli setmccfg" [] # Set mission control's config.

# Neutrino:
export extern "lncli neutrino" [] # Interact with a running neutrino instance.

# On-chain:
export extern "lncli estimatefee" []   # Get fee estimates for sending bitcoin on-chain to multiple addresses.
export extern "lncli sendmany" []      # Send bitcoin on-chain to multiple addresses.
export extern "lncli sendcoins" []     # Send bitcoin on-chain to an address.
export extern "lncli listunspent" []   # List utxos available for spending.
export extern "lncli listchaintxns" [] # List transactions from the wallet.
export extern "lncli chain" []         # Interact with the bitcoin blockchain.

# Payments:
export extern "lncli sendpayment" []    # Send a payment over lightning.
export extern "lncli payinvoice" []     # Pay an invoice over lightning.
export extern "lncli sendtoroute" []    # Send a payment over a predefined route.
export extern "lncli listpayments" []   # List all outgoing payments.
export extern "lncli queryroutes" []    # Query a route to a destination.
export extern "lncli fwdinghistory" []  # Query the history of all forwarded HTLCs.
export extern "lncli trackpayment" []   # Track progress of an existing payment.
export extern "lncli deletepayments" [] # Delete a single or multiple payments from the database.
export extern "lncli importmc" []       # Import a result to the internal mission control state.
export extern "lncli buildroute" []     # Build a route from a list of hop pubkeys.

# Peers:
export extern "lncli connect" []    # Connect to a remote lnd peer.
export extern "lncli disconnect" [] # Disconnect a remote lnd peer identified by public key.
export extern "lncli listpeers" []  # List all active, currently connected peers.
export extern "lncli peers" []      # Interacts with the other nodes of the network.

# Profiles:
export extern "lncli profile" [] # Create and manage lncli profiles.

# Startup:
export extern "lncli create" []          # Initialize a wallet when starting lnd for the first time.
export extern "lncli createwatchonly" [] # Initialize a watch-only wallet after starting lnd for the first time.
export extern "lncli unlock" []          # Unlock an encrypted wallet at startup.
export extern "lncli changepassword" []  # Change an encrypted wallet's password at startup.
export extern "lncli state" []           # Get the current state of the wallet and RPC.

# Wallet:
export extern "lncli newaddress" []    # Generates a new address.
export extern "lncli walletbalance" [] # Compute and display the wallet's current balance.
export extern "lncli signmessage" []   # Sign a message with the node's private key.
export extern "lncli verifymessage" [] # Verify a message signed with the signature.
export extern "lncli wallet" []        # Interact with the wallet.

# Watchtower:
export extern "lncli tower" []    # Interact with the watchtower.
export extern "lncli wtclient" [] # Interact with the watchtower client.

# GLOBAL OPTIONS:
export extern main [
   --rpcserver: string          # The host:port of LN daemon. (default: "localhost:10009")
   --lnddir: string             # The path to lnd's base directory. (default: "/home/anthony/.lnd")
   --socksproxy: string         # The host:port of a SOCKS proxy through which all connections to the LN daemon will be established over.
   --tlscertpath: string        # The path to lnd's TLS certificate. (default: "/home/anthony/.lnd/tls.cert")
   --chain(-c): string          # The chain lnd is running on, e.g. bitcoin. (default: "bitcoin")
   --network(-n): string        # The network lnd is running on, e.g. mainnet, testnet, etc. (default: "mainnet")
   --no-macaroons             # Disable macaroon authentication.
   --macaroonpath: string       # The path to macaroon file.
   --macaroontimeout: string    # Anti-replay macaroon validity time in seconds. (default: 60)
   --macaroonip: string         # If set, lock macaroon to specific IP address.
   --profile(-p): string        # Instead of reading settings from command line parameters or using the default profile, use a specific profile. If a default profile is set, this flag can be set to an empty string to disable reading values from the profiles file.
   --macfromjar: string         # Use this macaroon from the profile's macaroon jar instead of the default one. Can only be used if profiles are defined.
   --metadata: string           # This flag can be used to specify a key-value pair that should be appended to the outgoing context before the request is sent to lnd. This flag may be specified multiple times. The format is: "key:value".
   --help(-h)                 # show help
   --version(-v)              # print the version
]
