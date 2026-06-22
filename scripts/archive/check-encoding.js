const fs = require('fs');

// 读取文件头部字节
const buffer = fs.readFileSync('d:\\RpoJec\\RuoYi-Vue\\sql\\ry_20260417.sql');
const head = buffer.slice(0, 100);

console.log('文件头部十六进制:');
console.log(head.toString('hex').match(/.{1,2}/g).join(' '));

// 检查BOM
if (buffer[0] === 0xEF && buffer[1] === 0xBB && buffer[2] === 0xBF) {
    console.log('\n检测到UTF-8 BOM');
} else if (buffer[0] === 0xFF && buffer[1] === 0xFE) {
    console.log('\n检测到UTF-16 LE BOM');
} else if (buffer[0] === 0xFE && buffer[1] === 0xFF) {
    console.log('\n检测到UTF-16 BE BOM');
} else {
    console.log('\n未检测到BOM');
}

// 尝试不同编码解码
console.log('\n--- 尝试不同编码解码 ---');

// UTF-8
console.log('\nUTF-8:');
console.log(buffer.slice(0, 200).toString('utf8'));

// GBK (使用iconv-lite)
try {
    const iconv = require('./ruoyi-ui/node_modules/iconv-lite');
    console.log('\nGBK:');
    console.log(iconv.decode(buffer.slice(0, 200), 'gbk'));
    
    console.log('\nGB2312:');
    console.log(iconv.decode(buffer.slice(0, 200), 'gb2312'));
} catch (e) {
    console.log('\niconv-lite不可用');
}