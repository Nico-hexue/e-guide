# 简单的HTTP服务器
$port = 8080
$root = $PSScriptRoot

Write-Host "启动HTTP服务器在 http://localhost:$port"
Write-Host "根目录: $root"

try {
    # 创建HTTP监听器
    $listener = [System.Net.HttpListener]::new()
    $listener.Prefixes.Add("http://localhost:$port/")
    $listener.Start()
    
    while ($listener.IsListening) {
        # 等待请求
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response
        
        # 获取请求路径
        $path = $request.Url.LocalPath
        if ($path -eq "/") {
            $path = "/index.html"
        }
        
        # 构建文件路径
        $filePath = Join-Path $root $path.TrimStart("/")
        
        # 处理请求
        if (Test-Path $filePath -PathType Leaf) {
            # 文件存在
            $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
            
            # 设置Content-Type
            switch ($ext) {
                ".html" { $contentType = "text/html" }
                ".css" { $contentType = "text/css" }
                ".js" { $contentType = "text/javascript" }
                ".jpg" { $contentType = "image/jpeg" }
                ".jpeg" { $contentType = "image/jpeg" }
                ".png" { $contentType = "image/png" }
                default { $contentType = "application/octet-stream" }
            }
            
            $response.ContentType = $contentType
            
            try {
                if ($contentType -like "image/*") {
                    # 二进制文件
                    $bytes = [System.IO.File]::ReadAllBytes($filePath)
                    $response.ContentLength64 = $bytes.Length
                    $response.OutputStream.Write($bytes, 0, $bytes.Length)
                } else {
                    # 文本文件
                    $content = Get-Content $filePath -Raw -Encoding UTF8
                    $bytes = [System.Text.Encoding]::UTF8.GetBytes($content)
                    $response.ContentLength64 = $bytes.Length
                    $response.OutputStream.Write($bytes, 0, $bytes.Length)
                }
            } catch {
                Write-Host "读取文件错误: $filePath"
                $response.StatusCode = 500
                $content = "Internal Server Error"
                $bytes = [System.Text.Encoding]::UTF8.GetBytes($content)
                $response.ContentLength64 = $bytes.Length
                $response.OutputStream.Write($bytes, 0, $bytes.Length)
            }
        } else {
            # 文件不存在
            $response.StatusCode = 404
            $content = "404 Not Found"
            $bytes = [System.Text.Encoding]::UTF8.GetBytes($content)
            $response.ContentLength64 = $bytes.Length
            $response.OutputStream.Write($bytes, 0, $bytes.Length)
        }
        
        # 关闭响应
        $response.Close()
    }
} catch {
    Write-Host "服务器错误: $($_.Exception.Message)"
} finally {
    if ($listener) {
        $listener.Stop()
        $listener.Close()
        Write-Host "服务器已停止"
    }
}

Write-Host "按任意键退出..."
$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null