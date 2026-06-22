-- ============================================
-- GameClub 菜单配置
-- 创建时间: 2026-06-07
-- ============================================

-- 1. GameClub主菜单
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, update_by)
VALUES ('GameClub管理', 0, 6, 'gameclub', NULL, 'M', '0', '0', '', 'game', 'admin', 'admin');

-- 获取GameClub菜单ID
SET @gameclub_id = LAST_INSERT_ID();

-- 2. 游戏分区管理
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, update_by)
VALUES ('游戏分区', @gameclub_id, 1, 'partition', 'gameclub/partition/index', 'C', '0', '0', 'gameclub:partition:list', 'tree', 'admin', 'admin');

-- 获取游戏分区菜单ID
SET @partition_id = LAST_INSERT_ID();

-- 3. 游戏分区菜单权限
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, update_by)
VALUES ('游戏分区查询', @partition_id, 1, '', '', 'F', '0', '0', 'gameclub:partition:query', '#', 'admin', 'admin');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, update_by)
VALUES ('游戏分区新增', @partition_id, 2, '', '', 'F', '0', '0', 'gameclub:partition:add', '#', 'admin', 'admin');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, update_by)
VALUES ('游戏分区修改', @partition_id, 3, '', '', 'F', '0', '0', 'gameclub:partition:edit', '#', 'admin', 'admin');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, update_by)
VALUES ('游戏分区删除', @partition_id, 4, '', '', 'F', '0', '0', 'gameclub:partition:remove', '#', 'admin', 'admin');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, update_by)
VALUES ('游戏分区导出', @partition_id, 5, '', '', 'F', '0', '0', 'gameclub:partition:export', '#', 'admin', 'admin');

-- 4. 工会管理
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, update_by)
VALUES ('工会管理', @gameclub_id, 2, 'guild', 'gameclub/guild/index', 'C', '0', '0', 'gameclub:guild:list', 'peoples', 'admin', 'admin');

SET @guild_id = LAST_INSERT_ID();

-- 5. 工会菜单权限
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, update_by)
VALUES ('工会查询', @guild_id, 1, '', '', 'F', '0', '0', 'gameclub:guild:query', '#', 'admin', 'admin');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, update_by)
VALUES ('工会新增', @guild_id, 2, '', '', 'F', '0', '0', 'gameclub:guild:add', '#', 'admin', 'admin');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, update_by)
VALUES ('工会修改', @guild_id, 3, '', '', 'F', '0', '0', 'gameclub:guild:edit', '#', 'admin', 'admin');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, update_by)
VALUES ('工会删除', @guild_id, 4, '', '', 'F', '0', '0', 'gameclub:guild:remove', '#', 'admin', 'admin');

-- 6. 工会公告管理
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, update_by)
VALUES ('工会公告', @gameclub_id, 3, 'announcement', 'gameclub/announcement/index', 'C', '0', '0', 'gameclub:announcement:list', 'edit', 'admin', 'admin');

SET @announcement_id = LAST_INSERT_ID();

-- 7. 工会公告菜单权限
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, update_by)
VALUES ('公告查询', @announcement_id, 1, '', '', 'F', '0', '0', 'gameclub:announcement:query', '#', 'admin', 'admin');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, update_by)
VALUES ('公告新增', @announcement_id, 2, '', '', 'F', '0', '0', 'gameclub:announcement:add', '#', 'admin', 'admin');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, update_by)
VALUES ('公告修改', @announcement_id, 3, '', '', 'F', '0', '0', 'gameclub:announcement:edit', '#', 'admin', 'admin');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, update_by)
VALUES ('公告删除', @announcement_id, 4, '', '', 'F', '0', '0', 'gameclub:announcement:remove', '#', 'admin', 'admin');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, update_by)
VALUES ('公告导出', @announcement_id, 5, '', '', 'F', '0', '0', 'gameclub:announcement:export', '#', 'admin', 'admin');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, update_by)
VALUES ('公告发布', @announcement_id, 6, '', '', 'F', '0', '0', 'gameclub:announcement:publish', '#', 'admin', 'admin');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, update_by)
VALUES ('公告撤回', @announcement_id, 7, '', '', 'F', '0', '0', 'gameclub:announcement:withdraw', '#', 'admin', 'admin');

