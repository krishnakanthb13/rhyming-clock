# 💻 Code Documentation: Rhyming Clock

This document explains the technical implementation of the Rhyming Clock project.

## 🏗️ Architecture Overview

The project consists of two main components:
1.  **`rhyming-clock.bat`**: The Windows launcher script.
2.  **`rhyming-clock.html`**: The core application (HTML5/CSS3/JavaScript).

---

## 🐚 Batch Script (`rhyming-clock.bat`)

The batch script acts as a wrapper to launch the web page as a standalone desktop widget.

### Key Logic:
- **Directory Detection & Path Formatting**: Uses `%~dp0` and automatically converts Windows backslashes (`\`) to browser-friendly forward slashes (`/`). This ensures the HTML file loads correctly even if the path contains special characters.
- **Minimized Background Logger**: Automatically spawns `logger-server.ps1` in a minimized state using `start /min`.
- **Robust Position Calculation**: Uses the `System.Windows.Forms` assembly via PowerShell to accurately detect the primary screen's width, ensuring the widget is perfectly placed regardless of DPI scaling.
- **App Mode Launch**: Uses the `--app` flag in Chrome/Edge. This removes the browser UI (tabs, address bar), making the HTML page look like a native application.
- **Profile Isolation**: Uses `--user-data-dir="%TEMP%\RhymingClockProfile"`. This prevents the widget from interfering with your main browser tabs or history.

---

## 🎨 Frontend Application (`rhyming-clock.html`)

A single-file SPA (Single Page Application) that handles the UI, Clock, and AI integration.

### 1. Styling (CSS)
- **CRT Effect**: Uses a repeating `linear-gradient` as a `::before` pseudo-element to simulate scanlines.
- **Animations**: 
  - `pulse`: Animate the opacity of the "Power LED".
  - `blink-caret`: Simulates a terminal cursor.
- **Layout**: Uses Flexbox to perfectly center the poem within the simulated screen.

### 2. Logic (JavaScript)
- **1-Minute Sync Loop**: Instead of checking every second, the app uses a `scheduleNextUpdate()` function. It calculates the exact remaining milliseconds in the current minute and sets a high-efficiency `setTimeout`.
- **Visibility-Aware Processing**: The app utilizes the **Page Visibility API**. Inside the update loop, it checks `document.visibilityState`. If the window is hidden or minimized, it skips the expensive Gemini API call and the typing animation.
- **Instant Catch-up**: A listener on `visibilitychange` ensures that as soon as the window becomes visible again, the app immediately checks if the time has changed and generates a fresh poem if needed.
- **AI Integration & Flavor Mapping**:
  - The `getPersonality(date)` function maps the current hour to a "flavor" (Motivating, Dull, Easy, or Kinky).
  - These flavors are dynamically injected into the `poemPrompt` as a `{personality}` token.
  - The UI updates a `SYS_MODE` indicator to reflect the current personality.
  - **Request Handling**: Sends a JSON POST request to the Google Gemini API.
  - The prompt is carefully crafted to ensure the AI returns ONLY the poem, keeping the UI clean.
- **Typing Engine**: 
  - The `typePoem` function loops through the string and updates `innerHTML` with a simulated cursor.
  - It utilizes the **Web Audio API** to generate "Blip" sounds for each character.
  - **Memory Management**: Oscillator and Gain nodes are explicitly disconnected after each sound to prevent memory leaks.
### 3. Automated Logging (CORS-Enabled Local API)
- **Handshake**: On load, the app sends an `OPTIONS` request to `localhost:8080` to check for the logger server.
- **Async Logging**: When a poem is generated, the app sends the formatted text to the background server via a `POST` request.
- **UI Status**: The `[ LOG ]` indicator updates to `AUTO` if a connection is established, or `OFFLINE` if the server isn't running.

---

---

## 🛠️ Background Logger (`logger-server.ps1`)

Due to browser security sandboxing, web pages cannot write directly to the local disk without user interaction.

### Implementation:
- **`HttpListener`**: A lightweight PowerShell-based HTTP server listening on port 8080.
- **CORS Compliance**: The server explicitly sends `Access-Control-Allow-Origin: *` and handles `OPTIONS` (pre-flight) requests, enabling the browser to talk to the local machine.
- **Stream Handling**: Receives poem text via `POST` requests and appends it to `rhyming-clock-log.txt`.
- **UTF-8 Encoding**: Ensures that special characters in the AI response are preserved.

---

## ⚙️ Performance Optimizations

Based on user feedback, the following optimizations have been implemented:
1.  **Ultra-Low Wakeups**: Replaced the 1-second interval with a 1-minute smart sync, allowing the browser process to remain virtually idle.
2.  **Hardware Acceleration**: Animations now use `opacity` instead of property changes that trigger layout reflows.
3.  **Audio Node Disposal**: Web Audio nodes are cleaned up after use.
4.  **Lazy Audio Initialization**: The audio context starts only after user interaction.
5.  **Browser Flags**: Added `--disable-extensions`, `--no-first-run`, and others to minimize the Chromium footprint.
6.  **Minimized Logger**: The logging server is launched minimized to avoid cluttering the desktop.
