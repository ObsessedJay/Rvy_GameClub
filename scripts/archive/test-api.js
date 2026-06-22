const http = require('http');

const options = {
    hostname: 'localhost',
    port: 8080,
    path: '/captchaImage',
    method: 'GET',
    headers: {
        'Accept': 'application/json',
        'Accept-Charset': 'UTF-8'
    }
};

const req = http.request(options, (res) => {
    console.log('状态码:', res.statusCode);
    console.log('响应头:', res.headers);
    
    let data = '';
    res.on('data', (chunk) => {
        data += chunk;
    });
    
    res.on('end', () => {
        console.log('\n响应体:');
        console.log(data);
        
        try {
            const json = JSON.parse(data);
            console.log('\n解析后的msg字段:', json.msg);
        } catch (e) {
            console.error('JSON解析失败:', e);
        }
    });
});

req.on('error', (e) => {
    console.error('请求遇到问题:', e);
});

req.end();