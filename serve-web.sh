#!/usr/bin/env bash
# Serves the Godot web build with COOP/COEP headers for SharedArrayBuffer support.

set -euo pipefail

PORT="${1:-8080}"
BUILD_DIR="${2:-build/web}"

# Resolve build dir relative to script location, not CWD
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FULL_BUILD_DIR="$SCRIPT_DIR/$BUILD_DIR"

if [[ ! -d "$FULL_BUILD_DIR" ]]; then
    echo "Error: Build directory not found: $FULL_BUILD_DIR" >&2
    echo "Did you export the web build from Godot?" >&2
    exit 1
fi

# Write serve.json with required headers (overwrites each run so it stays in sync)
cat > "$FULL_BUILD_DIR/serve.json" <<'EOF'
{
  "headers": [
    {
      "source": "**/*",
      "headers": [
        { "key": "Cross-Origin-Opener-Policy", "value": "same-origin" },
        { "key": "Cross-Origin-Embedder-Policy", "value": "require-corp" },
        { "key": "Cache-Control", "value": "no-store" }
      ]
    }
  ]
}
EOF

echo "Serving $FULL_BUILD_DIR on http://localhost:$PORT"
echo "Press Ctrl+C to stop."
echo

npx --yes serve "$FULL_BUILD_DIR" -l "$PORT"
