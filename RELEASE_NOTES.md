# 🕰️ Rhyming Clock Release Notes (v1.3.7)

This release marks a major milestone for **Rhyming Clock**, aggregating significant updates, stability enhancements, cross-platform capabilities, and robust API resilience improvements since **v1.3.2**.

---

## 📋 Changelog (v1.3.2 ➔ v1.3.7)

### 🚀 Features & Core Upgrades
* **Upgraded AI Model (`v1.3.5`)**: Transitioned to Google's `gemma-4-26b-a4b-it` model via the Gemini API for richer and more creative poetic generation.
* **Sliding-Window Rate Limiter (`v1.3.5`)**: Implemented a local sliding-window rate limiter restricted to 15 requests per minute to stay safely within the free-tier API quota.
* **Cross-Platform Launcher (`v1.3.4`)**: Added `rhyming-clock.sh` shell script for Linux/macOS support, making the retro widget available across all major operating systems.
* **Auto-Environment Setup (`v1.3.4`)**: The launcher scripts (`.bat` and `.sh`) now automatically detect a missing `.env` file and generate it from `.env.example`, making initial setup seamless.

### 🔒 Security & Resilience
* **Secure API Key Handling (`v1.3.6`)**: Transitioned API key transmission from the URL query parameter to the `x-goog-api-key` HTTP header, preventing keys from leaking into browser history, referrers, or web logs.
* **Robust Error Recovery (`v1.3.6`)**: Integrated capped exponential backoff and transient error retries (honoring `Retry-After` header) to handle 429 and 5xx API responses gracefully.
* **Safer Rendering (`v1.3.6`)**: Switched poem text rendering from `innerHTML` to `textContent` to prevent arbitrary model output from being parsed as HTML (mitigating styling breakages and XSS vectors).
* **Persistent Rate-Limit State (`v1.3.6`)**: The rate limiter now persists request timestamps to `localStorage` so the free-tier quota is enforced across page reloads.

### 🛠️ Bug Fixes & Code Cleanup
* **Concurrency Guard (`v1.3.6`)**: Added an `isGenerating` flag to prevent simultaneous API requests triggered by overlapping timer ticks and window visibility-change events.
* **HTML Integrity (`v1.3.6`)**: Fixed a malformed HTML issue by adding the missing opening `<head>` tag.
* **Asset Organization (`v1.3.3`)**: Cleaned up the root directory by moving all screenshots, icons, and favicons into a dedicated `assets/` subdirectory.
* **README Grid Alignment (`v1.3.7`)**: Rearranged the screenshots in the main `README.md` into a clean 2x2 grid layout using responsive HTML tags.
