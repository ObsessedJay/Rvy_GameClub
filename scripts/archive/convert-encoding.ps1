$sourcePath = "d:\RpoJec\RuoYi-Vue\sql\ry_20260417.sql"
$targetPath = "d:\RpoJec\RuoYi-Vue\sql\ry_utf8.sql"

# 检查文件是否存在
if (-not (Test-Path $sourcePath)) {
    Write-Output "源文件不存在: $sourcePath"
    exit 1
}

# 读取文件
$content = Get-Content $sourcePath -Raw -Encoding Default

# 转换为UTF-8并写入
[System.IO.File]::WriteAllText($targetPath, $content, [System.Text.Encoding]::UTF8)

Write-Output "文件编码转换完成"

# 导入到数据库
$mysqlPath = "mysql"
$args = @(
    "-h", "127.0.0.1",
    "-u", "root",
    "-p123123",
    "--default-character-set=utf8mb4",
    "ry_vue",
    "-e", "source $targetPath"
)

& $mysqlPath $args