# 一键推送到 Gitee + GitHub
Write-Host "Push to Gitee..." -ForegroundColor Cyan
git push origin master
Write-Host "Push to GitHub..." -ForegroundColor Cyan
git push github master
Write-Host "`nPush completed!" -ForegroundColor Green
