const { spawn } = require('child_process');

console.log('=== 测试数据库字符编码 ===\n');

// 查询数据库中的配置数据
const mysql = spawn('mysql', ['-h', '127.0.0.1', '-u', 'root', '-p123123', '--default-character-set=utf8mb4', '-e', 
    'SELECT HEX(config_name) as hex_name, config_name FROM sys_config LIMIT 1', 'ry_vue']);

mysql.stdout.on('data', (data) => {
    const text = data.toString('utf8');
    console.log('=== 原始输出（UTF-8解码） ===');
    console.log(text);
    
    // 尝试其他解码方式
    console.log('\n=== 尝试GBK解码 ===');
    try {
        const gbk = Buffer.from(data).toString('gbk');
        console.log(gbk);
    } catch (e) {
        console.log('GBK解码失败');
    }
});

mysql.stderr.on('data', (data) => {
    console.log('警告:', data.toString());
});

mysql.on('close', (code) => {
    console.log('\n进程退出，退出码:', code);
});