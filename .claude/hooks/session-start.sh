#!/bin/bash
set -euo pipefail

# Only run in Claude Code on the web (remote sessions)
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

# Install uv if not already available
if ! command -v uv &>/dev/null; then
  echo "Installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh

  # Add uv to PATH for this session
  UV_BIN_DIR="$HOME/.local/bin"
  if [ -d "$UV_BIN_DIR" ]; then
    echo "export PATH=\"$UV_BIN_DIR:\$PATH\"" >> "$CLAUDE_ENV_FILE"
    export PATH="$UV_BIN_DIR:$PATH"
  fi
else
  echo "uv already installed: $(uv --version)"
fi

# Verify uv is functional
uv --version
echo "Session start: uv is ready for journalism tools."
