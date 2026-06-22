USE ry_vue;

DROP TABLE IF EXISTS sys_user_dept;
CREATE TABLE sys_user_dept (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    dept_id BIGINT NOT NULL COMMENT '部门ID',
    website_code VARCHAR(50) NOT NULL COMMENT '业务网站编码',
    is_primary TINYINT DEFAULT 0 COMMENT '是否主部门归属 1=是 0=否',
    joined_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '加入时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    UNIQUE KEY uk_user_website (user_id, website_code),
    KEY idx_dept_id (dept_id),
    KEY idx_website_code (website_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户-业务网站部门关联表（方案C多对多）';

DROP TABLE IF EXISTS sys_website_config;
CREATE TABLE sys_website_config (
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

SELECT 'Tables created' AS status;
