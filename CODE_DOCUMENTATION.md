# 💻 Code Documentation: Rhyming Clock

This document provides a technical walkthrough of the Rhyming Clock architecture, core functions, and integrations.

## 🏗️ Architecture Overview

The project is built as a lightweight, single-page desktop widget composed of three primary layers:

1.  **Windows Wrapper (`rhyming-clock.bat`)**: Configures the environment and launches Chrome/Edge in application mode.
2.  **Frontend Engine (`rhyming-clock.html`)**: Handles time synchronization, UI rendering, AI communication (Gemini API), and audio (TTS/Typing sounds).
3.  **Background Logger (`logger-server.ps1`)**: A local PowerShell-based HTTP server that bypasses browser sandboxing to record poems to disk.

---

### File Structure

| File | Type | Description |
| :--- | :--- | :--- |
| `rhyming-clock.bat` | Batch Script | The entry point. Configures window size, position, and browser flags. Initializes `.env` if missing. |
| `rhyming-clock.sh` | Shell Script | Linux/macOS equivalent of the launcher. |
| `rhyming-clock.html` | HTML/JS/CSS | The core application logic and UI. |
| `logger-server.ps1` | PowerShell | Local HTTP listener that writes poems to `rhyming-clock-log.txt`. |
| `run-logger.bat` | Batch Script | Helper to launch the PowerShell logger. |
| `.env.example` | Template | Template for environment variables. |
| `.env` | Config | Stores the `GEMINI_API_KEY`. (Created from `.env.example`) |
| `rhyming-clock-log.txt` | Log File | Plain text file containing the history of generated poems. |

---

## 🔑 Core Methods & Functions

### Frontend (`rhyming-clock.html`)

| Function | Purpose | Key Logic |
| :--- | :--- | :--- |
| `updateClock()` | Main Loop | Calculates the current time, updates the digital clock, and triggers AI generation on the minute mark. An `isGenerating` flag guards against concurrent runs from the scheduled timer and visibility-change events; if a poem is still in progress, the minute is retried on a later tick rather than skipped. |
| `getPoem()` | AI Integration | Sends a POST request to Google Gemini API with a time-specific personality prompt. The API key is passed via the `x-goog-api-key` header. Transient `429`/`5xx` failures are retried with `Retry-After`/exponential backoff. |
| `canMakeRequest()` | Rate Limiting | Sliding-window guard that ensures API calls never exceed Gemma 4 26B's 15 requests/minute quota. |
| `recordRequest()` | Rate Limiting | Logs an API call timestamp and persists the sliding window to `localStorage` so the quota survives page reloads. |
| `typePoem(text)` | UI Animation | Gradually renders text on the CRT screen while playing synchronized mechanical sounds. Uses `textContent` (not `innerHTML`) so model output is never parsed as HTML. |
| `speak(text)` | TTS | Uses `speechSynthesis` to read poems aloud with slightly reduced speed for poetic effect. |
| `getPersonality(date)` | Flavor Mapping | Maps the current hour to one of four personalities: Motivating, Dull, Easy, or Kinky. |
| `sendLog(poem)` | Data Persistence | Sends the poem to `localhost:8080` via a POST request for recording. |

### Background Logger (`logger-server.ps1`)

| Method | Description |
| :--- | :--- |
| `HttpListener.Start()` | Begins listening for requests on port 8080. |
| `ProcessRequest()` | Handles `OPTIONS` (CORS pre-flight) and `POST` (Data submission) requests. |
| `Add-Content` | Appends the received poem string to the log file with UTF-8 encoding. |

---

## 📡 API & External Integrations

### Google Gemini API
The app uses the `gemma-4-26b-a4b-it` model (or similar) to generate rhymes. 
- **Endpoint**: `https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent`
- **Authentication**: The API Key is stored in the `.env` file (parsed by the launcher and passed to the page as a URL parameter), then sent to Gemini via the `x-goog-api-key` request header — keeping it out of browser history, referrer headers, and server logs.
- **Initialization**: The launcher scripts automatically create `.env` from `.env.example` if it is not present.
- **Prompting**: Uses a "Personality" system where the system prompt changes based on the time of day.
- **Rate Limiting**: Gemma 4 26B (free tier) permits **15 requests per minute**. A sliding-window limiter (`canMakeRequest()`) tracks request timestamps over a 60-second window and blocks calls that would exceed `GEMINI_RPM_LIMIT`. Timestamps are persisted to `localStorage` (`recordRequest()` / `loadRequestTimestamps()`) so the quota survives page reloads. When the limit is hit, the app degrades gracefully to the offline fallback poem instead of producing `429` errors.
- **Retry & Backoff**: Transient failures (`429` and `5xx`) are retried up to twice, honoring the `Retry-After` header when present and otherwise using capped exponential backoff.

### Web Speech API
Used for the Text-to-Speech (TTS) feature.
- **Local Execution**: All speech generation happens within the browser. No data is sent to external servers for speech synthesis.
- **Voice Selection**: Dynamically identifies available system voices and prioritizes high-quality English voices.

---

## 🔄 Data Flow

1.  **Trigger**: `updateClock` detects a minute change.
2.  **Generation**: `getPoem` checks `canMakeRequest()` (15 RPM limit), then requests a rhyme from Gemini API — or falls back to an offline poem if rate-limited.
3.  **Display**: `typePoem` animates the response on the CRT screen.
4.  **Audio**: `speak` reads the poem; Web Audio API plays typing "blips".
5.  **Recording**: `sendLog` transmits the poem to the PowerShell logger.
6.  **Persistence**: `logger-server.ps1` appends the text to `rhyming-clock-log.txt`.

---

## 🛠️ Dependencies

- **Chrome or Edge**: Required for `--app` mode and advanced Web Audio/Speech APIs.
- **PowerShell 5.1+**: Required for the background logger.
- **Google Gemini API Key**: Required for AI poem generation.
