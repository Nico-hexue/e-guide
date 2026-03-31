# Simple HTTP Server Script
$port = 8080
$url = "http://localhost:$port/"

Write-Host "Starting HTTP Server..."
Write-Host "Access URL: $url"
Write-Host "Press Ctrl+C to stop the server"

# Create HTTP listener
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($url)
$listener.Start()

try {
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response
        
        # Get requested file path
        $filePath = $request.Url.LocalPath
        if ($filePath -eq "/") {
            $filePath = "/index.html"
        }
        
        # Build full file path
        $fullPath = Join-Path $PWD $filePath.TrimStart('/')
        
        if (Test-Path $fullPath -PathType Leaf) {
            # Read file content
            $content = [System.IO.File]::ReadAllBytes($fullPath)
            
            # Set response headers
            $response.ContentLength64 = $content.Length
            
            # Set Content-Type based on file extension
            $extension = [System.IO.Path]::GetExtension($fullPath).ToLower()
            switch ($extension) {
                ".html" { $response.ContentType = "text/html; charset=utf-8" }
                ".css" { $response.ContentType = "text/css; charset=utf-8" }
                ".js" { $response.ContentType = "application/javascript; charset=utf-8" }
                ".json" { $response.ContentType = "application/json; charset=utf-8" }
                ".png" { $response.ContentType = "image/png" }
                ".jpg" { $response.ContentType = "image/jpeg" }
                ".jpeg" { $response.ContentType = "image/jpeg" }
                ".gif" { $response.ContentType = "image/gif" }
                default { $response.ContentType = "text/plain; charset=utf-8" }
            }
            
            # Write response content
            $response.OutputStream.Write($content, 0, $content.Length)
            Write-Host "[$((Get-Date).ToString('HH:mm:ss'))] 200 $filePath"
        } else {
            # File not found
            $response.StatusCode = 404
            $notFound = [System.Text.Encoding]::UTF8.GetBytes("404 - File Not Found: $filePath")
            $response.ContentLength64 = $notFound.Length
            $response.OutputStream.Write($notFound, 0, $notFound.Length)
            Write-Host "[$((Get-Date).ToString('HH:mm:ss'))] 404 $filePath"
        }
        
        $response.Close()
    }
} finally {
    $listener.Stop()
    $listener.Close()
    Write-Host "Server stopped"
}