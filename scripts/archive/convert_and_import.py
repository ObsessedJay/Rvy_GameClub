import subprocess
import codecs

# 读取GBK编码的SQL文件
with codecs.open(r'd:\RpoJec\RuoYi-Vue\sql\ry_20260417.sql', 'r', 'gbk') as f:
    content = f.read()

# 写入UTF-8编码的文件
with codecs.open(r'd:\RpoJec\RuoYi-Vue\sql\ry_utf8.sql', 'w', 'utf-8') as f:
    f.write(content)

print("文件编码转换完成")

# 使用mysql命令导入UTF-8文件
cmd = [
    'mysql',
    '-h', '127.0.0.1',
    '-u', 'root',
    '-p123123',
    '--default-character-set=utf8mb4',
    'ry_vue',
    '-e', 'source d:\\RpoJec\\RuoYi-Vue\\sql\\ry_utf8.sql'
]

result = subprocess.run(cmd, capture_output=True, text=True)
print("STDOUT:", result.stdout)
print("STDERR:", result.stderr)
print("Return code:", result.returncode)