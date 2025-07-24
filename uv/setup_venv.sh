#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(dirname "$0")"
#CHIPYARD=$(git rev-parse --show-toplevel)

ACTIVATE_EXT=""

show_help() {
  echo "Set up the Python virtual environment for this project. Should be run as:"
  echo "  eval \$($0)"
  echo
  echo "Usage: $0 [-f] [-h]"
  echo
  echo "Options:"
  echo "  -f  Set up virtual environment for the fish shell."
  echo "  -h  Display this help message."
}

while getopts "fh" opt; do
  case $opt in
    f)
      ACTIVATE_EXT=".fish"
      ;;
    h)
      show_help
      exit 0
      ;;
    \?)
      show_help
      exit 1
      ;;
  esac
done

SRC_CMD=""

# Note that there is a ; at the end of each string
# which is required for eval() to be able to separate
# the command ordering
format_cmd_for_eval() {
  local src="$1"
  printf -v SRC_CMD '%s%s;\n' "$SRC_CMD" "$src"
}

# Set up Python environment
format_cmd_for_eval "pushd $SCRIPT_DIR > /dev/null"
format_cmd_for_eval "uv sync"
format_cmd_for_eval "source ./.venv/bin/activate${ACTIVATE_EXT}"
format_cmd_for_eval "popd > /dev/null"

# Set up Javascript environment
#format_cmd_for_eval "pushd $CHIPYARD > /dev/null"
#format_cmd_for_eval "npm install"
#format_cmd_for_eval "popd > /dev/null"

echo "$SRC_CMD"

