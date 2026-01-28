# Contributing to Rhyming Clock

Thank you for your interest in contributing to the Rhyming Clock project! Wether you're fixing a bug, improving the documentation, or adding a new feature, your help is welcome.

## How to Contribute

1.  **Fork the Repository**: Click the "Fork" button at the top right of this page.
2.  **Clone your Fork**:
    ```bash
    git clone https://github.com/krishnakanthb13/rhyming-clock.git
    ```
3.  **Create a Branch**:
    ```bash
    git checkout -b feature/amazing-new-feature
    ```
4.  **Make Changes**: Edit the code, add comments, and test your changes.
5.  **Commit**:
    ```bash
    git commit -m "Add amazing new feature"
    ```
6.  **Push**:
    ```bash
    git push origin feature/amazing-new-feature
    ```
7.  **Open a Pull Request**: Go to the original repository and click "Compare & pull request".

## Coding Guidelines

-   **HTML/CSS/JS**: Please keep the "One File" structure (`rhyming-clock.html`) unless the change is significant enough to warrant splitting.
-   **Style**: Match the existing coding style (4 spaces indentation, comments for complex logic).
-   **Performance**: Keep the app lightweight. Avoid heavy libraries (jQuery, Bootstrap, etc.).
-   **Compatibility**: Ensure the changes work on Chromium-based browsers (Chrome, Edge).

## Reporting Bugs

If you find a bug, please open an issue with:
-   A description of the bug.
-   Steps to reproduce.
-   Your browser (Chrome/Edge) and OS version.

## Suggesting Features

We love new ideas! When suggesting a feature:
-   Check if it aligns with the [Design Philosophy](DESIGN_PHILOSOPHY.md).
-   Explain the use case and how it benefits the user.
-   Keep in mind the "Minimalist" and "Single File" core principles.

## Development Setup

1.  **Browser**: Use a Chromium-based browser (Google Chrome or Microsoft Edge).
2.  **API Key**: Obtain a Gemini API key from [Google AI Studio](https://aistudio.google.com/).
3.  **Environment**: Run `rhyming-clock.bat` (Windows) or `rhyming-clock.sh` (Mac/Linux) to automatically generate the `.env` file from `.env.example`, then add your `GEMINI_API_KEY`.
4.  **Local Server (Optional)**: If you want to test the logger, run `run-logger.bat`.

## Testing Checklist

Before submitting a Pull Request, please ensure:
- [ ] No API keys or sensitive secrets are hardcoded in `rhyming-clock.html`.
- [ ] The app still launches correctly in `--app` mode via `rhyming-clock.bat`.
- [ ] The "Page Visibility" logic works (AI generation pauses when minimized).
- [ ] Mechanical typing sounds and TTS are functioning.
- [ ] Changes adhere to the existing CSS styling and CRT aesthetic.
- [ ] The code is well-commented for significant logic changes.

