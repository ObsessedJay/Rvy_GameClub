const { spawn } = require('child_process');
const fs = require('fs');

console.log('=== 开始添加GameClub菜单 ===\n');

const mysql = spawn('mysql', ['-h', '127.0.0.1', '-u', 'root', '-p123123', '--default-character-set=utf8mb4', 'ry_vue']);

const stream = fs.createReadStream('d:\\RpoJec\\RuoYi-Vue\\GameClub\\sql\\gameclub_menu.sql', { encoding: 'utf8' });
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
        console.error('\n❌ 菜单添加失败，退出码:', code);
        return;
    }
    console.log('\n✅ GameClub菜单添加完成！');
    
    // 验证菜单
    console.log('\n=== 验证菜单 ===');
    const verifyMysql = spawn('mysql', ['-h', '127.0.0.1', '-u', 'root', '-p123123', '--default-character-set=utf8mb4', '-e', 
        'SELECT menu_id, menu_name, parent_id, path, perms FROM sys_menu WHERE menu_name LIKE "%GameClub%" OR menu_name IN ("游戏分区", "工会管理", "任务管理", "消息中心")', 'ry_vue']);
    
    verifyMysql.stdout.on('data', (data) => {
        console.log(data.toString());
    });
});