const { spawn } = require('child_process');
const fs = require('fs');

// 步骤1: 删除并重建数据库
const createDb = spawn('mysql', ['-h', '127.0.0.1', '-u', 'root', '-p123123', '--default-character-set=utf8mb4', '-e', 'DROP DATABASE IF EXISTS ry_vue; CREATE DATABASE ry_vue CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;']);

createDb.on('close', (code) => {
    if (code !== 0) {
        console.error('创建数据库失败，退出码:', code);
        return;
    }
    console.log('数据库创建成功');
    
    // 步骤2: 导入SQL文件
    const mysql = spawn('mysql', ['-h', '127.0.0.1', '-u', 'root', '-p123123', '--default-character-set=utf8mb4', 'ry_vue']);
    
    // 读取SQL文件并通过stdin传递
    const stream = fs.createReadStream('d:\\RpoJec\\RuoYi-Vue\\sql\\ry_20260417.sql', { encoding: 'utf8' });
    stream.pipe(mysql.stdin);
    
    mysql.stdout.on('data', (data) => {
        console.log('stdout:', data.toString());
    });
    
    mysql.stderr.on('data', (data) => {
        console.error('stderr:', data.toString());
    });
    
    mysql.on('close', (code) => {
        if (code !== 0) {
            console.error('导入失败，退出码:', code);
            return;
        }
        console.log('SQL导入成功');
        
        // 步骤3: 验证中文数据
        const verify = spawn('mysql', ['-h', '127.0.0.1', '-u', 'root', '-p123123', '--default-character-set=utf8mb4', 'ry_vue', '-e', 'SELECT config_name FROM sys_config LIMIT 1;']);
        
        verify.stdout.on('data', (data) => {
            console.log('验证结果:');
            console.log(data.toString());
        });
        
        verify.stderr.on('data', (data) => {
            console.error('验证错误:', data.toString());
        });
        
        verify.on('close', (code) => {
            if (code !== 0) {
                console.error('验证失败，退出码:', code);
            }
        });
    });
});