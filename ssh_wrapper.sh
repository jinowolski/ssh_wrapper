#!/bin/bash

set -e
set -f

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P )"
COMMANDS_DIR="$DIR/commands"
set -- $SSH_ORIGINAL_COMMAND
COMMAND="$1"
shift
EXECUTABLE=$(realpath "$COMMANDS_DIR/$COMMAND")
EXECUTABLE_DIR=$(dirname "$EXECUTABLE")

if [ "$EXECUTABLE_DIR" != "$COMMANDS_DIR" ]; then
    echo "Unknown command." 1>&2
    logger -p auth.warning -- "ssh_wrapper WARNING: Invalid directory. Caller tried command '$COMMAND'."
    exit 1
fi

if [ ! -x "$EXECUTABLE" ]; then
    if [ -f "$EXECUTABLE" ]; then
        logger -p auth.info -- "ssh_wrapper INFO: Command '$COMMAND' exists, but cannot be executed."
        echo "This command exists, but cannot be executed." 1>&2
    else
        logger -p auth.info -- "ssh_wrapper INFO: Unknown command '$COMMAND'."
        echo "Unknown command." 1>&2
    fi
    exit 1
fi

logger -p auth.info -- "ssh_wrapper INFO: Executing command '$COMMAND' with args '$@'."
$EXECUTABLE "$@"
