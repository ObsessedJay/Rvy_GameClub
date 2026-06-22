-- 创建新的部门结构
-- 网站汇总作为主目录

-- 重置自增计数器
ALTER TABLE sys_dept AUTO_INCREMENT = 1;
ALTER TABLE sys_user AUTO_INCREMENT = 1;

-- ================================================
-- 第一层：网站汇总
-- ================================================
INSERT INTO sys_dept (dept_id, parent_id, dept_name, order_num, create_by, create_time) VALUES
(1, 0, '网站汇总', 1, 'system', NOW());

-- ================================================
-- 第二层：网站子目录
-- ================================================
INSERT INTO sys_dept (dept_id, parent_id, dept_name, order_num, create_by, create_time) VALUES
(10, 1, 'GameClub', 1, 'system', NOW()),
(20, 1, 'MusicZone', 2, 'system', NOW()),
(30, 1, 'TechForum', 3, 'system', NOW());

-- ================================================
-- GameClub - 游戏分区
-- ================================================
INSERT INTO sys_dept (dept_id, parent_id, dept_name, order_num, create_by, create_time) VALUES
(100, 10, '英雄联盟分区', 1, 'system', NOW()),
(101, 10, '魔兽世界分区', 2, 'system', NOW()),
(102, 10, 'DOTA2分区', 3, 'system', NOW()),
(103, 10, 'CSGO分区', 4, 'system', NOW()),
(199, 10, '无工会用户区', 99, 'system', NOW());

-- ================================================
-- 英雄联盟分区 - 工会
-- ================================================
INSERT INTO sys_dept (dept_id, parent_id, dept_name, order_num, create_by, create_time) VALUES
(1000, 100, '星辰工会', 1, 'system', NOW()),
(1001, 100, '荣耀工会', 2, 'system', NOW()),
(1002, 100, '烈焰工会', 3, 'system', NOW()),
(1003, 100, '冰霜工会', 4, 'system', NOW());

-- ================================================
-- 魔兽世界分区 - 工会
-- ================================================
INSERT INTO sys_dept (dept_id, parent_id, dept_name, order_num, create_by, create_time) VALUES
(1010, 101, '暗影工会', 1, 'system', NOW()),
(1011, 101, '圣光工会', 2, 'system', NOW()),
(1012, 101, '风暴工会', 3, 'system', NOW());

-- ================================================
-- DOTA2分区 - 工会
-- ================================================
INSERT INTO sys_dept (dept_id, parent_id, dept_name, order_num, create_by, create_time) VALUES
(1020, 102, '传奇工会', 1, 'system', NOW()),
(1021, 102, '神话工会', 2, 'system', NOW());

-- ================================================
-- CSGO分区 - 工会
-- ================================================
INSERT INTO sys_dept (dept_id, parent_id, dept_name, order_num, create_by, create_time) VALUES
(1030, 103, '精英工会', 1, 'system', NOW()),
(1031, 103, '王者工会', 2, 'system', NOW());

-- ================================================
-- 创建用户
-- ================================================

-- 超级管理员
INSERT INTO sys_user (user_id, user_name, nick_name, email, password, status, create_by, create_time) VALUES
(1, 'admin', '系统管理员', 'admin@example.com', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOEa7adp7v50qG6RfXyMqG6RfXyMq', '0', 'system', NOW());

-- GameClub 管理员
INSERT INTO sys_user (user_id, dept_id, user_name, nick_name, email, password, status, create_by, create_time) VALUES
(2, 10, 'game_admin', 'GameClub管理员', 'game@example.com', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOEa7adp7v50qG6RfXyMqG6RfXyMq', '0', 'system', NOW());

-- ================================================
-- 英雄联盟分区用户
-- ================================================

-- 星辰工会
INSERT INTO sys_user (user_id, dept_id, user_name, nick_name, email, password, status, create_by, create_time) VALUES
(10, 1000, 'star_leader', '星辰会长', 'star_leader@example.com', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOEa7adp7v50qG6RfXyMqG6RfXyMq', '0', 'system', NOW()),
(11, 1000, 'star_admin1', '星辰管理员1', 'star_admin1@example.com', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOEa7adp7v50qG6RfXyMqG6RfXyMq', '0', 'system', NOW()),
(12, 1000, 'star_member1', '星辰成员1', 'star_member1@example.com', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOEa7adp7v50qG6RfXyMqG6RfXyMq', '0', 'system', NOW()),
(13, 1000, 'star_member2', '星辰成员2', 'star_member2@example.com', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOEa7adp7v50qG6RfXyMqG6RfXyMq', '0', 'system', NOW());

-- 荣耀工会
INSERT INTO sys_user (user_id, dept_id, user_name, nick_name, email, password, status, create_by, create_time) VALUES
(20, 1001, 'glory_leader', '荣耀会长', 'glory_leader@example.com', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOEa7adp7v50qG6RfXyMqG6RfXyMq', '0', 'system', NOW()),
(21, 1001, 'glory_admin1', '荣耀管理员1', 'glory_admin1@example.com', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOEa7adp7v50qG6RfXyMqG6RfXyMq', '0', 'system', NOW()),
(22, 1001, 'glory_member1', '荣耀成员1', 'glory_member1@example.com', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOEa7adp7v50qG6RfXyMqG6RfXyMq', '0', 'system', NOW());

-- ================================================
-- 魔兽世界分区用户
-- ================================================

-- 暗影工会
INSERT INTO sys_user (user_id, dept_id, user_name, nick_name, email, password, status, create_by, create_time) VALUES
(30, 1010, 'shadow_leader', '暗影会长', 'shadow_leader@example.com', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOEa7adp7v50qG6RfXyMqG6RfXyMq', '0', 'system', NOW()),
(31, 1010, 'shadow_admin1', '暗影管理员1', 'shadow_admin1@example.com', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOEa7adp7v50qG6RfXyMqG6RfXyMq', '0', 'system', NOW()),
(32, 1010, 'shadow_member1', '暗影成员1', 'shadow_member1@example.com', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOEa7adp7v50qG6RfXyMqG6RfXyMq', '0', 'system', NOW());

-- ================================================
-- DOTA2分区用户
-- ================================================

-- 传奇工会
INSERT INTO sys_user (user_id, dept_id, user_name, nick_name, email, password, status, create_by, create_time) VALUES
(40, 1020, 'legend_leader', '传奇会长', 'legend_leader@example.com', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOEa7adp7v50qG6RfXyMqG6RfXyMq', '0', 'system', NOW()),
(41, 1020, 'legend_member1', '传奇成员1', 'legend_member1@example.com', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOEa7adp7v50qG6RfXyMqG6RfXyMq', '0', 'system', NOW());

-- ================================================
-- 无工会用户
-- ================================================
INSERT INTO sys_user (user_id, dept_id, user_name, nick_name, email, password, status, create_by, create_time) VALUES
(99, 199, 'no_club_user1', '无工会用户1', 'noclub1@example.com', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOEa7adp7v50qG6RfXyMqG6RfXyMq', '0', 'system', NOW()),
(100, 199, 'no_club_user2', '无工会用户2', 'noclub2@example.com', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOEa7adp7v50qG6RfXyMqG6RfXyMq', '0', 'system', NOW());

-- ================================================
-- 创建角色关联（用户-角色关系）
-- ================================================
-- 首先查看现有的角色
-- 超级管理员角色（角色ID通常为1）
INSERT INTO sys_user_role (user_id, role_id) VALUES
(1, 1); -- admin 拥有超级管理员角色

-- ================================================
-- 输出提示
-- ================================================
SELECT '数据结构创建完成！' AS message;