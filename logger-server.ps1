# Simple HTTP Server to log poems from the Rhyming Clock
$port = 8088
$logFile = Join-Path $PSScriptRoot "rhyming-clock-log.txt"

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")
try {
    $listener.Start()
    Write-Host "--- Rhyming Clock Logger Started ---" -ForegroundColor Cyan
    Write-Host "Listening on http://localhost:$port/"
    Write-Host "Current log file: $logFile"
    Write-Host "Keep this window open to continue logging.`n"
} catch {
    Write-Host "ERROR: Could not start listener. Is port $port already in use?" -ForegroundColor Red
    exit
}

while ($listener.IsListening) {
    try {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response

        # Add CORS headers so the browser allows the request
        $response.Headers.Add("Access-Control-Allow-Origin", "*")
        $response.Headers.Add("Access-Control-Allow-Methods", "POST, OPTIONS")
        $response.Headers.Add("Access-Control-Allow-Headers", "Content-Type")

        if ($request.HttpMethod -eq "OPTIONS") {
            $response.StatusCode = 200
            $response.Close()
            continue
        }

        if ($request.HttpMethod -eq "POST") {
            $reader = New-Object System.IO.StreamReader($request.InputStream)
            $body = $reader.ReadToEnd()
            
            # Append to log file
            Add-Content -Path $logFile -Value $body -Encoding UTF8
            
            Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Log Received and Saved." -ForegroundColor Green
            
            $buffer = [System.Text.Encoding]::UTF8.GetBytes("OK")
            $response.ContentLength64 = $buffer.Length
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
        }

        $response.Close()
    } catch {
        Write-Host "Error handling request: $_" -ForegroundColor Yellow
    }
}
