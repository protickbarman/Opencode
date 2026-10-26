#!/bin/bash
set -e

echo "=============================================="
echo "  OpenCode Docker — Full Access Mode"
echo "=============================================="

# Ensure OpenCode config directory exists
mkdir -p /root/.config/opencode

# Set the server password to 12345 (username: opencode)
echo '{"password": "12345"}' > /root/.config/opencode/service.json
export OPENCODE_PASSWORD="${OPENCODE_PASSWORD:-12345}"

# Render provides $PORT; default to 3000 locally
PORT="${PORT:-3000}"
HOSTNAME="${HOSTNAME:-0.0.0.0}"

# Ensure workspace exists
WORKSPACE="${WORKSPACE:-/workspace}"
mkdir -p "${WORKSPACE}"
cd "${WORKSPACE}"

echo "Workspace: ${WORKSPACE}"
echo "Password:  ${OPENCODE_PASSWORD}  (username: opencode)"
echo "Listening on: ${HOSTNAME}:${PORT}"
echo ""

# exec replaces the shell so SIGTERM/SIGINT reach OpenCode directly
exec opencode serve --port "${PORT}" --hostname "${HOSTNAME}" --print-logs
