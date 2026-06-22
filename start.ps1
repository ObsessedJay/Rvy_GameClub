# ============================================
# GameClub 一键启动脚本（前后端）
# ============================================
$projectDir = "e:\工程实践\Project_GameClub"

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  GameClub 一键启动" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan

# 1. 检查并启动 Redis
$redisPort = 6379
$checkRedis = netstat -ano | Select-String ":$redisPort "
if ($checkRedis) {
    Write-Host "[Redis] 端口 6379 已被占用，跳过启动" -ForegroundColor Gray
} else {
    $redisPath = "D:\Redis\redis-server.exe"
    $redisConf = "D:\Redis\redis.windows.conf"
    if (Test-Path $redisPath) {
        Write-Host "[1/3] 正在启动 Redis..." -ForegroundColor Green
        Start-Process -FilePath $redisPath -ArgumentList $redisConf -WindowStyle Hidden
        Write-Host "  Redis 已启动（端口 6379）" -ForegroundColor Gray
        Start-Sleep -Seconds 2
    } else {
        Write-Host "[警告] Redis 未安装，图形验证码可能无法使用" -ForegroundColor Yellow
    }
}

# 2. 检查后端端口是否已被占用
$backendPort = 8080
$checkBackend = netstat -ano | Select-String ":$backendPort "
if ($checkBackend) {
    Write-Host "[警告] 端口 $backendPort 已被占用，尝试先关闭..." -ForegroundColor Yellow
    $pid = ($checkBackend[0] -split "\s+")[-1]
    taskkill /F /PID $pid 2>$null
    Start-Sleep -Seconds 2
}

# 3. 检查前端端口是否已被占用
$frontendPort = 80
$checkFrontend = netstat -ano | Select-String ":$frontendPort "
if ($checkFrontend) {
    Write-Host "[警告] 端口 $frontendPort 已被占用，尝试先关闭..." -ForegroundColor Yellow
    $pid = ($checkFrontend[0] -split "\s+")[-1]
    taskkill /F /PID $pid 2>$null
    Start-Sleep -Seconds 2
}

# 4. 启动后端（新窗口）
Write-Host "`n[2/3] 正在启动后端服务..." -ForegroundColor Green
Start-Process powershell -ArgumentList @(
    "-NoExit",
    "-Command",
    "`$env:JAVA_HOME = 'D:\JDK'; Write-Host 'JAVA_HOME =' `$env:JAVA_HOME -ForegroundColor Gray; Write-Host 'GameClub 后端服务启动中...' -ForegroundColor Cyan; java -jar '$projectDir\ruoyi-admin\target\ruoyi-admin.jar'"
)
Write-Host "  后端已在独立窗口启动（端口 8080）" -ForegroundColor Gray

# 5. 等待后端初步启动
Write-Host "  等待后端初始化（20秒）..." -ForegroundColor Gray
Start-Sleep -Seconds 20

# 6. 启动前端（新窗口）
Write-Host "`n[3/3] 正在启动前端服务..." -ForegroundColor Green
Start-Process powershell -ArgumentList @(
    "-NoExit",
    "-Command",
    "Write-Host 'GameClub 前端服务启动中...' -ForegroundColor Cyan; cd '$projectDir\ruoyi-ui'; npm run dev"
)
Write-Host "  前端已在独立窗口启动（端口 80）" -ForegroundColor Gray

# 7. 等待前端启动
Start-Sleep -Seconds 5

Write-Host "`n======================================" -ForegroundColor Cyan
Write-Host "  启动完成！" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  前端地址: http://localhost:80/" -ForegroundColor White
Write-Host "  后端地址: http://localhost:8080/" -ForegroundColor White
Write-Host "  登录账号: admin" -ForegroundColor White
Write-Host "  登录密码: admin123" -ForegroundColor White
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "`n按任意键退出本窗口（不会关闭后端/前端窗口）..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
