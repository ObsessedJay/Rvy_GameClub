const mysql = require('./ruoyi-ui/node_modules/mysql');

// 创建连接
const connection = mysql.createConnection({
    host: '127.0.0.1',
    user: 'root',
    password: '123123',
    database: 'ry_vue',
    charset: 'utf8mb4'
});

// 连接数据库
connection.connect((err) => {
    if (err) {
        console.error('连接失败:', err);
        return;
    }
    console.log('连接成功');
    
    // 查询数据
    connection.query('SELECT config_name, config_value FROM sys_config LIMIT 3', (err, results) => {
        if (err) {
            console.error('查询失败:', err);
            return;
        }
        
        console.log('查询结果:');
        console.log(JSON.stringify(results, null, 2));
        
        // 关闭连接
        connection.end();
    });
});