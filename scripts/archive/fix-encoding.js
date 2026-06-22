const fs = require('fs');
const path = require('path');

// 设置模块路径为前端项目的node_modules
const nodeModulesPath = path.join(__dirname, 'ruoyi-ui', 'node_modules');

// 尝试从前端项目导入iconv-lite
try {
    const iconv = require(path.join(nodeModulesPath, 'iconv-lite'));
    
    // 读取原始文件（二进制模式）
    const buffer = fs.readFileSync('d:\\RpoJec\\RuoYi-Vue\\sql\\ry_20260417.sql');
    
    // 尝试用GBK解码
    const gbkContent = iconv.decode(buffer, 'gbk');
    
    // 写入UTF-8文件
    fs.writeFileSync('d:\\RpoJec\\RuoYi-Vue\\sql\\ry_utf8.sql', gbkContent, 'utf8');
    
    console.log('Encoding conversion completed');
    
    // 导入到数据库
    const { exec } = require('child_process');
    const cmd = 'mysql -h 127.0.0.1 -u root -p123123 --default-character-set=utf8mb4 ry_vue -e "source d:\\RpoJec\\RuoYi-Vue\\sql\\ry_utf8.sql"';
    exec(cmd, (error, stdout, stderr) => {
        if (error) {
            console.error(`Error: ${error.message}`);
            return;
        }
        if (stderr) {
            console.error(`stderr: ${stderr}`);
            return;
        }
        console.log('Database import completed');
    });
    
} catch (e) {
    console.error('iconv-lite not found:', e.message);
    // 如果没有iconv-lite，直接写入
    const buffer = fs.readFileSync('d:\\RpoJec\\RuoYi-Vue\\sql\\ry_20260417.sql');
    fs.writeFileSync('d:\\RpoJec\\RuoYi-Vue\\sql\\ry_utf8.sql', buffer);
    console.log('File copied as-is');
}