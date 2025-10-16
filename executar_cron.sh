#!/bin/bash

# Exit if no command is provided
if [ -z "$1" ]; then
  echo "Usage: $0 /path/to/script.sh [args...]" >&2
  exit 1
fi

# The log file name is derived from the script being run
# e.g., $HOME/Guardiao-RPA/atualizacao_segura.sh -> atualizacao_segura
LOG_BASE_NAME=$(basename "$1" .sh)
LOG_FILE="$HOME/Logs/${LOG_BASE_NAME}_$(date +%Y%m%d).log"

# Execute the actual script passed as an argument, with redirection
# "$@" allows passing all arguments of cron_runner.sh to the target script
"$@" >> "$LOG_FILE" 2>&1
