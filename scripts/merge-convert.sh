#!/usr/bin/env bash

# Check if the target directory is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <target_directory>"
  exit 1
fi

TARGET_DIR="$1"

# Check if the target directory exists
if [ ! -d "$TARGET_DIR" ]; then
  echo "Error: Directory $TARGET_DIR does not exist."
  exit 1
fi

# Loop through all .tf files in the target directory and print to the screen
for tf_file in "$TARGET_DIR"/*.tf; do
  cat "$tf_file"
  echo -e "\n" # Add a newline for separation
done