-- 8. 工会申请管理
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, update_by)
VALUES ('工会申请', @gameclub_id, 4, 'application', 'gameclub/application/index', 'C', '0', '0', 'gameclub:application:list', 'form', 'admin', 'admin');

SET @application_id = LAST_INSERT_ID();

-- 9. 工会申请菜单权限
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, update_by)
VALUES ('申请查询', @application_id, 1, '', '', 'F', '0', '0', 'gameclub:application:query', '#', 'admin', 'admin');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, update_by)
VALUES ('申请新增', @application_id, 2, '', '', 'F', '0', '0', 'gameclub:application:add', '#', 'admin', 'admin');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, update_by)
VALUES ('申请修改', @application_id, 3, '', '', 'F', '0', '0', 'gameclub:application:edit', '#', 'admin', 'admin');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, update_by)
VALUES ('申请删除', @application_id, 4, '', '', 'F', '0', '0', 'gameclub:application:remove', '#', 'admin', 'admin');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, update_by)
VALUES ('申请导出', @application_id, 5, '', '', 'F', '0', '0', 'gameclub:application:export', '#', 'admin', 'admin');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, update_by)
VALUES ('申请审批', @application_id, 6, '', '', 'F', '0', '0', 'gameclub:application:approve', '#', 'admin', 'admin');

-- 10. 工会黑名单管理
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, update_by)
VALUES ('工会黑名单', @gameclub_id, 5, 'blacklist', 'gameclub/blacklist/index', 'C', '0', '0', 'gameclub:blacklist:list', 'ban', 'admin', 'admin');

SET @blacklist_id = LAST_INSERT_ID();

-- 11. 工会黑名单菜单权限
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, update_by)
VALUES ('黑名单查询', @blacklist_id, 1, '', '', 'F', '0', '0', 'gameclub:blacklist:query', '#', 'admin', 'admin');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, update_by)
VALUES ('黑名单新增', @blacklist_id, 2, '', '', 'F', '0', '0', 'gameclub:blacklist:add', '#', 'admin', 'admin');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, update_by)
VALUES ('黑名单修改', @blacklist_id, 3, '', '', 'F', '0', '0', 'gameclub:blacklist:edit', '#', 'admin', 'admin');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, update_by)
VALUES ('黑名单删除', @blacklist_id, 4, '', '', 'F', '0', '0', 'gameclub:blacklist:remove', '#', 'admin', 'admin');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, update_by)
VALUES ('黑名单导出', @blacklist_id, 5, '', '', 'F', '0', '0', 'gameclub:blacklist:export', '#', 'admin', 'admin');

-- 12. 工会操作日志
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, update_by)
VALUES ('操作日志', @gameclub_id, 6, 'operationLog', 'gameclub/operationLog/index', 'C', '0', '0', 'gameclub:operationLog:list', 'log', 'admin', 'admin');

SET @operationLog_id = LAST_INSERT_ID();

-- 13. 工会操作日志菜单权限
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, update_by)
VALUES ('日志查询', @operationLog_id, 1, '', '', 'F', '0', '0', 'gameclub:operationLog:query', '#', 'admin', 'admin');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, update_by)
VALUES ('日志删除', @operationLog_id, 2, '', '', 'F', '0', '0', 'gameclub:operationLog:remove', '#', 'admin', 'admin');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, update_by)
VALUES ('日志清空', @operationLog_id, 3, '', '', 'F', '0', '0', 'gameclub:operationLog:clear', '#', 'admin', 'admin');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, update_by)
VALUES ('日志导出', @operationLog_id, 4, '', '', 'F', '0', '0', 'gameclub:operationLog:export', '#', 'admin', 'admin');

-- ============================================
-- 菜单配置完成！
-- ============================================