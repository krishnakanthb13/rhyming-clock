:: 1. Get current folder and convert backslashes to forward slashes
set "APP_PATH=%~dp0rhyming-clock.html"
set "APP_PATH=%APP_PATH:\=/%"

:: 2. Load API Key from .env file
set "API_KEY="
if exist "%~dp0.env" (
    for /f "usebackq tokens=1* delims==" %%A in ("%~dp0.env") do (
        if "%%A"=="GEMINI_API_KEY" set "API_KEY=%%B"
    )
)

:: Append Key to URL if found
if defined API_KEY (
    set "APP_URL=file:///%APP_PATH%?key=%API_KEY%"
) else (
    set "APP_URL=file:///%APP_PATH%"
    echo [WARNING] No API Key found in .env file.
)

:: 3. Configuration
set WIDTH=350
set HEIGHT=200
set MARGIN=30

:: 4. Detect Screen Resolution via a more robust PowerShell method
for /f "delims=" %%a in ('powershell -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width"') do set "SCR_W=%%a"

:: Default to 1920 if detection fails
if "%SCR_W%"=="" set "SCR_W=1920"

:: 5. Calculate Position
set /a POS_X=%SCR_W% - %WIDTH% - %MARGIN%
set POS_Y=%MARGIN%

:: 6. Launch Arguments
:: Optimized for performance and stability
set "ARGS=--app="%APP_URL%" --window-size=%WIDTH%,%HEIGHT% --window-position=%POS_X%,%POS_Y% --user-data-dir="%TEMP%\RhymingClockProfile" --disable-extensions --no-first-run"

:: 6. Launch the Browser
if exist "C:\Program Files\Google\Chrome\Application\chrome.exe" (
    start "" "C:\Program Files\Google\Chrome\Application\chrome.exe" %ARGS%
    exit
)
if exist "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" (
    start "" "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" %ARGS%
    exit
)
if exist "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" (
    start "" "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" %ARGS%
    exit
)

:: Final Fallback
start "" "file:///%APP_PATH%"
exit