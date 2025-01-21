#!/usr/bin/env bash

# check for mise
if ! command -v mise &>/dev/null; then
    echo "Please install mise first (run 'curl https://mise.run | sh')"
    echo ""
    echo "Then load mise into your path by adding it to your .bashrc or .zshrc (or .profile) file"
    echo "   echo 'eval \"\$(~/.local/bin/mise activate zsh)\"' >> ~/.zshrc"

    exit 1
else
    eval "$(mise activate bash)"
fi

# Run these if you use experimental features like automatic import of .env files
# mise settings set experimental true
# mise trust

# Check if GITHUB_TOKEN is set
if [ -z "$GITHUB_TOKEN" ]; then
    echo "GITHUB_TOKEN is not set. This is used to get past rate limiting when checking github's API for versions."
    echo "Please set this with your personal token and try again."
    exit 1
fi

# Install all dependencies
mise install -y
