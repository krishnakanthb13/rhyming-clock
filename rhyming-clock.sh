#!/bin/bash

# ==========================================================
# Rhyming Clock Launcher (Linux/macOS)
# ==========================================================

echo "[SYSTEM] Initializing Rhyming Clock..."

# 1. Start Background Logger (if powershell is available or provide an alternative)
# For now, we'll assume the user is primarily on Windows but wants the .sh for WSL/Linux
# We won't attempt to start the PS1 on Linux unless pwsh is installed.

# 2. Get current folder
APP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
APP_PATH="$APP_DIR/rhyming-clock.html"

# 3. Load API Key from .env file
echo "[SYSTEM] Loading configurations..."

if [ ! -f "$APP_DIR/.env" ]; then
    if [ -f "$APP_DIR/.env.example" ]; then
        echo "[SYSTEM] Creating .env from .env.example..."
        cp "$APP_DIR/.env.example" "$APP_DIR/.env"
    else
        echo "[WARNING] .env.example not found."
    fi
fi

API_KEY=""
if [ -f "$APP_DIR/.env" ]; then
    API_KEY=$(grep GEMINI_API_KEY "$APP_DIR/.env" | cut -d '=' -f2)
fi

# Append Key to URL if found
if [ -n "$API_KEY" ]; then
    APP_URL="file://$APP_PATH?key=$API_KEY"
else
    APP_URL="file://$APP_PATH"
    echo "[WARNING] No API Key found in .env file."
fi

# 4. Configuration
WIDTH=350
HEIGHT=200

# 5. Launch the Browser (Chrome/Chromium)
echo "[SYSTEM] Launching widget..."

# Try to find chrome/chromium
CHROME_BIN=""
if command -v google-chrome &> /dev/null; then
    CHROME_BIN="google-chrome"
elif command -v google-chrome-stable &> /dev/null; then
    CHROME_BIN="google-chrome-stable"
elif command -v chromium-browser &> /dev/null; then
    CHROME_BIN="chromium-browser"
elif command -v chromium &> /dev/null; then
    CHROME_BIN="chromium"
elif [ -d "/Applications/Google Chrome.app" ]; then
    CHROME_BIN="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
fi

ARGS="--app=$APP_URL --window-size=$WIDTH,$HEIGHT --user-data-dir=/tmp/RhymingClockProfile --disable-extensions --no-first-run --autoplay-policy=no-user-gesture-required"

if [ -n "$CHROME_BIN" ]; then
    "$CHROME_BIN" $ARGS &
else
    # Fallback to default browser
    if [[ "$OSTYPE" == "darwin"* ]]; then
        open "$APP_URL"
    else
        xdg-open "$APP_URL"
    fi
fi
