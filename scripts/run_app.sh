#!/usr/bin/env zsh
set -euo pipefail

# Move to repo root
cd "$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

# Load optional .env values
if [ -f .env ]; then
  # shellcheck disable=SC2046
  export $(grep -E '^(REDDIT_CLIENT_ID|REDDIT_REDIRECT_URI)=' .env | sed 's/\r$//' | xargs -I {} echo {}) || true
fi

if [ -z "${REDDIT_CLIENT_ID:-}" ] || [ -z "${REDDIT_REDIRECT_URI:-}" ]; then
  echo "Missing REDDIT_CLIENT_ID or REDDIT_REDIRECT_URI."
  echo "Set them in your environment or in a .env file at repo root, e.g.:"
  echo "REDDIT_CLIENT_ID=your_client_id" 
  echo "REDDIT_REDIRECT_URI=com.example.app:/"
  exit 1
fi

# Default device (macOS on Darwin; otherwise first available or web-server)
DEVICE="${1:-}"
if [ -z "$DEVICE" ]; then
  if [[ "$OSTYPE" == darwin* ]]; then
    DEVICE="macos"
  else
    DEVICE="web-server"
  fi
fi

flutter pub get
exec flutter run -d "$DEVICE" \
  --dart-define=REDDIT_CLIENT_ID="$REDDIT_CLIENT_ID" \
  --dart-define=REDDIT_REDIRECT_URI="$REDDIT_REDIRECT_URI"

