# 🕰️ Rhyming Clock

![Screenshot](screenshot.png)

> **A retro-styled desktop companion that turns the passing of time into poetry.**

A minimalist widget that uses AI to generate a unique rhyming poem for every minute of the day, displayed on a glowing CRT monitor.

## ✨ Features
- **AI-Powered Poetry**: Every minute, a new 2-line rhyming poem is generated based on the current time using Google Gemini AI.
- **Retro Aesthetic**: Designed with a CRT-style display, scanlines, and a pulsing power LED.
- **Minimalist Window**: Launches in a small, non-intrusive 300x200 window in the top-right corner of your screen.
- **Typing Sound Effects**: Authentic mechanical typing sounds as the poem appears.
- **Resource Efficient**: Ultra-low resource usage. The app now syncs with the system clock and only refreshes once per minute, minimizing background processing.
- **Improved Reliability**: Robust launcher script with automatic path correction and screen detection.

## 🚀 Getting Started

### Prerequisites
1. **Google Chrome** or **Microsoft Edge** (Chromium-based browser).
2. **Gemini API Key**: To get the rhyming poems, you need a free API key from [Google AI Studio](https://aistudio.google.com/).

### Installation & Setup
1.  Clone or download this repository.
2.  Create a file named `.env` in the same folder.
3.  Add your API key to it like this:
    ```
    GEMINI_API_KEY=AIqs......
    ```
4.  Save the file.

### Running the Clock
Simply double-click **`rhyming-clock.bat`**. 

The clock will automatically position itself in the top-right corner of your screen. You can close the terminal window once the clock appears.

## 🛠️ Customization
- **Change Window Size**: Edit the `WIDTH` and `HEIGHT` values in `rhyming-clock.bat`.
- **Change Poem Style**: Modify the `poemPrompt` in the `TRANSLATIONS` section of `rhyming-clock.html`.
- **Colors & Fonts**: Standard CSS can be modified in the `<style>` block of `rhyming-clock.html`.

## 🤝 Contributing
Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## ⚠️ Security Note
**Never commit your `rhyming-clock.html` with your real API key inside.**
If you fork this repository, ensure your API key is removed from the code before pushing.

## 📄 License
This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.
