USE ry_vue;

-- ============================================
-- 方案C数据库更新脚本：用户-部门多对多关联
-- 1. 在 guild 表中添加 dept_id 列
-- ============================================
SET @col_exists = (SELECT COUNT(*) FROM information_schema.columns 
    WHERE table_schema = 'ry_vue' AND table_name = 'guild' AND column_name = 'dept_id');
SET @sql = IF(@col_exists = 0, 
    'ALTER TABLE guild ADD COLUMN dept_id BIGINT DEFAULT NULL COMMENT '对应部门ID'',
    'SELECT ''guild.dept_id already exists''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- ============================================
-- 2. 在 game_partition 表中添加 dept_id 列
-- ============================================
SET @col_exists2 = (SELECT COUNT(*) FROM information_schema.columns 
    WHERE table_schema = 'ry_vue' AND table_name = 'game_partition' AND column_name = 'dept_id');
SET @sql2 = IF(@col_exists2 = 0, 
    'ALTER TABLE game_partition ADD COLUMN dept_id BIGINT DEFAULT NULL COMMENT '对应部门ID'',
    'SELECT ''game_partition.dept_id already exists''');
PREPARE stmt2 FROM @sql2;
EXECUTE stmt2;
DEALLOCATE PREPARE stmt2;

-- ============================================
-- 3. 创建 sys_user_dept 表（用户-业务网站部门关联表
-- ============================================
CREATE TABLE IF NOT EXISTS sys_user_dept (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    dept_id BIGINT NOT NULL COMMENT '部门ID',
    website_code VARCHAR(50) NOT NULL COMMENT '业务网站编码（DEFAULT/GAMECLUB/...',
    is_primary TINYINT DEFAULT 0 COMMENT '是否主部门归属 1=是 0=否',
    joined_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '加入时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    UNIQUE KEY uk_user_website (user_id, website_code),
    KEY idx_dept_id (dept_id),
    KEY idx_website_code (website_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户-业务网站部门关联表（方案C多对多）';

-- ============================================
-- 4. 创建 sys_website_config 表（业务网站配置表
-- ============================================
CREATE TABLE IF NOT EXISTS sys_website_config (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    website_code VARCHAR(50) NOT NULL COMMENT '业务网站编码（唯一）',
    website_name VARCHAR(100) NOT NULL COMMENT '业务网站名称',
    root_dept_id BIGINT NOT NULL COMMENT '该网站的顶级部门ID',
    default_dept_id BIGINT NOT NULL COMMENT '新用户默认部门ID',
    status CHAR(1) DEFAULT '0' COMMENT '状态 0=正常 1=停用',
    remark VARCHAR(500) DEFAULT NULL COMMENT '备注',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    UNIQUE KEY uk_website_code (website_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='业务网站配置表（方案C）';

SELECT 'Tables created successfully' AS status;
