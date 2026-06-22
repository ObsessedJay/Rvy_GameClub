-- ============================================
-- GameClub 菜单配置（直接执行版本）
-- 数据库: ry_vue
-- ============================================

-- 先删除可能存在的旧菜单数据
DELETE FROM sys_menu WHERE menu_name IN ('GameClub管理', '游戏分区', '工会管理', '工会公告', '工会申请', '工会黑名单', '操作日志', '工会任务', '工会消息', '工会成员');

-- 1. GameClub主菜单
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3000, 'GameClub管理', 0, 6, 'gameclub', NULL, 'M', '0', '0', '', 'game', 'admin', sysdate(), 'admin', sysdate(), 'GameClub管理目录');

-- 2. 游戏分区管理
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3001, '游戏分区', 3000, 1, 'partition', 'gameclub/partition/index', 'C', '0', '0', 'gameclub:partition:list', 'tree', 'admin', sysdate(), 'admin', sysdate(), '游戏分区菜单');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3002, '游戏分区查询', 3001, 1, '', '', 'F', '0', '0', 'gameclub:partition:query', '#', 'admin', sysdate(), 'admin', sysdate(), '');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3003, '游戏分区新增', 3001, 2, '', '', 'F', '0', '0', 'gameclub:partition:add', '#', 'admin', sysdate(), 'admin', sysdate(), '');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3004, '游戏分区修改', 3001, 3, '', '', 'F', '0', '0', 'gameclub:partition:edit', '#', 'admin', sysdate(), 'admin', sysdate(), '');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3005, '游戏分区删除', 3001, 4, '', '', 'F', '0', '0', 'gameclub:partition:remove', '#', 'admin', sysdate(), 'admin', sysdate(), '');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3006, '游戏分区导出', 3001, 5, '', '', 'F', '0', '0', 'gameclub:partition:export', '#', 'admin', sysdate(), 'admin', sysdate(), '');

-- 3. 工会管理
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3007, '工会管理', 3000, 2, 'guild', 'gameclub/guild/index', 'C', '0', '0', 'gameclub:guild:list', 'peoples', 'admin', sysdate(), 'admin', sysdate(), '工会管理菜单');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3008, '工会查询', 3007, 1, '', '', 'F', '0', '0', 'gameclub:guild:query', '#', 'admin', sysdate(), 'admin', sysdate(), '');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3009, '工会新增', 3007, 2, '', '', 'F', '0', '0', 'gameclub:guild:add', '#', 'admin', sysdate(), 'admin', sysdate(), '');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3010, '工会修改', 3007, 3, '', '', 'F', '0', '0', 'gameclub:guild:edit', '#', 'admin', sysdate(), 'admin', sysdate(), '');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3011, '工会删除', 3007, 4, '', '', 'F', '0', '0', 'gameclub:guild:remove', '#', 'admin', sysdate(), 'admin', sysdate(), '');

-- 4. 工会成员管理
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3012, '工会成员', 3000, 3, 'member', 'gameclub/member/index', 'C', '0', '0', 'gameclub:member:list', 'user', 'admin', sysdate(), 'admin', sysdate(), '工会成员菜单');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3013, '成员查询', 3012, 1, '', '', 'F', '0', '0', 'gameclub:member:query', '#', 'admin', sysdate(), 'admin', sysdate(), '');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3014, '成员新增', 3012, 2, '', '', 'F', '0', '0', 'gameclub:member:add', '#', 'admin', sysdate(), 'admin', sysdate(), '');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3015, '成员修改', 3012, 3, '', '', 'F', '0', '0', 'gameclub:member:edit', '#', 'admin', sysdate(), 'admin', sysdate(), '');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3016, '成员删除', 3012, 4, '', '', 'F', '0', '0', 'gameclub:member:remove', '#', 'admin', sysdate(), 'admin', sysdate(), '');

