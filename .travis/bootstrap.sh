#!/bin/bash

# Set environment and source profiles
if [[ -s "$HOME/.bash_profile" ]]; then
  source "$HOME/.bash_profile"
fi

if [[ -s "$HOME/.bashrc" ]]; then
  source "$HOME/.bashrc"
fi

# Setup .travis helper functions directory
mkdir -p "$HOME/.travis"

# Define Travis utility functions
cat <<'EOF' >> "$HOME/.travis/job_stages"
ANSI_RED="\033[31;1m"
ANSI_GREEN="\033[32;1m"
ANSI_RESET="\033[0m"

travis_cmd() {
  local cmd=$1
  echo -e "${ANSI_GREEN}Running: $cmd${ANSI_RESET}"
  eval "$cmd"
  local result=$?
  if [ $result -ne 0 ]; then
    echo -e "${ANSI_RED}Command failed: $cmd${ANSI_RESET}"
    exit $result
  fi
}

travis_retry() {
  local result=1
  local count=0
  until [ $count -ge 3 ]; do
    "$@" && result=0 && break
    count=$((count + 1))
    echo -e "${ANSI_RED}Retry $count failed. Retrying...${ANSI_RESET}"
    sleep 1
  done
  return $result
}
EOF

# Source it in .bashrc so it's available in the job
echo "source $HOME/.travis/job_stages" >> "$HOME/.bashrc"
source "$HOME/.travis/job_stages"

# Print confirmation
echo "Bootstrap completed successfully."
