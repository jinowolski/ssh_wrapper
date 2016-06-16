#!/bin/bash

set -e
set -f

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P )"
COMMANDS_DIR="$DIR/commands"
set -- $SSH_ORIGINAL_COMMAND
COMMAND="$1"
shift
EXECUTABLE=$(realpath -m "$COMMANDS_DIR/$COMMAND")
EXECUTABLE_DIR=$(dirname "$EXECUTABLE")

if [ "$EXECUTABLE_DIR" != "$COMMANDS_DIR" ]; then
    >2& echo "Unknown command."
    logger -p auth.warning -- "ssh_wrapper WARNING: Invalid directory. Caller tried command '$COMMAND'."
    exit 1
fi

if [ ! -x "$EXECUTABLE" ]; then
    if [ -f "$EXECUTABLE" ]; then
        logger -p auth.info -- "ssh_wrapper INFO: Command '$COMMAND' exists, but cannot be executed."
        >2& echo "This command exists, but cannot be executed."
    else
        logger -p auth.info -- "ssh_wrapper INFO: Unknown command '$COMMAND'."
        >2& echo "Unknown command."
    fi
    exit 1
fi

logger -p auth.info -- "ssh_wrapper INFO: Executing command '$COMMAND' with args '$@'."
$EXECUTABLE "$@"