-- 5. 工会公告管理
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3017, '工会公告', 3000, 4, 'announcement', 'gameclub/announcement/index', 'C', '0', '0', 'gameclub:announcement:list', 'edit', 'admin', sysdate(), 'admin', sysdate(), '工会公告菜单');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3018, '公告查询', 3017, 1, '', '', 'F', '0', '0', 'gameclub:announcement:query', '#', 'admin', sysdate(), 'admin', sysdate(), '');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3019, '公告新增', 3017, 2, '', '', 'F', '0', '0', 'gameclub:announcement:add', '#', 'admin', sysdate(), 'admin', sysdate(), '');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3020, '公告修改', 3017, 3, '', '', 'F', '0', '0', 'gameclub:announcement:edit', '#', 'admin', sysdate(), 'admin', sysdate(), '');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3021, '公告删除', 3017, 4, '', '', 'F', '0', '0', 'gameclub:announcement:remove', '#', 'admin', sysdate(), 'admin', sysdate(), '');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3022, '公告导出', 3017, 5, '', '', 'F', '0', '0', 'gameclub:announcement:export', '#', 'admin', sysdate(), 'admin', sysdate(), '');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3023, '公告发布', 3017, 6, '', '', 'F', '0', '0', 'gameclub:announcement:publish', '#', 'admin', sysdate(), 'admin', sysdate(), '');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3024, '公告撤回', 3017, 7, '', '', 'F', '0', '0', 'gameclub:announcement:withdraw', '#', 'admin', sysdate(), 'admin', sysdate(), '');

-- 6. 工会申请管理
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3025, '工会申请', 3000, 5, 'application', 'gameclub/application/index', 'C', '0', '0', 'gameclub:application:list', 'form', 'admin', sysdate(), 'admin', sysdate(), '工会申请菜单');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3026, '申请查询', 3025, 1, '', '', 'F', '0', '0', 'gameclub:application:query', '#', 'admin', sysdate(), 'admin', sysdate(), '');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3027, '申请新增', 3025, 2, '', '', 'F', '0', '0', 'gameclub:application:add', '#', 'admin', sysdate(), 'admin', sysdate(), '');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3028, '申请修改', 3025, 3, '', '', 'F', '0', '0', 'gameclub:application:edit', '#', 'admin', sysdate(), 'admin', sysdate(), '');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3029, '申请删除', 3025, 4, '', '', 'F', '0', '0', 'gameclub:application:remove', '#', 'admin', sysdate(), 'admin', sysdate(), '');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3030, '申请导出', 3025, 5, '', '', 'F', '0', '0', 'gameclub:application:export', '#', 'admin', sysdate(), 'admin', sysdate(), '');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3031, '申请审批', 3025, 6, '', '', 'F', '0', '0', 'gameclub:application:approve', '#', 'admin', sysdate(), 'admin', sysdate(), '');

-- 7. 工会黑名单管理
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3032, '工会黑名单', 3000, 6, 'blacklist', 'gameclub/blacklist/index', 'C', '0', '0', 'gameclub:blacklist:list', 'ban', 'admin', sysdate(), 'admin', sysdate(), '工会黑名单菜单');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3033, '黑名单查询', 3032, 1, '', '', 'F', '0', '0', 'gameclub:blacklist:query', '#', 'admin', sysdate(), 'admin', sysdate(), '');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3034, '黑名单新增', 3032, 2, '', '', 'F', '0', '0', 'gameclub:blacklist:add', '#', 'admin', sysdate(), 'admin', sysdate(), '');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3035, '黑名单修改', 3032, 3, '', '', 'F', '0', '0', 'gameclub:blacklist:edit', '#', 'admin', sysdate(), 'admin', sysdate(), '');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3036, '黑名单删除', 3032, 4, '', '', 'F', '0', '0', 'gameclub:blacklist:remove', '#', 'admin', sysdate(), 'admin', sysdate(), '');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3037, '黑名单导出', 3032, 5, '', '', 'F', '0', '0', 'gameclub:blacklist:export', '#', 'admin', sysdate(), 'admin', sysdate(), '');

