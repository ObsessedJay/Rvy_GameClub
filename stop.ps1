# ============================================
# GameClub 一键关闭脚本（前后端）
# ============================================

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  GameClub 一键关闭" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan

# 1. 关闭后端（端口 8080）
$backendPort = 8080
Write-Host "`n[1/3] 正在关闭后端服务（端口 $backendPort）..." -ForegroundColor Yellow
$backendConns = netstat -ano | Select-String ":$backendPort "
if ($backendConns) {
    $killed = @{}
    foreach ($conn in $backendConns) {
        $pid = ($conn -split "\s+")[-1]
        if ($pid -ne "0" -and -not $killed[$pid]) {
            taskkill /F /PID $pid 2>$null
            Write-Host "  已终止进程 PID: $pid" -ForegroundColor Green
            $killed[$pid] = $true
        }
    }
} else {
    Write-Host "  后端端口 $backendPort 未被使用" -ForegroundColor Gray
}

# 2. 关闭前端（端口 80）
$frontendPort = 80
Write-Host "`n[2/3] 正在关闭前端服务（端口 $frontendPort）..." -ForegroundColor Yellow
$frontendConns = netstat -ano | Select-String ":$frontendPort "
if ($frontendConns) {
    $killed = @{}
    foreach ($conn in $frontendConns) {
        $pid = ($conn -split "\s+")[-1]
        if ($pid -ne "0" -and -not $killed[$pid]) {
            taskkill /F /PID $pid 2>$null
            Write-Host "  已终止进程 PID: $pid" -ForegroundColor Green
            $killed[$pid] = $true
        }
    }
} else {
    Write-Host "  前端端口 $frontendPort 未被使用" -ForegroundColor Gray
}

# 3. 关闭 Redis（端口 6379）
$redisPort = 6379
Write-Host "`n[3/3] 正在关闭 Redis（端口 $redisPort）..." -ForegroundColor Yellow
$redisConns = netstat -ano | Select-String ":$redisPort "
if ($redisConns) {
    $killed = @{}
    foreach ($conn in $redisConns) {
        $pid = ($conn -split "\s+")[-1]
        if ($pid -ne "0" -and -not $killed[$pid]) {
            taskkill /F /PID $pid 2>$null
            Write-Host "  已终止进程 PID: $pid" -ForegroundColor Green
            $killed[$pid] = $true
        }
    }
} else {
    Write-Host "  Redis 端口 $redisPort 未被使用" -ForegroundColor Gray
}

Write-Host "`n======================================" -ForegroundColor Cyan
Write-Host "  已关闭所有服务" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "`n按任意键退出..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
