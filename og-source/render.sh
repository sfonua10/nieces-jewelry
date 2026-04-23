#!/usr/bin/env bash
# Render og-source/og.html to images/og-image.png (1200x630).
# Uses Chrome headless + sips (both present by default on macOS).
# Oversizes the render to 1200x720 and crops to 1200x630 because
# Chrome's headless viewport runs a little short of --window-size.

set -euo pipefail

# Resolve paths relative to this script so it works from anywhere.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SOURCE_HTML="$SCRIPT_DIR/og.html"
OUTPUT_PNG="$PROJECT_DIR/images/og-image.png"
RAW_PNG="$(mktemp -t og-raw.XXXXXX).png"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

if [ ! -x "$CHROME" ]; then
  echo "error: Google Chrome not found at $CHROME" >&2
  exit 1
fi
if [ ! -f "$SOURCE_HTML" ]; then
  echo "error: source not found at $SOURCE_HTML" >&2
  exit 1
fi

trap 'rm -f "$RAW_PNG"' EXIT

# Chrome headless on macOS writes the screenshot but doesn't exit on its own.
# We launch it in the background, poll for the file, then kill it once the PNG exists.
CHROME_USER_DIR="$(mktemp -d -t chrome-og.XXXXXX)"

"$CHROME" \
  --headless=new \
  --disable-gpu \
  --hide-scrollbars \
  --no-sandbox \
  --no-first-run \
  --no-default-browser-check \
  --force-device-scale-factor=1 \
  --window-size=1200,720 \
  --virtual-time-budget=8000 \
  --user-data-dir="$CHROME_USER_DIR" \
  --screenshot="$RAW_PNG" \
  "file://$SOURCE_HTML" >/dev/null 2>&1 &
CHROME_PID=$!

# Wait up to 20s for Chrome to produce the PNG.
for _ in $(seq 1 40); do
  if [ -s "$RAW_PNG" ]; then sleep 0.3; break; fi
  sleep 0.5
done

kill -9 "$CHROME_PID" 2>/dev/null || true
wait "$CHROME_PID" 2>/dev/null || true
rm -rf "$CHROME_USER_DIR"

if [ ! -s "$RAW_PNG" ]; then
  echo "error: Chrome produced no image after 20s" >&2
  exit 1
fi

sips --cropOffset 0 0 --cropToHeightWidth 630 1200 "$RAW_PNG" --out "$OUTPUT_PNG" >/dev/null

echo "wrote $OUTPUT_PNG ($(sips -g pixelWidth -g pixelHeight "$OUTPUT_PNG" | awk '/pixelWidth|pixelHeight/ {print $2}' | paste -sd x -))"