-- 8. 工会操作日志
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3038, '操作日志', 3000, 7, 'operationLog', 'gameclub/operationLog/index', 'C', '0', '0', 'gameclub:operationLog:list', 'log', 'admin', sysdate(), 'admin', sysdate(), '工会操作日志菜单');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3039, '日志查询', 3038, 1, '', '', 'F', '0', '0', 'gameclub:operationLog:query', '#', 'admin', sysdate(), 'admin', sysdate(), '');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3040, '日志删除', 3038, 2, '', '', 'F', '0', '0', 'gameclub:operationLog:remove', '#', 'admin', sysdate(), 'admin', sysdate(), '');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3041, '日志清空', 3038, 3, '', '', 'F', '0', '0', 'gameclub:operationLog:clear', '#', 'admin', sysdate(), 'admin', sysdate(), '');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3042, '日志导出', 3038, 4, '', '', 'F', '0', '0', 'gameclub:operationLog:export', '#', 'admin', sysdate(), 'admin', sysdate(), '');

-- 9. 工会任务管理
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3043, '工会任务', 3000, 8, 'task', 'gameclub/task/index', 'C', '0', '0', 'gameclub:task:list', 'checkbox', 'admin', sysdate(), 'admin', sysdate(), '工会任务菜单');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3044, '任务查询', 3043, 1, '', '', 'F', '0', '0', 'gameclub:task:query', '#', 'admin', sysdate(), 'admin', sysdate(), '');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3045, '任务新增', 3043, 2, '', '', 'F', '0', '0', 'gameclub:task:add', '#', 'admin', sysdate(), 'admin', sysdate(), '');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3046, '任务修改', 3043, 3, '', '', 'F', '0', '0', 'gameclub:task:edit', '#', 'admin', sysdate(), 'admin', sysdate(), '');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3047, '任务删除', 3043, 4, '', '', 'F', '0', '0', 'gameclub:task:remove', '#', 'admin', sysdate(), 'admin', sysdate(), '');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3048, '任务导出', 3043, 5, '', '', 'F', '0', '0', 'gameclub:task:export', '#', 'admin', sysdate(), 'admin', sysdate(), '');

-- 10. 工会消息管理
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3049, '工会消息', 3000, 9, 'message', 'gameclub/message/index', 'C', '0', '0', 'gameclub:message:list', 'message', 'admin', sysdate(), 'admin', sysdate(), '工会消息菜单');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3050, '消息查询', 3049, 1, '', '', 'F', '0', '0', 'gameclub:message:query', '#', 'admin', sysdate(), 'admin', sysdate(), '');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3051, '消息新增', 3049, 2, '', '', 'F', '0', '0', 'gameclub:message:add', '#', 'admin', sysdate(), 'admin', sysdate(), '');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3052, '消息修改', 3049, 3, '', '', 'F', '0', '0', 'gameclub:message:edit', '#', 'admin', sysdate(), 'admin', sysdate(), '');

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (3053, '消息删除', 3049, 4, '', '', 'F', '0', '0', 'gameclub:message:remove', '#', 'admin', sysdate(), 'admin', sysdate(), '');

-- ============================================
-- 为admin角色分配GameClub菜单权限
-- ============================================
-- 先删除可能存在的旧权限
DELETE FROM sys_role_menu WHERE menu_id >= 3000 AND menu_id < 3100;

-- 为admin角色（role_id=1）分配所有GameClub菜单权限
INSERT INTO sys_role_menu (role_id, menu_id) VALUES
(1, 3000), (1, 3001), (1, 3002), (1, 3003), (1, 3004), (1, 3005), (1, 3006),
(1, 3007), (1, 3008), (1, 3009), (1, 3010), (1, 3011),
(1, 3012), (1, 3013), (1, 3014), (1, 3015), (1, 3016),
(1, 3017), (1, 3018), (1, 3019), (1, 3020), (1, 3021), (1, 3022), (1, 3023), (1, 3024),
(1, 3025), (1, 3026), (1, 3027), (1, 3028), (1, 3029), (1, 3030), (1, 3031),
(1, 3032), (1, 3033), (1, 3034), (1, 3035), (1, 3036), (1, 3037),
(1, 3038), (1, 3039), (1, 3040), (1, 3041), (1, 3042),
(1, 3043), (1, 3044), (1, 3045), (1, 3046), (1, 3047), (1, 3048),
(1, 3049), (1, 3050), (1, 3051), (1, 3052), (1, 3053);

-- ============================================
-- 菜单配置完成！
-- ============================================
SELECT 'GameClub菜单导入成功！' AS result;