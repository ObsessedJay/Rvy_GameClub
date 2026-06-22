-- ============================================
-- GameClub 游戏工会管理平台 - 数据库表结构
-- 创建时间: 2026-06-07
-- ============================================

-- ----------------------------------------
-- 1. 游戏分区表 (game_partition)
-- ----------------------------------------
DROP TABLE IF EXISTS game_partition;
CREATE TABLE game_partition (
    id              BIGINT           NOT NULL    AUTO_INCREMENT  COMMENT '分区ID',
    game_name       VARCHAR(50)      NOT NULL                    COMMENT '游戏名称',
    game_code       VARCHAR(20)      NOT NULL                    COMMENT '游戏编码（唯一）',
    icon            VARCHAR(200)     DEFAULT NULL                 COMMENT '游戏图标URL',
    description     VARCHAR(500)     DEFAULT NULL                 COMMENT '游戏简介',
    sort_order      INT              DEFAULT 0                   COMMENT '排序',
    status          TINYINT          DEFAULT 1                   COMMENT '状态：0-禁用 1-正常',
    created_at      DATETIME         DEFAULT CURRENT_TIMESTAMP   COMMENT '创建时间',
    updated_at      DATETIME         DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    UNIQUE KEY uk_game_code (game_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='游戏分区表';

-- ----------------------------------------
-- 2. 工会表 (guild)
-- ----------------------------------------
DROP TABLE IF EXISTS guild;
CREATE TABLE guild (
    id                  BIGINT           NOT NULL    AUTO_INCREMENT  COMMENT '工会ID',
    game_partition_id   BIGINT           NOT NULL                    COMMENT '所属游戏分区',
    name                VARCHAR(50)      NOT NULL                    COMMENT '工会名称',
    description         VARCHAR(1000)    DEFAULT NULL                 COMMENT '工会简介',
    recruit_requirement VARCHAR(500)     DEFAULT NULL                 COMMENT '招募要求',
    online_time         VARCHAR(200)     DEFAULT NULL                 COMMENT '常驻在线时段',
    avatar              VARCHAR(200)     DEFAULT NULL                 COMMENT '工会头像URL',
    banner              VARCHAR(200)     DEFAULT NULL                 COMMENT '宣传图URL',
    president_id        BIGINT           DEFAULT NULL                 COMMENT '会长用户ID',
    member_count        INT              DEFAULT 0                   COMMENT '成员数量',
    status              TINYINT          DEFAULT 1                   COMMENT '状态：0-解散 1-正常',
    deleted_at          DATETIME         DEFAULT NULL                 COMMENT '删除时间（软删除）',
    archive_until       DATETIME         DEFAULT NULL                 COMMENT '归档到期时间',
    created_at          DATETIME         DEFAULT CURRENT_TIMESTAMP   COMMENT '创建时间',
    updated_at          DATETIME         DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    UNIQUE KEY uk_partition_name (game_partition_id, name),
    KEY idx_game_partition (game_partition_id),
    KEY idx_president (president_id),
    CONSTRAINT fk_guild_partition FOREIGN KEY (game_partition_id) REFERENCES game_partition(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工会表';

-- ----------------------------------------
-- 3. 工会成员表 (guild_member)
-- ----------------------------------------
DROP TABLE IF EXISTS guild_member;
CREATE TABLE guild_member (
    id                  BIGINT           NOT NULL    AUTO_INCREMENT  COMMENT '记录ID',
    guild_id            BIGINT           NOT NULL                    COMMENT '工会ID',
    game_partition_id   BIGINT           NOT NULL                    COMMENT '游戏分区ID（冗余，用于隔离）',
    user_id             BIGINT           NOT NULL                    COMMENT '用户ID',
    role                TINYINT          NOT NULL                   COMMENT '角色：1-会长 2-管理员 3-普通成员',
    join_time           DATETIME         DEFAULT NULL                 COMMENT '入会时间',
    status              TINYINT          DEFAULT 1                   COMMENT '状态：0-已退出 1-正常',
    created_at          DATETIME         DEFAULT CURRENT_TIMESTAMP   COMMENT '创建时间',
    updated_at          DATETIME         DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    UNIQUE KEY uk_partition_user (game_partition_id, user_id),
    KEY idx_guild (guild_id),
    KEY idx_user (user_id),
    CONSTRAINT fk_member_guild FOREIGN KEY (guild_id) REFERENCES guild(id),
    CONSTRAINT fk_member_user FOREIGN KEY (user_id) REFERENCES sys_user(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工会成员表';

-- ----------------------------------------
-- 4. 入会申请表 (guild_application)
-- ----------------------------------------
DROP TABLE IF EXISTS guild_application;
CREATE TABLE guild_application (
    id                  BIGINT           NOT NULL    AUTO_INCREMENT  COMMENT '申请ID',
    guild_id            BIGINT           NOT NULL                    COMMENT '工会ID',
    game_partition_id   BIGINT           NOT NULL                    COMMENT '游戏分区ID',
    user_id             BIGINT           NOT NULL                    COMMENT '申请人ID',
    message             VARCHAR(500)     DEFAULT NULL                 COMMENT '申请留言',
    status              TINYINT          DEFAULT 0                   COMMENT '状态：0-待审核 1-已通过 2-已拒绝 3-已过期',
    reject_reason       VARCHAR(500)     DEFAULT NULL                 COMMENT '拒绝理由',
    reviewer_id          BIGINT           DEFAULT NULL                 COMMENT '审核人ID',
    review_time         DATETIME         DEFAULT NULL                 COMMENT '审核时间',
    expire_time         DATETIME         DEFAULT NULL                 COMMENT '过期时间',
    created_at          DATETIME         DEFAULT CURRENT_TIMESTAMP   COMMENT '申请时间',
    PRIMARY KEY (id),
    KEY idx_guild (guild_id),
    KEY idx_user (user_id),
    KEY idx_status (status),
    CONSTRAINT fk_application_guild FOREIGN KEY (guild_id) REFERENCES guild(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='入会申请表';

-- ----------------------------------------
-- 5. 黑名单表 (guild_blacklist)
-- ----------------------------------------
DROP TABLE IF EXISTS guild_blacklist;
CREATE TABLE guild_blacklist (
    id                  BIGINT           NOT NULL    AUTO_INCREMENT  COMMENT '记录ID',
    guild_id            BIGINT           NOT NULL                    COMMENT '工会ID',
    game_partition_id   BIGINT           NOT NULL                    COMMENT '游戏分区ID',
    user_id             BIGINT           NOT NULL                    COMMENT '被拉黑用户ID',
    reason              VARCHAR(500)     DEFAULT NULL                 COMMENT '拉黑原因',
    operator_id         BIGINT           NOT NULL                    COMMENT '操作人ID',
    created_at          DATETIME         DEFAULT CURRENT_TIMESTAMP   COMMENT '拉黑时间',
    PRIMARY KEY (id),
    UNIQUE KEY uk_guild_user (guild_id, user_id),
    KEY idx_user (user_id),
    CONSTRAINT fk_blacklist_guild FOREIGN KEY (guild_id) REFERENCES guild(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='黑名单表';

-- ----------------------------------------
-- 6. 工会任务表 (guild_task)
-- ----------------------------------------
DROP TABLE IF EXISTS guild_task;
CREATE TABLE guild_task (
    id                  BIGINT           NOT NULL    AUTO_INCREMENT  COMMENT '任务ID',
    guild_id            BIGINT           NOT NULL                    COMMENT '工会ID',
    game_partition_id   BIGINT           NOT NULL                    COMMENT '游戏分区ID',
    publisher_id        BIGINT           NOT NULL                    COMMENT '发布人ID',
    name                VARCHAR(100)     NOT NULL                    COMMENT '任务名称',
    type                TINYINT          DEFAULT 1                   COMMENT '任务类型：1-日常打卡 2-副本组队 3-活动任务 4-竞技任务',
    description         TEXT             DEFAULT NULL                 COMMENT '任务详情',
    image               VARCHAR(200)     DEFAULT NULL                 COMMENT '配图URL',
    task_mode           TINYINT          DEFAULT 1                   COMMENT '任务模式：1-单人 2-多人',
    min_players         INT              DEFAULT 1                   COMMENT '人数下限',
    max_players         INT              DEFAULT 1                   COMMENT '人数上限',
    start_time          DATETIME         DEFAULT NULL                 COMMENT '开始时间',
    end_time            DATETIME         DEFAULT NULL                 COMMENT '截止时间',
    status              TINYINT          DEFAULT 1                   COMMENT '状态：1-未开始 2-进行中 3-已满员 4-已结束 5-已作废 6-已关闭 7-已完成',
    current_players     INT              DEFAULT 0                   COMMENT '当前参与人数',
    version             INT              DEFAULT 0                   COMMENT '乐观锁版本号',
    created_at          DATETIME         DEFAULT CURRENT_TIMESTAMP   COMMENT '创建时间',
    updated_at          DATETIME         DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    KEY idx_guild (guild_id),
    KEY idx_publisher (publisher_id),
    KEY idx_status (status),
    KEY idx_end_time (end_time),
    CONSTRAINT fk_task_guild FOREIGN KEY (guild_id) REFERENCES guild(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工会任务表';

-- ----------------------------------------
-- 7. 任务参与表 (task_participant)
-- ----------------------------------------
DROP TABLE IF EXISTS task_participant;
CREATE TABLE task_participant (
    id                  BIGINT           NOT NULL    AUTO_INCREMENT  COMMENT '记录ID',
    task_id             BIGINT           NOT NULL                    COMMENT '任务ID',
    user_id             BIGINT           NOT NULL                    COMMENT '参与用户ID',
    status              TINYINT          DEFAULT 1                   COMMENT '状态：1-已接单 2-已放弃 3-已完成',
    join_time           DATETIME         DEFAULT CURRENT_TIMESTAMP   COMMENT '接单时间',
    created_at          DATETIME         DEFAULT CURRENT_TIMESTAMP   COMMENT '创建时间',
    PRIMARY KEY (id),
    UNIQUE KEY uk_task_user (task_id, user_id),
    KEY idx_user (user_id),
    CONSTRAINT fk_participant_task FOREIGN KEY (task_id) REFERENCES guild_task(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='任务参与表';

-- ----------------------------------------
-- 8. 用户消息表 (user_notification)
-- ----------------------------------------
DROP TABLE IF EXISTS user_notification;
CREATE TABLE user_notification (
    id                  BIGINT           NOT NULL    AUTO_INCREMENT  COMMENT '消息ID',
    user_id             BIGINT           NOT NULL                    COMMENT '接收用户ID',
    game_partition_id   BIGINT           DEFAULT NULL                 COMMENT '所属游戏分区ID',
    guild_id            BIGINT           DEFAULT NULL                 COMMENT '所属工会ID',
    type                TINYINT          NOT NULL                   COMMENT '消息类型：1-入会申请结果 2-任务状态变更 3-身份任免 4-被踢通知 5-拉黑通知 6-系统通知',
    title               VARCHAR(100)     NOT NULL                    COMMENT '消息标题',
    content             VARCHAR(500)     DEFAULT NULL                 COMMENT '消息内容',
    is_read             TINYINT          DEFAULT 0                   COMMENT '是否已读：0-未读 1-已读',
    related_id          BIGINT           DEFAULT NULL                 COMMENT '关联ID（如申请ID、任务ID等）',
    created_at          DATETIME         DEFAULT CURRENT_TIMESTAMP   COMMENT '创建时间',
    PRIMARY KEY (id),
    KEY idx_user (user_id),
    KEY idx_is_read (is_read),
    KEY idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户消息表';

-- ----------------------------------------
-- 9. 申请冷却记录表 (application_cooldown)
-- ----------------------------------------
DROP TABLE IF EXISTS application_cooldown;
CREATE TABLE application_cooldown (
    id                  BIGINT           NOT NULL    AUTO_INCREMENT  COMMENT '记录ID',
    guild_id            BIGINT           NOT NULL                    COMMENT '工会ID',
    user_id             BIGINT           NOT NULL                    COMMENT '用户ID',
    reject_count        INT              DEFAULT 0                   COMMENT '24小时内被拒绝次数',
    cooldown_end_time   DATETIME         DEFAULT NULL                 COMMENT '冷却结束时间',
    last_reject_time   DATETIME         DEFAULT NULL                 COMMENT '最后一次被拒绝时间',
    created_at          DATETIME         DEFAULT CURRENT_TIMESTAMP   COMMENT '创建时间',
    updated_at          DATETIME         DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    UNIQUE KEY uk_guild_user (guild_id, user_id),
    KEY idx_cooldown_end (cooldown_end_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='申请冷却记录表';

-- ----------------------------------------
-- 10. 操作日志表 (guild_operation_log)
-- ----------------------------------------
DROP TABLE IF EXISTS guild_operation_log;
CREATE TABLE guild_operation_log (
    id                  BIGINT           NOT NULL    AUTO_INCREMENT  COMMENT '日志ID',
    game_partition_id   BIGINT           DEFAULT NULL                 COMMENT '游戏分区ID',
    guild_id            BIGINT           DEFAULT NULL                 COMMENT '工会ID',
    operator_id         BIGINT           NOT NULL                    COMMENT '操作人ID',
    operator_role      TINYINT          DEFAULT NULL                 COMMENT '操作人角色：1-会长 2-管理员 3-普通成员',
    operation_type      VARCHAR(50)      NOT NULL                    COMMENT '操作类型',
    operation_desc      VARCHAR(500)     DEFAULT NULL                 COMMENT '操作描述',
    old_value           TEXT             DEFAULT NULL                 COMMENT '修改前数据',
    new_value           TEXT             DEFAULT NULL                 COMMENT '修改后数据',
    ip_address          VARCHAR(50)      DEFAULT NULL                 COMMENT 'IP地址',
    created_at          DATETIME         DEFAULT CURRENT_TIMESTAMP   COMMENT '操作时间',
    PRIMARY KEY (id),
    KEY idx_guild (guild_id),
    KEY idx_operator (operator_id),
    KEY idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工会操作日志表';

-- ----------------------------------------
-- 11. 工会公告表 (guild_announcement)
-- ----------------------------------------
DROP TABLE IF EXISTS guild_announcement;
CREATE TABLE guild_announcement (
    id                  BIGINT           NOT NULL    AUTO_INCREMENT  COMMENT '公告ID',
    guild_id            BIGINT           NOT NULL                    COMMENT '工会ID',
    game_partition_id   BIGINT           NOT NULL                    COMMENT '游戏分区ID',
    title               VARCHAR(100)     NOT NULL                    COMMENT '公告标题',
    content             TEXT             NOT NULL                    COMMENT '公告内容',
    is_top              TINYINT          DEFAULT 0                   COMMENT '是否置顶：0-否 1-是',
    publisher_id        BIGINT           NOT NULL                    COMMENT '发布人ID',
    created_at          DATETIME         DEFAULT CURRENT_TIMESTAMP   COMMENT '创建时间',
    updated_at          DATETIME         DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    KEY idx_guild (guild_id),
    KEY idx_created (created_at),
    CONSTRAINT fk_announcement_guild FOREIGN KEY (guild_id) REFERENCES guild(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工会公告表';

-- ----------------------------------------
-- 初始化数据：示例游戏分区
-- ----------------------------------------
INSERT INTO game_partition (game_name, game_code, icon, description, sort_order, status) VALUES
('英雄联盟', 'lol', '/images/games/lol.png', 'League of Legends - 全球最受欢迎的MOBA游戏', 1, 1),
('魔兽世界', 'wow', '/images/games/wow.png', 'World of Warcraft - 经典MMORPG', 2, 1),
('DOTA2', 'dota2', '/images/games/dota2.png', 'Dota 2 - 硬核MOBA竞技游戏', 3, 1),
('CSGO', 'csgo', '/images/games/csgo.png', 'Counter-Strike: Global Offensive - 经典射击游戏', 4, 1),
('原神', 'genshin', '/images/games/genshin.png', 'Genshin Impact - 开放世界冒险游戏', 5, 1);

-- ============================================
-- 表创建完成！
-- ============================================
