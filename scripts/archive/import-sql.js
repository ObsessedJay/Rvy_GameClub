const { spawn } = require('child_process');
const fs = require('fs');

console.log('开始导入SQL文件...');

// 创建MySQL进程
const mysql = spawn('mysql', ['-h', '127.0.0.1', '-u', 'root', '-p123123', '--default-character-set=utf8mb4', 'ry_vue']);

// 读取SQL文件并通过stdin传递
const stream = fs.createReadStream('d:\\RpoJec\\RuoYi-Vue\\sql\\ry_20260417.sql', { encoding: 'utf8' });
stream.pipe(mysql.stdin);

mysql.stdout.on('data', (data) => {
    console.log('输出:', data.toString());
});

mysql.stderr.on('data', (data) => {
    // 只显示错误，不是警告
    const text = data.toString();
    if (text.includes('ERROR')) {
        console.error('错误:', text);
    }
});

mysql.on('close', (code) => {
    if (code !== 0) {
        console.error('SQL导入失败，退出码:', code);
        return;
    }
    console.log('\n✅ SQL导入完成！');
});