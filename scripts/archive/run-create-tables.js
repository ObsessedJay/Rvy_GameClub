const { spawn } = require('child_process');
const fs = require('fs');

console.log('=== 开始创建GameClub数据库表 ===\n');

const mysql = spawn('mysql', ['-h', '127.0.0.1', '-u', 'root', '-p123123', '--default-character-set=utf8mb4', 'ry_vue']);

const stream = fs.createReadStream('d:\\RpoJec\\RuoYi-Vue\\GameClub\\sql\\gameclub_tables.sql', { encoding: 'utf8' });
stream.pipe(mysql.stdin);

mysql.stdout.on('data', (data) => {
    console.log(data.toString());
});

mysql.stderr.on('data', (data) => {
    const text = data.toString();
    if (text.includes('ERROR')) {
        console.error('错误:', text);
    }
});

mysql.on('close', (code) => {
    if (code !== 0) {
        console.error('\n❌ SQL执行失败，退出码:', code);
        process.exit(1);
    }
    console.log('\n✅ GameClub数据库表创建完成！');
    
    // 验证表是否创建成功
    console.log('\n=== 验证创建的表 ===');
    const verifyMysql = spawn('mysql', ['-h', '127.0.0.1', '-u', 'root', '-p123123', '--default-character-set=utf8mb4', '-e', 
        'SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA = "ry_vue" AND TABLE_NAME LIKE "guild_%" OR TABLE_NAME = "game_partition" OR TABLE_NAME LIKE "task_%" OR TABLE_NAME = "user_notification" OR TABLE_NAME = "application_cooldown"', 'ry_vue']);
    
    verifyMysql.stdout.on('data', (data) => {
        console.log(data.toString());
    });
    
    verifyMysql.on('close', () => {
        console.log('\n=== 表创建验证完成 ===');
    });
});