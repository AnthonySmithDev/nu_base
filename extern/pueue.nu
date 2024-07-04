# Interact with the Pueue daemon
# VERSION: 3.3.0

# Enqueue a task for execution.
export extern add []

# Remove tasks from the list. Running or paused tasks need to be killed first
export extern remove []

# Switches the queue position of two commands. Only works on queued and stashed commands
export extern switch []

# Stashed tasks won't be automatically started. You have to enqueue them or start them by hand
export extern stash []

# Enqueue stashed tasks. They'll be handled normally afterwards
export extern enqueue []

# Resume operation of specific tasks or groups of tasks.
export extern start []

# Restart failed or successful task(s).
export extern restart []

# Either pause running tasks or specific groups of tasks.
export extern pause []

# Kill specific running tasks or whole task groups..
export extern kill []

# Send something to a task. Useful for sending confirmations such as 'y\n'
export extern send []

# Edit the command, path or label of a stashed or queued task.
export extern edit []

# Use this to add or remove groups.
export extern group []

# Display the current status of all tasks
export extern status []

# Accept a list or map of JSON pueue tasks via stdin and display it just like "pueue status".
export extern format-status []

# Display the log output of finished tasks.
export extern log []

# Follow the output of a currently running task. This command works like "tail -f"
export extern follow []

# Wait until tasks are finished.
export extern wait []

# Remove all finished tasks from the list
export extern clean []

# Kill all tasks, clean up afterwards and reset EVERYTHING!
export extern reset []

# Remotely shut down the daemon. Should only be used if the daemon isn't started by a service manager
export extern shutdown []

# Set the amount of allowed parallel tasks
export extern parallel []

# Generates shell completion files. This can be ignored during normal operations
export extern completions []

# Print this message or the help of the given subcommand(s)
export extern help []
