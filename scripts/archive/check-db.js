const http = require('http');

// 调用API获取配置数据来验证中文
const options = {
    hostname: 'localhost',
    port: 8080,
    path: '/captchaImage',
    method: 'GET'
};

const req = http.request(options, (res) => {
    let data = '';
    res.on('data', (chunk) => {
        data += chunk;
    });
    
    res.on('end', () => {
        try {
            const json = JSON.parse(data);
            console.log('API返回的msg字段:', json.msg);
            console.log('\n如果上面显示中文，说明数据库中的中文数据是正确的。');
            console.log('如果上面显示乱码，说明数据库存储有问题。');
        } catch (e) {
            console.error('JSON解析失败');
        }
    });
});

req.on('error', (e) => {
    console.error('请求失败:', e.message);
    console.log('\n请确保后端服务正在运行：');
    console.log('cd d:\\RpoJec\\RuoYi-Vue\\ruoyi-admin');
    console.log('mvn spring-boot:run');
});

req.end();