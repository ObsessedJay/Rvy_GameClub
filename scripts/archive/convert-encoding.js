const fs = require('fs');

// 读取GBK编码的文件并转换为UTF-8
const gbkContent = fs.readFileSync('d:\\RpoJec\\RuoYi-Vue\\sql\\ry_20260417.sql', 'binary');

// 尝试用iconv-lite转换（如果可用）
try {
    const iconv = require('iconv-lite');
    const utf8Content = iconv.decode(Buffer.from(gbkContent, 'binary'), 'gbk');
    fs.writeFileSync('d:\\RpoJec\\RuoYi-Vue\\sql\\ry_utf8.sql', utf8Content, 'utf8');
    console.log('转换成功');
} catch (e) {
    // 如果没有iconv-lite，尝试其他方法
    console.log('iconv-lite not available, trying direct write');
    fs.writeFileSync('d:\\RpoJec\\RuoYi-Vue\\sql\\ry_utf8.sql', gbkContent, 'binary');
}