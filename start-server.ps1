# 简单的HTTP服务器脚本
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add('http://localhost:8080/')
$listener.Start()
Write-Host '服务器已启动: http://localhost:8080'

while ($listener.IsListening) {
    $context = $listener.GetContext()
    $request = $context.Request
    $response = $context.Response
    
    # 处理请求路径
    $filePath = [System.IO.Path]::Combine($PSScriptRoot, $request.Url.LocalPath.TrimStart('/'))
    
    # 如果路径为空或指向目录，默认使用index.html
    if ([string]::IsNullOrEmpty($filePath) -or (Test-Path $filePath -PathType Container)) {
        $filePath = [System.IO.Path]::Combine($PSScriptRoot, 'index.html')
    }
    
    try {
        if (Test-Path $filePath -PathType Leaf) {
            # 根据文件类型设置Content-Type
            $extension = [System.IO.Path]::GetExtension($filePath).ToLower()
            switch ($extension) {
                '.html' { $contentType = 'text/html' }
                '.css' { $contentType = 'text/css' }
                '.js' { $contentType = 'text/javascript' }
                '.jpg' { $contentType = 'image/jpeg' }
                '.jpeg' { $contentType = 'image/jpeg' }
                '.png' { $contentType = 'image/png' }
                default { $contentType = 'application/octet-stream' }
            }
            
            $response.ContentType = $contentType
            
            if ($contentType -like 'image/*') {
                # 二进制文件
                $content = [System.IO.File]::ReadAllBytes($filePath)
                $response.ContentLength64 = $content.Length
                $response.OutputStream.Write($content, 0, $content.Length)
            } else {
                # 文本文件
                $content = Get-Content $filePath -Raw
                $buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
                $response.ContentLength64 = $buffer.Length
                $response.OutputStream.Write($buffer, 0, $buffer.Length)
            }
        } else {
            # 文件不存在
            $response.StatusCode = 404
            $content = '404 Not Found'
            $buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
            $response.ContentLength64 = $buffer.Length
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
        }
    } catch {
        # 处理错误
        $response.StatusCode = 500
        $content = 'Internal Server Error: ' + $_.Exception.Message
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
        $response.ContentLength64 = $buffer.Length
        $response.OutputStream.Write($buffer, 0, $buffer.Length)
    } finally {
        $response.Close()
    }
}

# 停止服务器
$listener.Stop()
$listener.Close()
Write-Host '服务器已停止'