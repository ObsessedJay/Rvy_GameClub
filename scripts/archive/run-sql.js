const { spawn } = require('child_process');
const fs = require('fs');

// 读取SQL文件并通过stdin传递给mysql
const mysql = spawn('mysql', ['-h', '127.0.0.1', '-u', 'root', '-p123123', '--default-character-set=utf8mb4', 'ry_vue']);

const stream = fs.createReadStream('d:\\RpoJec\\RuoYi-Vue\\sql\\new_structure.sql', { encoding: 'utf8' });
stream.pipe(mysql.stdin);

mysql.stdout.on('data', (data) => {
    console.log('输出:', data.toString());
});

mysql.stderr.on('data', (data) => {
    console.error('错误:', data.toString());
});

mysql.on('close', (code) => {
    if (code !== 0) {
        console.error('SQL执行失败，退出码:', code);
        return;
    }
    console.log('\n✅ 新数据结构创建完成！');
});