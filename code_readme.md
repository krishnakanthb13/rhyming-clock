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
- **AI Integration**:
  - When the minute changes, it calls `generatePoem(now)`.
  - It sends a JSON POST request to the Google Gemini API.
  - The prompt is carefully crafted to ensure the AI returns ONLY the poem, keeping the UI clean.
- **Typing Engine**: 
  - The `typePoem` function loops through the string and updates `innerHTML` with a simulated cursor.
  - It utilizes the **Web Audio API** to generate "Blip" sounds for each character.
  - **Memory Management**: Oscillator and Gain nodes are explicitly disconnected after each sound to prevent memory leaks.

---

## ⚙️ Performance Optimizations

Based on user feedback, the following optimizations have been implemented:
1.  **Ultra-Low Wakeups**: Replaced the 1-second interval with a 1-minute smart sync, allowing the browser process to remain virtually idle between updates.
2.  **Hardware Acceleration**: Animations now use `opacity` instead of property changes that trigger layout reflows.
3.  **Audio Node Disposal**: Ensured that Web Audio nodes are cleaned up after use to keep the memory footprint low.
4.  **Lazy Audio Initialization**: The audio context only starts after user interaction to comply with modern browser policies.
5.  **Browser Flags**: Added `--disable-extensions`, `--no-first-run`, and `--disable-plugins` to the batch launcher to further reduce memory and CPU usage of the Chromium process.
