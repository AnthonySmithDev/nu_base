# NAME:
   # lncli - control plane for your Lightning Network Daemon (lnd)

# USAGE:
   # lncli [global options] command [command options] [arguments...]

# VERSION:
   # 0.16.4-beta commit=v0.16.4-beta

# COMMANDS:
 export extern getinfo []          # Returns basic information related to the active daemon.
 export extern getrecoveryinfo []  # Display information about an ongoing recovery attempt.
 export extern debuglevel []       # Set the debug level.
 export extern stop []             # Stop and shutdown the daemon.
 export extern version []          # Display lncli and lnd version info.
 export extern sendcustom []
 export extern subscribecustom []
 export extern help []             # Shows a list of commands or help for one command

# Autopilot:
export extern autopilot [] # Interact with a running autopilot.

# Channels:
export extern openchannel []       # Open a channel to a node or an existing peer.
export extern batchopenchannel []  # Open multiple channels to existing peers in a single transaction.
export extern closechannel []      # Close an existing channel.
export extern closeallchannels []  # Close all existing channels.
export extern abandonchannel []    # Abandons an existing channel.
export extern channelbalance []    # Returns the sum of the total available channel balance across all open channels.
export extern pendingchannels []   # Display information pertaining to pending channels.
export extern listchannels []      # List all open channels.
export extern closedchannels []    # List all closed channels.
export extern getnetworkinfo []    # Get statistical information about the current state of the network.
export extern feereport []         # Display the current fee policies of all active channels.
export extern updatechanpolicy []  # Update the channel policy for all channels, or a single channel.
export extern exportchanbackup []  # Obtain a static channel back up for a selected channels, or all known channels.
export extern verifychanbackup []  # Verify an existing channel backup.
export extern restorechanbackup [] # Restore an existing single or multi-channel static channel backup.
export extern listaliases []       # List all aliases.
export extern updatechanstatus []  # Set the status of an existing channel on the network.

# Graph:
export extern describegraph []  # Describe the network graph.
export extern getnodemetrics [] # Get node metrics.
export extern getchaninfo []    # Get the state of a channel.
export extern getnodeinfo []    # Get information on a specific node.

# Invoices:
export extern addinvoice []     # Add a new invoice.
export extern lookupinvoice []  # Lookup an existing invoice by its payment hash.
export extern listinvoices []   # List all invoices currently stored within the database. Any active debug invoices are ignored.
export extern decodepayreq []   # Decode a payment request.
export extern cancelinvoice []  # Cancels a (hold) invoice.
export extern addholdinvoice [] # Add a new hold invoice.
export extern settleinvoice []  # Reveal a preimage and use it to settle the corresponding invoice.

# Macaroons:
export extern bakemacaroon []      # Bakes a new macaroon with the provided list of permissions and restrictions.
export extern listmacaroonids []   # List all macaroons root key IDs in use.
export extern deletemacaroonid []  # Delete a specific macaroon ID.
export extern listpermissions []   # Lists all RPC method URIs and the macaroon permissions they require to be invoked.
export extern printmacaroon []     # Print the content of a macaroon in a human readable format.
export extern constrainmacaroon [] # Adds one or more restriction(s) to an existing macaroon

# Mission Control:
export extern querymc []  # Query the internal mission control state.
export extern resetmc []  # Reset internal mission control state.
export extern getmccfg [] # Display mission control's config.
export extern setmccfg [] # Set mission control's config.

# Neutrino:
export extern neutrino [] # Interact with a running neutrino instance.

# On-chain:
export extern estimatefee []   # Get fee estimates for sending bitcoin on-chain to multiple addresses.
export extern sendmany []      # Send bitcoin on-chain to multiple addresses.
export extern sendcoins []     # Send bitcoin on-chain to an address.
export extern listunspent []   # List utxos available for spending.
export extern listchaintxns [] # List transactions from the wallet.
export extern chain []         # Interact with the bitcoin blockchain.

# Payments:
export extern sendpayment []    # Send a payment over lightning.
export extern payinvoice []     # Pay an invoice over lightning.
export extern sendtoroute []    # Send a payment over a predefined route.
export extern listpayments []   # List all outgoing payments.
export extern queryroutes []    # Query a route to a destination.
export extern fwdinghistory []  # Query the history of all forwarded HTLCs.
export extern trackpayment []   # Track progress of an existing payment.
export extern deletepayments [] # Delete a single or multiple payments from the database.
export extern importmc []       # Import a result to the internal mission control state.
export extern buildroute []     # Build a route from a list of hop pubkeys.

# Peers:
export extern connect []    # Connect to a remote lnd peer.
export extern disconnect [] # Disconnect a remote lnd peer identified by public key.
export extern listpeers []  # List all active, currently connected peers.
export extern peers []      # Interacts with the other nodes of the network.

# Profiles:
export extern profile [] # Create and manage lncli profiles.

# Startup:
export extern create []          # Initialize a wallet when starting lnd for the first time.
export extern createwatchonly [] # Initialize a watch-only wallet after starting lnd for the first time.
export extern unlock []          # Unlock an encrypted wallet at startup.
export extern changepassword []  # Change an encrypted wallet's password at startup.
export extern state []           # Get the current state of the wallet and RPC.

# Wallet:
export extern newaddress []    # Generates a new address.
export extern walletbalance [] # Compute and display the wallet's current balance.
export extern signmessage []   # Sign a message with the node's private key.
export extern verifymessage [] # Verify a message signed with the signature.
export extern wallet []        # Interact with the wallet.

# Watchtower:
export extern tower []    # Interact with the watchtower.
export extern wtclient [] # Interact with the watchtower client.

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
   --yoda
   --hansolo
]
