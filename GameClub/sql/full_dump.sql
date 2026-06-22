-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: ry_vue
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `ry_vue`
--

/*!40000 DROP DATABASE IF EXISTS `ry_vue`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `ry_vue` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `ry_vue`;

--
-- Table structure for table `application_cooldown`
--

DROP TABLE IF EXISTS `application_cooldown`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `application_cooldown` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `guild_id` bigint NOT NULL COMMENT '工会ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `reject_count` int DEFAULT '0' COMMENT '24小时内被拒绝次数',
  `cooldown_end_time` datetime DEFAULT NULL COMMENT '冷却结束时间',
  `last_reject_time` datetime DEFAULT NULL COMMENT '最后一次被拒绝时间',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_guild_user` (`guild_id`,`user_id`),
  KEY `idx_cooldown_end` (`cooldown_end_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='申请冷却记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `application_cooldown`
--

LOCK TABLES `application_cooldown` WRITE;
/*!40000 ALTER TABLE `application_cooldown` DISABLE KEYS */;
/*!40000 ALTER TABLE `application_cooldown` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_partition`
--

DROP TABLE IF EXISTS `game_partition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_partition` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '分区ID',
  `game_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '游戏名称',
  `game_code` varchar(20) COLLATE utf8mb4_general_ci NOT NULL COMMENT '游戏编码（唯一）',
  `icon` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '游戏图标URL',
  `description` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '游戏简介',
  `sort_order` int DEFAULT '0' COMMENT '排序',
  `status` tinyint DEFAULT '1' COMMENT '状态：0-禁用 1-正常',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `dept_id` bigint DEFAULT NULL COMMENT '对应部门ID',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_game_code` (`game_code`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='游戏分区表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_partition`
--

LOCK TABLES `game_partition` WRITE;
/*!40000 ALTER TABLE `game_partition` DISABLE KEYS */;
INSERT INTO `game_partition` VALUES (1,'英雄联盟','lol','/images/games/lol.png','League of Legends - 全球最受欢迎的MOBA游戏',1,1,'2026-06-07 23:35:52','2026-06-09 03:53:08',202),(2,'魔兽世界','wow','/images/games/wow.png','World of Warcraft - 经典MMORPG',2,1,'2026-06-07 23:35:52','2026-06-09 03:15:02',203),(3,'DOTA2','dota2','/images/games/dota2.png','Dota 2 - 硬核MOBA竞技游戏',3,1,'2026-06-07 23:35:52','2026-06-10 00:57:27',214),(4,'CSGO','csgo','/images/games/csgo.png','Counter-Strike: Global Offensive - 经典射击游戏',4,1,'2026-06-07 23:35:52','2026-06-10 00:57:27',215),(9,'王者荣耀','wzry',NULL,NULL,5,1,'2026-06-15 21:07:26','2026-06-15 21:07:26',219);
/*!40000 ALTER TABLE `game_partition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gen_table`
--

DROP TABLE IF EXISTS `gen_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gen_table` (
  `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '生成功能作者',
  `form_col_num` int DEFAULT '1' COMMENT '表单布局（单列 双列 三列）',
  `gen_type` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='代码生成业务表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gen_table`
--

LOCK TABLES `gen_table` WRITE;
/*!40000 ALTER TABLE `gen_table` DISABLE KEYS */;
/*!40000 ALTER TABLE `gen_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gen_table_column`
--

DROP TABLE IF EXISTS `gen_table_column`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gen_table_column` (
  `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '字典类型',
  `sort` int DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='代码生成业务表字段';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gen_table_column`
--

LOCK TABLES `gen_table_column` WRITE;
/*!40000 ALTER TABLE `gen_table_column` DISABLE KEYS */;
/*!40000 ALTER TABLE `gen_table_column` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guild`
--

DROP TABLE IF EXISTS `guild`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guild` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '工会ID',
  `game_partition_id` bigint NOT NULL COMMENT '所属游戏分区',
  `name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '工会名称',
  `description` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '工会简介',
  `recruit_requirement` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '招募要求',
  `online_time` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '常驻在线时段',
  `avatar` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '工会头像URL',
  `banner` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '宣传图URL',
  `president_id` bigint DEFAULT NULL COMMENT '会长用户ID',
  `member_count` int DEFAULT '0' COMMENT '成员数量',
  `status` tinyint DEFAULT '1' COMMENT '状态：0-解散 1-正常',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间（软删除）',
  `archive_until` datetime DEFAULT NULL COMMENT '归档到期时间',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `dept_id` bigint DEFAULT NULL COMMENT '对应部门ID',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_partition_name` (`game_partition_id`,`name`),
  KEY `idx_game_partition` (`game_partition_id`),
  KEY `idx_president` (`president_id`),
  CONSTRAINT `fk_guild_partition` FOREIGN KEY (`game_partition_id`) REFERENCES `game_partition` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工会表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guild`
--

LOCK TABLES `guild` WRITE;
/*!40000 ALTER TABLE `guild` DISABLE KEYS */;
INSERT INTO `guild` VALUES (8,1,'YuKki工会',NULL,NULL,NULL,NULL,NULL,NULL,3,1,NULL,NULL,'2026-06-13 15:52:02','2026-06-15 21:44:19',204),(9,9,'亡者工会',NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL,NULL,'2026-06-15 21:09:20','2026-06-15 21:40:12',220);
/*!40000 ALTER TABLE `guild` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guild_announcement`
--

DROP TABLE IF EXISTS `guild_announcement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guild_announcement` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `guild_id` bigint NOT NULL COMMENT '工会ID',
  `game_partition_id` bigint NOT NULL COMMENT '游戏分区ID',
  `title` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '公告标题',
  `content` text COLLATE utf8mb4_general_ci NOT NULL COMMENT '公告内容',
  `is_top` tinyint DEFAULT '0' COMMENT '是否置顶：0-否 1-是',
  `publisher_id` bigint NOT NULL COMMENT '发布人ID',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_guild` (`guild_id`),
  KEY `idx_created` (`created_at`),
  CONSTRAINT `fk_announcement_guild` FOREIGN KEY (`guild_id`) REFERENCES `guild` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工会公告表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guild_announcement`
--

LOCK TABLES `guild_announcement` WRITE;
/*!40000 ALTER TABLE `guild_announcement` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild_announcement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guild_application`
--

DROP TABLE IF EXISTS `guild_application`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guild_application` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '申请ID',
  `guild_id` bigint NOT NULL COMMENT '工会ID',
  `game_partition_id` bigint NOT NULL COMMENT '游戏分区ID',
  `user_id` bigint NOT NULL COMMENT '申请人ID',
  `message` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '申请留言',
  `status` tinyint DEFAULT '0' COMMENT '状态：0-待审核 1-已通过 2-已拒绝 3-已过期',
  `reject_reason` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '拒绝理由',
  `reviewer_id` bigint DEFAULT NULL COMMENT '审核人ID',
  `review_time` datetime DEFAULT NULL COMMENT '审核时间',
  `expire_time` datetime DEFAULT NULL COMMENT '过期时间',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',
  PRIMARY KEY (`id`),
  KEY `idx_guild` (`guild_id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_status` (`status`),
  CONSTRAINT `fk_application_guild` FOREIGN KEY (`guild_id`) REFERENCES `guild` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='入会申请表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guild_application`
--

LOCK TABLES `guild_application` WRITE;
/*!40000 ALTER TABLE `guild_application` DISABLE KEYS */;
INSERT INTO `guild_application` VALUES (1,8,1,1,'*',1,NULL,NULL,'2026-06-14 15:21:46',NULL,'2026-06-14 15:05:23'),(2,8,1,1,'--',1,NULL,NULL,'2026-06-14 16:05:59',NULL,'2026-06-14 16:05:40'),(3,8,1,3,'****',1,NULL,NULL,'2026-06-14 16:33:42',NULL,'2026-06-14 16:32:58'),(4,8,1,102,'我要加入\n',1,NULL,NULL,'2026-06-14 20:31:02',NULL,'2026-06-14 19:47:17'),(5,8,1,1,'1',1,NULL,NULL,'2026-06-14 20:19:19',NULL,'2026-06-14 20:13:17'),(6,8,1,102,'00',2,NULL,NULL,'2026-06-15 00:28:41',NULL,'2026-06-14 20:35:26'),(7,8,1,103,'我是孙小狗，噜啦啦噜啦啦噜啦啦噜啦啦噜啦啦噜啦啦噜啦啦噜啦啦噜啦啦噜啦啦噜啦啦噜啦啦噜啦啦噜啦啦噜啦啦噜啦啦噜啦啦噜啦啦噜啦啦噜啦啦啦啦啦',1,NULL,NULL,'2026-06-15 00:23:14',NULL,'2026-06-15 00:23:00'),(8,8,1,103,'我是孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗',1,NULL,NULL,'2026-06-15 00:30:31',NULL,'2026-06-15 00:30:19'),(9,8,1,3,'我要进入',1,NULL,NULL,'2026-06-15 00:59:17',NULL,'2026-06-15 00:59:11'),(10,8,1,3,'1',1,NULL,NULL,'2026-06-15 00:59:41',NULL,'2026-06-15 00:59:32'),(11,8,1,3,'9',1,NULL,NULL,'2026-06-15 01:12:02',NULL,'2026-06-15 01:11:57'),(12,9,9,1,'11\n',1,NULL,NULL,'2026-06-15 21:20:50',NULL,'2026-06-15 21:20:25');
/*!40000 ALTER TABLE `guild_application` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guild_blacklist`
--

DROP TABLE IF EXISTS `guild_blacklist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guild_blacklist` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `guild_id` bigint NOT NULL COMMENT '工会ID',
  `game_partition_id` bigint NOT NULL COMMENT '游戏分区ID',
  `user_id` bigint NOT NULL COMMENT '被拉黑用户ID',
  `reason` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '拉黑原因',
  `operator_id` bigint NOT NULL COMMENT '操作人ID',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '拉黑时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_guild_user` (`guild_id`,`user_id`),
  KEY `idx_user` (`user_id`),
  CONSTRAINT `fk_blacklist_guild` FOREIGN KEY (`guild_id`) REFERENCES `guild` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='黑名单表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guild_blacklist`
--

LOCK TABLES `guild_blacklist` WRITE;
/*!40000 ALTER TABLE `guild_blacklist` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild_blacklist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guild_chat_message`
--

DROP TABLE IF EXISTS `guild_chat_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guild_chat_message` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '消息ID',
  `guild_id` bigint NOT NULL COMMENT '工会ID',
  `sender_id` bigint NOT NULL COMMENT '发送者用户ID',
  `sender_name` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '发送者昵称',
  `content` varchar(2000) COLLATE utf8mb4_general_ci NOT NULL COMMENT '消息内容',
  `type` tinyint DEFAULT '1' COMMENT '消息类型：1-文本 2-系统通知 3-@提醒',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '发送时间',
  PRIMARY KEY (`id`),
  KEY `idx_guild_time` (`guild_id`,`created_at`),
  KEY `idx_sender` (`sender_id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工会聊天消息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guild_chat_message`
--

LOCK TABLES `guild_chat_message` WRITE;
/*!40000 ALTER TABLE `guild_chat_message` DISABLE KEYS */;
INSERT INTO `guild_chat_message` VALUES (1,8,1,'YuKki','卡了卡了',1,'2026-06-16 01:21:40'),(2,8,1,'YuKki','你好',1,'2026-06-16 01:21:55'),(3,8,1,'YuKki','你好你好',1,'2026-06-16 01:23:43'),(4,8,1,'YuKki','测试测试',1,'2026-06-16 01:24:02'),(5,8,1,'YuKki','测试测试',1,'2026-06-16 01:25:27'),(6,8,1,'YuKki','消息123',1,'2026-06-16 01:25:34'),(7,8,1,'YuKki','114111',1,'2026-06-16 01:25:41'),(8,8,1,'YuKki','hello',1,'2026-06-16 01:27:03'),(9,8,0,'AI助手','AI 助手调用失败：401 Authorization Required on POST request for \"https://api.deepseek.com/v1/chat/completions\": [no body]',2,'2026-06-16 01:48:58'),(10,8,0,'AI助手','AI 助手调用失败：401 Authorization Required on POST request for \"https://api.deepseek.com/v1/chat/completions\": [no body]',2,'2026-06-16 01:52:17'),(11,8,1,'YuKki','111',1,'2026-06-16 01:56:04'),(12,8,0,'AI助手','欢迎来到工会！这里是你的AI助手，有什么游戏问题、策略讨论或工会事务需要帮忙的？尽管问我吧！',2,'2026-06-16 01:56:13'),(13,8,0,'AI助手','我是工会的AI助手，专注于解答游戏问题、分享策略和管理工会事务。随时为你服务，请告诉我需要什么帮助！',2,'2026-06-16 01:56:25'),(14,8,0,'AI助手','您好！作为工会AI助手，我暂时无法识别您的具体身份。不过，如果您能告诉我您的游戏昵称或角色名，我可以更好地为您提供帮助。请问有什么问题或需要讨论的策略吗？',2,'2026-06-16 01:56:42'),(15,8,0,'AI助手','我是专门为游戏工会服务的AI助手，可以帮你解答游戏问题、讨论策略或管理工会事务。你可以直接问我任何相关的问题！',2,'2026-06-16 01:57:02'),(16,9,1,'YuKki','卡了卡了',1,'2026-06-16 01:57:54'),(17,9,0,'AI助手','我是属于“星辰之翼”工会的AI助手！有什么需要帮忙的吗？比如游戏策略、活动安排，还是其他工会事务？',2,'2026-06-16 01:58:29'),(18,9,0,'AI助手','请注意言辞，我们工会提倡友善交流。如有问题或需要帮助，请以礼貌的方式提出，我会尽力解答！',2,'2026-06-16 01:58:43'),(19,8,0,'AI助手','我是YuKki工会的AI助手，隶属于会长YuKki，由管理员happypuppy和肝帝共同管理。有什么需要帮忙的吗？',2,'2026-06-16 02:07:54'),(20,8,0,'AI助手','当前工会暂无新任务发布。若有新任务，会长YuKki或管理员happypuppy、肝帝会第一时间通知大家。请留意工会公告或群消息哦！',2,'2026-06-16 02:08:21'),(21,8,0,'AI助手','目前工会没有显示过期的任务。如果有任务已到期，一般会在任务列表中标注“已过期”或无法接取。你可以让会长YuKki或管理员happypuppy、肝帝在后台确认一下。需要我帮你转达给他们吗？',2,'2026-06-16 02:08:36'),(22,8,0,'AI助手','请问您需要什么帮助？请告诉我具体问题或需求，我会尽力协助您。',2,'2026-06-16 02:08:51'),(23,8,102,'肝帝','我是',1,'2026-06-16 16:32:43'),(24,8,102,'肝帝','肝帝',1,'2026-06-16 16:33:08'),(25,8,102,'肝帝','卡了卡了',1,'2026-06-16 16:33:21'),(26,8,1,'YuKki','卡了卡',1,'2026-06-16 16:33:30'),(27,8,0,'AI助手','你好，我是「YuKki工会」的AI助手，正在为你服务！请问有什么可以帮你的吗？',2,'2026-06-16 16:33:39'),(28,8,0,'AI助手','目前工会暂无新任务发布。请留意后续通知，保持活跃！如有疑问可联系：会长YuKki、管理员happypuppy或肝帝。',2,'2026-06-16 16:34:40'),(29,8,0,'AI助手','好的，已收到您的任务发布！请提供任务详情，工会成员将尽快处理。如有需要，可联系会长YuKki或管理员happypuppy、肝帝协调。',2,'2026-06-16 16:34:58'),(30,8,0,'AI助手','目前可接取的任务如下：\n1. **日常巡逻**（推荐等级30+，奖励金币+经验）\n2. **深渊探索**（推荐等级50+，奖励稀有材料）\n3. **护送商队**（推荐等级40+，奖励装备碎片）\n如需详细信息或接取，请告知任务编号。',2,'2026-06-16 16:35:20'),(31,9,1,'YuKki','1‘',1,'2026-06-22 20:48:40'),(32,9,0,'AI助手','AI 助手暂未配置 API Key，请联系管理员。',2,'2026-06-22 20:48:51');
/*!40000 ALTER TABLE `guild_chat_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guild_create_application`
--

DROP TABLE IF EXISTS `guild_create_application`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guild_create_application` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '申请ID',
  `game_partition_id` bigint NOT NULL COMMENT '游戏分区ID',
  `guild_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '工会名称',
  `description` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '工会简介',
  `recruit_requirement` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '招募要求',
  `applicant_id` bigint NOT NULL COMMENT '申请人ID',
  `status` tinyint DEFAULT '0' COMMENT '状态：0-待审核 1-已通过 2-已拒绝',
  `reject_reason` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '拒绝理由',
  `reviewer_id` bigint DEFAULT NULL COMMENT '审核人ID',
  `review_time` datetime DEFAULT NULL COMMENT '审核时间',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_partition_name` (`game_partition_id`,`guild_name`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工会创建申请表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guild_create_application`
--

LOCK TABLES `guild_create_application` WRITE;
/*!40000 ALTER TABLE `guild_create_application` DISABLE KEYS */;
INSERT INTO `guild_create_application` VALUES (1,1,'1','','',3,1,NULL,1,'2026-06-15 22:04:20','2026-06-15 21:53:40');
/*!40000 ALTER TABLE `guild_create_application` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guild_member`
--

DROP TABLE IF EXISTS `guild_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guild_member` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `guild_id` bigint NOT NULL COMMENT '工会ID',
  `game_partition_id` bigint NOT NULL COMMENT '游戏分区ID（冗余，用于隔离）',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role` tinyint NOT NULL COMMENT '角色：1-会长 2-管理员 3-普通成员',
  `join_time` datetime DEFAULT NULL COMMENT '入会时间',
  `status` tinyint DEFAULT '1' COMMENT '状态：0-已退出 1-正常',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_partition_user` (`game_partition_id`,`user_id`),
  KEY `idx_guild` (`guild_id`),
  KEY `idx_user` (`user_id`),
  CONSTRAINT `fk_member_guild` FOREIGN KEY (`guild_id`) REFERENCES `guild` (`id`),
  CONSTRAINT `fk_member_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工会成员表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guild_member`
--

LOCK TABLES `guild_member` WRITE;
/*!40000 ALTER TABLE `guild_member` DISABLE KEYS */;
INSERT INTO `guild_member` VALUES (1,8,1,1,1,'2026-06-14 16:00:43',1,'2026-06-14 16:00:43','2026-06-14 16:34:37'),(12,8,1,102,2,'2026-06-14 20:31:02',1,'2026-06-15 00:41:20','2026-06-15 00:46:08'),(13,8,1,103,2,'2026-06-15 00:30:31',1,'2026-06-15 00:41:20','2026-06-15 00:48:22'),(17,9,9,1,3,'2026-06-15 21:20:51',1,'2026-06-15 21:20:50','2026-06-15 21:20:50');
/*!40000 ALTER TABLE `guild_member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guild_message`
--

DROP TABLE IF EXISTS `guild_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guild_message` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '消息ID',
  `guild_id` bigint DEFAULT NULL COMMENT '工会ID',
  `receiver_id` bigint DEFAULT NULL COMMENT '接收者ID',
  `sender_id` bigint DEFAULT NULL COMMENT '发送者ID',
  `title` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '消息标题',
  `content` text COLLATE utf8mb4_unicode_ci COMMENT '消息内容',
  `msg_type` tinyint DEFAULT '1' COMMENT '消息类型：1-系统 2-工会',
  `status` tinyint DEFAULT '0' COMMENT '状态：0-未读 1-已读',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_guild_id` (`guild_id`),
  KEY `idx_receiver_id` (`receiver_id`),
  KEY `idx_sender_id` (`sender_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='工会消息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guild_message`
--

LOCK TABLES `guild_message` WRITE;
/*!40000 ALTER TABLE `guild_message` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guild_operation_log`
--

DROP TABLE IF EXISTS `guild_operation_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guild_operation_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `game_partition_id` bigint DEFAULT NULL COMMENT '游戏分区ID',
  `guild_id` bigint DEFAULT NULL COMMENT '工会ID',
  `operator_id` bigint NOT NULL COMMENT '操作人ID',
  `operator_role` tinyint DEFAULT NULL COMMENT '操作人角色：1-会长 2-管理员 3-普通成员',
  `operation_type` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '操作类型',
  `operation_desc` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '操作描述',
  `old_value` text COLLATE utf8mb4_general_ci COMMENT '修改前数据',
  `new_value` text COLLATE utf8mb4_general_ci COMMENT '修改后数据',
  `ip_address` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'IP地址',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  PRIMARY KEY (`id`),
  KEY `idx_guild` (`guild_id`),
  KEY `idx_operator` (`operator_id`),
  KEY `idx_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工会操作日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guild_operation_log`
--

LOCK TABLES `guild_operation_log` WRITE;
/*!40000 ALTER TABLE `guild_operation_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild_operation_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guild_task`
--

DROP TABLE IF EXISTS `guild_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guild_task` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `guild_id` bigint NOT NULL COMMENT '工会ID',
  `game_partition_id` bigint NOT NULL COMMENT '游戏分区ID',
  `publisher_id` bigint NOT NULL COMMENT '发布人ID',
  `name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务名称',
  `type` tinyint DEFAULT '1' COMMENT '任务类型：1-日常打卡 2-副本组队 3-活动任务 4-竞技任务',
  `description` text COLLATE utf8mb4_general_ci COMMENT '任务详情',
  `image` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '配图URL',
  `task_mode` tinyint DEFAULT '1' COMMENT '任务模式：1-单人 2-多人',
  `min_players` int DEFAULT '1' COMMENT '人数下限',
  `max_players` int DEFAULT '1' COMMENT '人数上限',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `join_deadline` datetime DEFAULT NULL COMMENT '接取截止时间',
  `end_time` datetime DEFAULT NULL COMMENT '截止时间',
  `status` tinyint DEFAULT '1' COMMENT '状态：1-未开始 2-进行中 3-已满员 4-已结束 5-已作废 6-已关闭 7-已完成',
  `current_players` int DEFAULT '0' COMMENT '当前参与人数',
  `version` int DEFAULT '0' COMMENT '乐观锁版本号',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_guild` (`guild_id`),
  KEY `idx_publisher` (`publisher_id`),
  KEY `idx_status` (`status`),
  KEY `idx_end_time` (`end_time`),
  CONSTRAINT `fk_task_guild` FOREIGN KEY (`guild_id`) REFERENCES `guild` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工会任务表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guild_task`
--

LOCK TABLES `guild_task` WRITE;
/*!40000 ALTER TABLE `guild_task` DISABLE KEYS */;
INSERT INTO `guild_task` VALUES (5,8,1,1,'1',1,NULL,NULL,NULL,1,2,NULL,'2026-06-15 01:38:39','2026-06-15 01:38:47',4,2,0,'2026-06-15 01:37:54','2026-06-15 01:39:38'),(6,8,1,1,'2',3,'测试测试',NULL,NULL,2,3,NULL,'2026-06-17 14:00:00','2026-06-18 14:00:00',1,2,0,'2026-06-16 16:34:32','2026-06-16 16:36:05');
/*!40000 ALTER TABLE `guild_task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_config`
--

DROP TABLE IF EXISTS `sys_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_config` (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) COLLATE utf8mb4_unicode_ci DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='参数配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_config`
--

LOCK TABLES `sys_config` WRITE;
/*!40000 ALTER TABLE `sys_config` DISABLE KEYS */;
INSERT INTO `sys_config` VALUES (1,'主框架页-默认皮肤样式名称','sys.index.skinName','skin-blue','Y','admin','2026-06-07 22:27:02','',NULL,'蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow'),(2,'用户管理-账号初始密码','sys.user.initPassword','123456','Y','admin','2026-06-07 22:27:02','',NULL,'初始化密码 123456'),(3,'主框架页-侧边栏主题','sys.index.sideTheme','theme-dark','Y','admin','2026-06-07 22:27:02','',NULL,'深色主题theme-dark，浅色主题theme-light'),(4,'账号自助-验证码开关','sys.account.captchaEnabled','true','Y','admin','2026-06-07 22:27:02','',NULL,'是否开启验证码功能（true开启，false关闭）'),(5,'账号自助-是否开启用户注册功能','sys.account.registerUser','true','Y','admin','2026-06-07 22:27:02','admin','2026-06-07 22:44:54','是否开启注册用户功能（true开启，false关闭）'),(6,'用户登录-黑名单列表','sys.login.blackIPList','','Y','admin','2026-06-07 22:27:02','',NULL,'设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）'),(7,'用户管理-初始密码修改策略','sys.account.initPasswordModify','1','Y','admin','2026-06-07 22:27:02','',NULL,'0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框'),(8,'用户管理-账号密码更新周期','sys.account.passwordValidateDays','0','Y','admin','2026-06-07 22:27:02','',NULL,'密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框'),(9,'用户管理-密码字符范围','sys.account.chrtype','0','Y','admin','2026-06-07 22:27:02','',NULL,'默认任意字符范围，0任意（密码可以输入任意字符），1数字（密码只能为0-9数字），2英文字母（密码只能为a-z和A-Z字母），3字母和数字（密码必须包含字母，数字）,4字母数字和特殊字符（目前支持的特殊字符包括：~!@#$%^&*()-=_+）');
/*!40000 ALTER TABLE `sys_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dept`
--

DROP TABLE IF EXISTS `sys_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dept` (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint DEFAULT '0' COMMENT '父部门id',
  `ancestors` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '部门名称',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `leader` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '邮箱',
  `status` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`)
) ENGINE=InnoDB AUTO_INCREMENT=222 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='部门表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dept`
--

LOCK TABLES `sys_dept` WRITE;
/*!40000 ALTER TABLE `sys_dept` DISABLE KEYS */;
INSERT INTO `sys_dept` VALUES (100,0,'','网站汇总',0,'YuKki','15729728627','2517487412@qq.com','0','0','admin','2026-06-07 00:00:00','admin','2026-06-07 22:54:09'),(201,100,',100','GameClub',2,'YuKki','15729728627','2517487412@qq.com','0','0','admin','2026-06-07 22:54:50','admin','2026-06-07 22:55:21'),(202,201,',100,201','英雄联盟',1,NULL,NULL,NULL,'0','0','admin','2026-06-07 22:57:49','',NULL),(204,202,',100,201,202','YuKki工会',1,'YuKki','15729728627','2517487412@qq.com','0','0','admin','2026-06-07 23:00:57','',NULL),(205,201,',100,201','无工会用户',2,NULL,NULL,NULL,'0','0','admin','2026-06-07 23:01:46','',NULL),(214,201,',100,201','DOTA2',1,NULL,NULL,NULL,'0','0','system','2026-06-10 00:57:27','',NULL),(215,201,',100,201','CSGO',1,NULL,NULL,NULL,'0','0','system','2026-06-10 00:57:27','',NULL),(219,201,',100,201','王者荣耀',5,NULL,NULL,NULL,'0','0','system','2026-06-15 21:07:26','',NULL),(220,219,',100,201,219','亡者工会',0,NULL,NULL,NULL,'0','0','system','2026-06-15 21:09:20','',NULL);
/*!40000 ALTER TABLE `sys_dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_data`
--

DROP TABLE IF EXISTS `sys_dict_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_data` (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int DEFAULT '0' COMMENT '字典排序',
  `dict_label` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) COLLATE utf8mb4_unicode_ci DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='字典数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_data`
--

LOCK TABLES `sys_dict_data` WRITE;
/*!40000 ALTER TABLE `sys_dict_data` DISABLE KEYS */;
INSERT INTO `sys_dict_data` VALUES (1,1,'男','0','sys_user_sex','','','Y','0','admin','2026-06-07 22:27:02','',NULL,'性别男'),(2,2,'女','1','sys_user_sex','','','N','0','admin','2026-06-07 22:27:02','',NULL,'性别女'),(3,3,'未知','2','sys_user_sex','','','N','0','admin','2026-06-07 22:27:02','',NULL,'性别未知'),(4,1,'显示','0','sys_show_hide','','primary','Y','0','admin','2026-06-07 22:27:02','',NULL,'显示菜单'),(5,2,'隐藏','1','sys_show_hide','','danger','N','0','admin','2026-06-07 22:27:02','',NULL,'隐藏菜单'),(6,1,'正常','0','sys_normal_disable','','primary','Y','0','admin','2026-06-07 22:27:02','',NULL,'正常状态'),(7,2,'停用','1','sys_normal_disable','','danger','N','0','admin','2026-06-07 22:27:02','',NULL,'停用状态'),(8,1,'正常','0','sys_job_status','','primary','Y','0','admin','2026-06-07 22:27:02','',NULL,'正常状态'),(9,2,'暂停','1','sys_job_status','','danger','N','0','admin','2026-06-07 22:27:02','',NULL,'停用状态'),(10,1,'默认','DEFAULT','sys_job_group','','','Y','0','admin','2026-06-07 22:27:02','',NULL,'默认分组'),(11,2,'系统','SYSTEM','sys_job_group','','','N','0','admin','2026-06-07 22:27:02','',NULL,'系统分组'),(12,1,'是','Y','sys_yes_no','','primary','Y','0','admin','2026-06-07 22:27:02','',NULL,'系统默认是'),(13,2,'否','N','sys_yes_no','','danger','N','0','admin','2026-06-07 22:27:02','',NULL,'系统默认否'),(14,1,'通知','1','sys_notice_type','','warning','Y','0','admin','2026-06-07 22:27:02','',NULL,'通知'),(15,2,'公告','2','sys_notice_type','','success','N','0','admin','2026-06-07 22:27:02','',NULL,'公告'),(16,1,'正常','0','sys_notice_status','','primary','Y','0','admin','2026-06-07 22:27:02','',NULL,'正常状态'),(17,2,'关闭','1','sys_notice_status','','danger','N','0','admin','2026-06-07 22:27:02','',NULL,'关闭状态'),(18,99,'其他','0','sys_oper_type','','info','N','0','admin','2026-06-07 22:27:02','',NULL,'其他操作'),(19,1,'新增','1','sys_oper_type','','info','N','0','admin','2026-06-07 22:27:02','',NULL,'新增操作'),(20,2,'修改','2','sys_oper_type','','info','N','0','admin','2026-06-07 22:27:02','',NULL,'修改操作'),(21,3,'删除','3','sys_oper_type','','danger','N','0','admin','2026-06-07 22:27:02','',NULL,'删除操作'),(22,4,'授权','4','sys_oper_type','','primary','N','0','admin','2026-06-07 22:27:02','',NULL,'授权操作'),(23,5,'导出','5','sys_oper_type','','warning','N','0','admin','2026-06-07 22:27:02','',NULL,'导出操作'),(24,6,'导入','6','sys_oper_type','','warning','N','0','admin','2026-06-07 22:27:02','',NULL,'导入操作'),(25,7,'强退','7','sys_oper_type','','danger','N','0','admin','2026-06-07 22:27:02','',NULL,'强退操作'),(26,8,'生成代码','8','sys_oper_type','','warning','N','0','admin','2026-06-07 22:27:02','',NULL,'生成操作'),(27,9,'清空数据','9','sys_oper_type','','danger','N','0','admin','2026-06-07 22:27:02','',NULL,'清空操作'),(28,1,'成功','0','sys_common_status','','primary','N','0','admin','2026-06-07 22:27:02','',NULL,'正常状态'),(29,2,'失败','1','sys_common_status','','danger','N','0','admin','2026-06-07 22:27:02','',NULL,'停用状态');
/*!40000 ALTER TABLE `sys_dict_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_type`
--

DROP TABLE IF EXISTS `sys_dict_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_type` (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '字典类型',
  `status` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`),
  UNIQUE KEY `dict_type` (`dict_type`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='字典类型表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_type`
--

LOCK TABLES `sys_dict_type` WRITE;
/*!40000 ALTER TABLE `sys_dict_type` DISABLE KEYS */;
INSERT INTO `sys_dict_type` VALUES (1,'用户性别','sys_user_sex','0','admin','2026-06-07 22:27:02','',NULL,'用户性别列表'),(2,'菜单状态','sys_show_hide','0','admin','2026-06-07 22:27:02','',NULL,'菜单状态列表'),(3,'系统开关','sys_normal_disable','0','admin','2026-06-07 22:27:02','',NULL,'系统开关列表'),(4,'任务状态','sys_job_status','0','admin','2026-06-07 22:27:02','',NULL,'任务状态列表'),(5,'任务分组','sys_job_group','0','admin','2026-06-07 22:27:02','',NULL,'任务分组列表'),(6,'系统是否','sys_yes_no','0','admin','2026-06-07 22:27:02','',NULL,'系统是否列表'),(7,'通知类型','sys_notice_type','0','admin','2026-06-07 22:27:02','',NULL,'通知类型列表'),(8,'通知状态','sys_notice_status','0','admin','2026-06-07 22:27:02','',NULL,'通知状态列表'),(9,'操作类型','sys_oper_type','0','admin','2026-06-07 22:27:02','',NULL,'操作类型列表'),(10,'系统状态','sys_common_status','0','admin','2026-06-07 22:27:02','',NULL,'登录状态列表');
/*!40000 ALTER TABLE `sys_dict_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_job`
--

DROP TABLE IF EXISTS `sys_job`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_job` (
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`,`job_name`,`job_group`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='定时任务调度表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_job`
--

LOCK TABLES `sys_job` WRITE;
/*!40000 ALTER TABLE `sys_job` DISABLE KEYS */;
INSERT INTO `sys_job` VALUES (1,'系统默认（无参）','DEFAULT','ryTask.ryNoParams','0/10 * * * * ?','3','1','1','admin','2026-06-07 22:27:02','',NULL,''),(2,'系统默认（有参）','DEFAULT','ryTask.ryParams(\'ry\')','0/15 * * * * ?','3','1','1','admin','2026-06-07 22:27:02','',NULL,''),(3,'系统默认（多参）','DEFAULT','ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)','0/20 * * * * ?','3','1','1','admin','2026-06-07 22:27:02','',NULL,'');
/*!40000 ALTER TABLE `sys_job` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_job_log`
--

DROP TABLE IF EXISTS `sys_job_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_job_log` (
  `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '日志信息',
  `status` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '异常信息',
  `start_time` datetime DEFAULT NULL COMMENT '执行开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '执行结束时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='定时任务调度日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_job_log`
--

LOCK TABLES `sys_job_log` WRITE;
/*!40000 ALTER TABLE `sys_job_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_job_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_logininfor`
--

DROP TABLE IF EXISTS `sys_logininfor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_logininfor` (
  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '操作系统',
  `status` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '提示消息',
  `login_time` datetime DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`),
  KEY `idx_sys_logininfor_s` (`status`),
  KEY `idx_sys_logininfor_lt` (`login_time`)
) ENGINE=InnoDB AUTO_INCREMENT=211 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统访问记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_logininfor`
--

LOCK TABLES `sys_logininfor` WRITE;
/*!40000 ALTER TABLE `sys_logininfor` DISABLE KEYS */;
INSERT INTO `sys_logininfor` VALUES (100,'admin','127.0.0.1','内网IP','Chrome 148','Windows10','0','退出成功','2026-06-07 22:30:02'),(101,'admin','127.0.0.1','内网IP','Chrome 148','Windows10','0','登录成功','2026-06-07 22:30:03'),(102,'admin','127.0.0.1','内网IP','Chrome 148','Windows10','0','登录成功','2026-06-07 23:56:38'),(103,'admin','127.0.0.1','内网IP','Chrome 148','Windows10','0','退出成功','2026-06-08 01:36:26'),(104,'ry','127.0.0.1','内网IP','Chrome 148','Windows10','0','登录成功','2026-06-08 01:36:30'),(105,'ry','127.0.0.1','内网IP','Chrome 148','Windows10','0','退出成功','2026-06-08 01:36:58'),(106,'admin','127.0.0.1','内网IP','Chrome 148','Windows10','1','验证码错误','2026-06-08 01:37:03'),(107,'admin','127.0.0.1','内网IP','Chrome 148','Windows10','1','验证码错误','2026-06-08 01:37:05'),(108,'admin','127.0.0.1','内网IP','Chrome 148','Windows10','0','登录成功','2026-06-08 01:37:10'),(109,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','登录成功','2026-06-09 01:43:07'),(110,'admin','127.0.0.1','内网IP','Chrome 148','Windows10','0','登录成功','2026-06-09 01:56:41'),(111,'admin','127.0.0.1','内网IP','Chrome 148','Windows10','0','登录成功','2026-06-09 03:22:52'),(112,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.8457','Windows 10.0','1','验证码已失效','2026-06-09 03:38:33'),(113,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.8457','Windows 10.0','0','登录成功','2026-06-09 03:42:02'),(114,'testuser','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.8457','Windows 10.0','1','用户不存在/密码错误','2026-06-09 03:44:24'),(115,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.8457','Windows 10.0','0','登录成功','2026-06-09 03:49:57'),(116,'admin','127.0.0.1','内网IP','Chrome 148','Windows10','0','登录成功','2026-06-09 10:05:08'),(117,'admin','127.0.0.1','内网IP','Chrome 148','Windows10','0','登录成功','2026-06-09 12:43:40'),(118,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','登录成功','2026-06-10 00:43:11'),(119,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','登录成功','2026-06-10 01:29:53'),(120,'admin','127.0.0.1','内网IP','Chrome 148','Windows10','0','登录成功','2026-06-10 01:40:56'),(121,'admin','127.0.0.1','内网IP','Chrome 148','Windows10','0','登录成功','2026-06-10 03:14:59'),(122,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-13 14:39:23'),(123,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-13 14:47:14'),(124,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','登录成功','2026-06-13 15:35:59'),(125,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','退出成功','2026-06-13 15:38:44'),(126,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','登录成功','2026-06-13 15:38:47'),(127,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-13 16:04:15'),(128,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-13 16:05:34'),(129,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-13 16:14:07'),(130,'sk','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-13 16:14:13'),(131,'sk','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-13 16:14:48'),(132,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-13 16:14:52'),(133,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-13 16:15:21'),(134,'sk','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-13 16:15:28'),(135,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-14 14:25:32'),(136,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-14 14:27:01'),(137,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','1','验证码错误','2026-06-14 14:27:04'),(138,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','1','验证码错误','2026-06-14 14:27:07'),(139,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-14 14:27:13'),(140,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-14 14:57:28'),(141,'sk','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-14 14:57:35'),(142,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','登录成功','2026-06-14 15:05:03'),(143,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','退出成功','2026-06-14 16:29:51'),(144,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','登录成功','2026-06-14 16:29:55'),(145,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','退出成功','2026-06-14 16:30:13'),(146,'sk','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','登录成功','2026-06-14 16:30:23'),(147,'sk','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','退出成功','2026-06-14 16:33:07'),(148,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','登录成功','2026-06-14 16:33:09'),(149,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','登录成功','2026-06-14 18:40:56'),(150,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','退出成功','2026-06-14 18:45:59'),(151,'sk','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','登录成功','2026-06-14 18:46:07'),(152,'sk','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-14 18:46:21'),(153,'sk','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-14 18:47:14'),(154,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-14 18:47:17'),(155,'sk','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','退出成功','2026-06-14 19:12:04'),(156,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','登录成功','2026-06-14 19:12:08'),(157,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','退出成功','2026-06-14 19:38:26'),(158,'ry','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','登录成功','2026-06-14 19:38:30'),(159,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-14 19:38:40'),(160,'ry','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-14 19:38:48'),(161,'ry','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-14 19:39:14'),(162,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-14 19:39:17'),(163,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-14 19:39:33'),(164,'肝帝','127.0.0.1','内网IP','Chrome 149','Windows10','0','注册成功','2026-06-14 19:40:57'),(165,'肝帝','127.0.0.1','内网IP','Chrome 149','Windows10','1','用户不存在/密码错误','2026-06-14 19:41:06'),(166,'肝帝','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-14 19:41:11'),(167,'ry','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','退出成功','2026-06-14 19:41:42'),(168,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','登录成功','2026-06-14 19:41:44'),(169,'肝帝','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-14 19:46:21'),(170,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-14 19:46:23'),(171,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-14 19:46:41'),(172,'肝帝','127.0.0.1','内网IP','Chrome 149','Windows10','1','用户不存在/密码错误','2026-06-14 19:46:46'),(173,'肝帝','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-14 19:46:51'),(174,'肝帝','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-14 19:47:22'),(175,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-14 19:47:25'),(176,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','退出成功','2026-06-14 20:34:04'),(177,'肝帝','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','登录成功','2026-06-14 20:34:46'),(178,'肝帝','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','退出成功','2026-06-14 20:36:48'),(179,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','1','验证码错误','2026-06-14 20:36:51'),(180,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','登录成功','2026-06-14 20:37:07'),(181,'admin','192.168.2.55','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-15 00:06:58'),(182,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-15 00:07:19'),(183,'happypuppy','192.168.2.115','内网IP','Chrome 148','Windows10','0','注册成功','2026-06-15 00:08:35'),(184,'happypuppy','192.168.2.115','内网IP','Chrome 148','Windows10','0','登录成功','2026-06-15 00:08:51'),(185,'admin','192.168.2.80','内网IP','Quark 7.4.6.681','Windows XP x64 Edition','0','登录成功','2026-06-15 00:20:48'),(186,'happypuppy','192.168.2.115','内网IP','Chrome 148','Windows10','0','退出成功','2026-06-15 00:48:55'),(187,'happypuppy','192.168.2.115','内网IP','Chrome 148','Windows10','0','登录成功','2026-06-15 00:49:01'),(188,'sk','192.168.2.80','内网IP','Quark 7.4.6.681','Windows XP x64 Edition','0','登录成功','2026-06-15 00:58:46'),(189,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-15 21:06:31'),(190,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-15 21:44:23'),(191,'sk','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-15 21:44:31'),(192,'sk','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-15 21:54:21'),(193,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-15 21:54:27'),(194,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-15 22:29:23'),(195,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-15 22:34:07'),(196,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','登录成功','2026-06-16 00:21:50'),(197,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','退出成功','2026-06-16 00:22:39'),(198,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','登录成功','2026-06-16 00:22:42'),(199,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-16 00:48:19'),(200,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-16 00:53:54'),(201,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-16 00:53:59'),(202,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-16 00:58:39'),(203,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-16 01:29:17'),(204,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','1','验证码已失效','2026-06-16 01:55:24'),(205,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-16 01:55:27'),(206,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-16 16:31:52'),(207,'肝帝','192.168.2.80','内网IP','Quark 7.4.6.681','Windows XP x64 Edition','1','用户不存在/密码错误','2026-06-16 16:32:25'),(208,'肝帝','192.168.2.80','内网IP','Quark 7.4.6.681','Windows XP x64 Edition','1','验证码错误','2026-06-16 16:32:31'),(209,'肝帝','192.168.2.80','内网IP','Quark 7.4.6.681','Windows XP x64 Edition','0','登录成功','2026-06-16 16:32:35'),(210,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-22 20:48:20');
/*!40000 ALTER TABLE `sys_logininfor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_menu`
--

DROP TABLE IF EXISTS `sys_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_menu` (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint DEFAULT '0' COMMENT '父菜单ID',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `path` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '路由名称',
  `is_frame` int DEFAULT '1' COMMENT '是否为外链（0是 1否）',
  `is_cache` int DEFAULT '0' COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3006 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='菜单权限表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_menu`
--

LOCK TABLES `sys_menu` WRITE;
/*!40000 ALTER TABLE `sys_menu` DISABLE KEYS */;
INSERT INTO `sys_menu` VALUES (1,'系统管理',0,1,'system',NULL,'','',1,0,'M','0','0','','system','admin','2026-06-07 22:27:01','',NULL,'系统管理目录'),(2,'系统监控',0,2,'monitor',NULL,'','',1,0,'M','0','0','','monitor','admin','2026-06-07 22:27:01','admin','2026-06-07 23:11:53','系统监控目录'),(3,'系统工具',0,3,'tool',NULL,'','',1,0,'M','1','1','','tool','admin','2026-06-07 22:27:01','admin','2026-06-07 23:12:17','系统工具目录'),(4,'若依官网',0,4,'http://ruoyi.vip',NULL,'','',0,0,'M','0','1','','guide','admin','2026-06-07 22:27:01','admin','2026-06-07 23:14:51','若依官网地址'),(100,'用户管理',1,1,'user','system/user/index','','',1,0,'C','0','0','system:user:list','user','admin','2026-06-07 22:27:01','',NULL,'用户管理菜单'),(101,'角色管理',1,2,'role','system/role/index','','',1,0,'C','0','0','system:role:list','peoples','admin','2026-06-07 22:27:01','',NULL,'角色管理菜单'),(102,'菜单管理',1,3,'menu','system/menu/index','','',1,0,'C','0','0','system:menu:list','tree-table','admin','2026-06-07 22:27:01','',NULL,'菜单管理菜单'),(103,'部门管理',1,4,'dept','system/dept/index','','',1,0,'C','0','0','system:dept:list','tree','admin','2026-06-07 22:27:01','',NULL,'部门管理菜单'),(104,'岗位管理',1,5,'post','system/post/index','','',1,0,'C','0','0','system:post:list','post','admin','2026-06-07 22:27:01','',NULL,'岗位管理菜单'),(105,'字典管理',1,6,'dict','system/dict/index','','',1,0,'C','0','0','system:dict:list','dict','admin','2026-06-07 22:27:01','admin','2026-06-08 01:37:36','字典管理菜单'),(106,'参数设置',1,7,'config','system/config/index','','',1,0,'C','0','0','system:config:list','edit','admin','2026-06-07 22:27:01','',NULL,'参数设置菜单'),(107,'通知公告',1,8,'notice','system/notice/index','','',1,0,'C','1','0','system:notice:list','message','admin','2026-06-07 22:27:01','admin','2026-06-07 23:18:13','通知公告菜单'),(108,'日志管理',1,9,'log','','','',1,0,'M','1','0','','log','admin','2026-06-07 22:27:01','admin','2026-06-07 23:18:17','日志管理菜单'),(109,'在线用户',2,1,'online','monitor/online/index','','',1,0,'C','0','0','monitor:online:list','online','admin','2026-06-07 22:27:02','admin','2026-06-07 23:13:22','在线用户菜单'),(110,'定时任务',2,2,'job','monitor/job/index','','',1,0,'C','1','1','monitor:job:list','job','admin','2026-06-07 22:27:02','admin','2026-06-07 23:11:26','定时任务菜单'),(111,'数据监控',2,3,'druid','monitor/druid/index','','',1,0,'C','1','1','monitor:druid:list','druid','admin','2026-06-07 22:27:02','admin','2026-06-07 23:12:00','数据监控菜单'),(112,'服务监控',2,4,'server','monitor/server/index','','',1,0,'C','1','1','monitor:server:list','server','admin','2026-06-07 22:27:02','admin','2026-06-07 23:12:04','服务监控菜单'),(113,'缓存监控',2,5,'cache','monitor/cache/index','','',1,0,'C','1','1','monitor:cache:list','redis','admin','2026-06-07 22:27:02','admin','2026-06-07 23:12:08','缓存监控菜单'),(114,'缓存列表',2,6,'cacheList','monitor/cache/list','','',1,0,'C','0','1','monitor:cache:list','redis-list','admin','2026-06-07 22:27:02','admin','2026-06-07 23:13:47','缓存列表菜单'),(115,'表单构建',3,1,'build','tool/build/index','','',1,0,'C','1','1','tool:build:list','build','admin','2026-06-07 22:27:02','admin','2026-06-07 23:12:25','表单构建菜单'),(116,'代码生成',3,2,'gen','tool/gen/index','','',1,0,'C','1','1','tool:gen:list','code','admin','2026-06-07 22:27:02','admin','2026-06-07 23:12:28','代码生成菜单'),(117,'系统接口',3,3,'swagger','tool/swagger/index','','',1,0,'C','0','1','tool:swagger:list','swagger','admin','2026-06-07 22:27:02','admin','2026-06-07 23:12:36','系统接口菜单'),(500,'操作日志',108,1,'operlog','monitor/operlog/index','','',1,0,'C','0','0','monitor:operlog:list','form','admin','2026-06-07 22:27:02','',NULL,'操作日志菜单'),(501,'登录日志',108,2,'logininfor','monitor/logininfor/index','','',1,0,'C','0','0','monitor:logininfor:list','logininfor','admin','2026-06-07 22:27:02','',NULL,'登录日志菜单'),(1000,'用户查询',100,1,'','','','',1,0,'F','0','0','system:user:query','#','admin','2026-06-07 22:27:02','',NULL,''),(1001,'用户新增',100,2,'','','','',1,0,'F','0','0','system:user:add','#','admin','2026-06-07 22:27:02','',NULL,''),(1002,'用户修改',100,3,'','','','',1,0,'F','0','0','system:user:edit','#','admin','2026-06-07 22:27:02','',NULL,''),(1003,'用户删除',100,4,'','','','',1,0,'F','0','0','system:user:remove','#','admin','2026-06-07 22:27:02','',NULL,''),(1004,'用户导出',100,5,'','','','',1,0,'F','0','0','system:user:export','#','admin','2026-06-07 22:27:02','',NULL,''),(1005,'用户导入',100,6,'','','','',1,0,'F','0','0','system:user:import','#','admin','2026-06-07 22:27:02','',NULL,''),(1006,'重置密码',100,7,'','','','',1,0,'F','0','0','system:user:resetPwd','#','admin','2026-06-07 22:27:02','',NULL,''),(1007,'角色查询',101,1,'','','','',1,0,'F','0','0','system:role:query','#','admin','2026-06-07 22:27:02','',NULL,''),(1008,'角色新增',101,2,'','','','',1,0,'F','0','0','system:role:add','#','admin','2026-06-07 22:27:02','',NULL,''),(1009,'角色修改',101,3,'','','','',1,0,'F','0','0','system:role:edit','#','admin','2026-06-07 22:27:02','',NULL,''),(1010,'角色删除',101,4,'','','','',1,0,'F','0','0','system:role:remove','#','admin','2026-06-07 22:27:02','',NULL,''),(1011,'角色导出',101,5,'','','','',1,0,'F','0','0','system:role:export','#','admin','2026-06-07 22:27:02','',NULL,''),(1012,'菜单查询',102,1,'','','','',1,0,'F','0','0','system:menu:query','#','admin','2026-06-07 22:27:02','',NULL,''),(1013,'菜单新增',102,2,'','','','',1,0,'F','0','0','system:menu:add','#','admin','2026-06-07 22:27:02','',NULL,''),(1014,'菜单修改',102,3,'','','','',1,0,'F','0','0','system:menu:edit','#','admin','2026-06-07 22:27:02','',NULL,''),(1015,'菜单删除',102,4,'','','','',1,0,'F','0','0','system:menu:remove','#','admin','2026-06-07 22:27:02','',NULL,''),(1016,'部门查询',103,1,'','','','',1,0,'F','0','0','system:dept:query','#','admin','2026-06-07 22:27:02','',NULL,''),(1017,'部门新增',103,2,'','','','',1,0,'F','0','0','system:dept:add','#','admin','2026-06-07 22:27:02','',NULL,''),(1018,'部门修改',103,3,'','','','',1,0,'F','0','0','system:dept:edit','#','admin','2026-06-07 22:27:02','',NULL,''),(1019,'部门删除',103,4,'','','','',1,0,'F','0','0','system:dept:remove','#','admin','2026-06-07 22:27:02','',NULL,''),(1020,'岗位查询',104,1,'','','','',1,0,'F','0','0','system:post:query','#','admin','2026-06-07 22:27:02','',NULL,''),(1021,'岗位新增',104,2,'','','','',1,0,'F','0','0','system:post:add','#','admin','2026-06-07 22:27:02','',NULL,''),(1022,'岗位修改',104,3,'','','','',1,0,'F','0','0','system:post:edit','#','admin','2026-06-07 22:27:02','',NULL,''),(1023,'岗位删除',104,4,'','','','',1,0,'F','0','0','system:post:remove','#','admin','2026-06-07 22:27:02','',NULL,''),(1024,'岗位导出',104,5,'','','','',1,0,'F','0','0','system:post:export','#','admin','2026-06-07 22:27:02','',NULL,''),(1025,'字典查询',105,1,'#','','','',1,0,'F','0','0','system:dict:query','#','admin','2026-06-07 22:27:02','',NULL,''),(1026,'字典新增',105,2,'#','','','',1,0,'F','0','0','system:dict:add','#','admin','2026-06-07 22:27:02','',NULL,''),(1027,'字典修改',105,3,'#','','','',1,0,'F','0','0','system:dict:edit','#','admin','2026-06-07 22:27:02','',NULL,''),(1028,'字典删除',105,4,'#','','','',1,0,'F','0','0','system:dict:remove','#','admin','2026-06-07 22:27:02','',NULL,''),(1029,'字典导出',105,5,'#','','','',1,0,'F','0','0','system:dict:export','#','admin','2026-06-07 22:27:02','',NULL,''),(1030,'参数查询',106,1,'#','','','',1,0,'F','0','0','system:config:query','#','admin','2026-06-07 22:27:02','',NULL,''),(1031,'参数新增',106,2,'#','','','',1,0,'F','0','0','system:config:add','#','admin','2026-06-07 22:27:02','',NULL,''),(1032,'参数修改',106,3,'#','','','',1,0,'F','0','0','system:config:edit','#','admin','2026-06-07 22:27:02','',NULL,''),(1033,'参数删除',106,4,'#','','','',1,0,'F','0','0','system:config:remove','#','admin','2026-06-07 22:27:02','',NULL,''),(1034,'参数导出',106,5,'#','','','',1,0,'F','0','0','system:config:export','#','admin','2026-06-07 22:27:02','',NULL,''),(1035,'公告查询',107,1,'#','','','',1,0,'F','0','0','system:notice:query','#','admin','2026-06-07 22:27:02','',NULL,''),(1036,'公告新增',107,2,'#','','','',1,0,'F','0','0','system:notice:add','#','admin','2026-06-07 22:27:02','',NULL,''),(1037,'公告修改',107,3,'#','','','',1,0,'F','0','0','system:notice:edit','#','admin','2026-06-07 22:27:02','',NULL,''),(1038,'公告删除',107,4,'#','','','',1,0,'F','0','0','system:notice:remove','#','admin','2026-06-07 22:27:02','',NULL,''),(1039,'操作查询',500,1,'#','','','',1,0,'F','0','0','monitor:operlog:query','#','admin','2026-06-07 22:27:02','',NULL,''),(1040,'操作删除',500,2,'#','','','',1,0,'F','0','0','monitor:operlog:remove','#','admin','2026-06-07 22:27:02','',NULL,''),(1041,'日志导出',500,3,'#','','','',1,0,'F','0','0','monitor:operlog:export','#','admin','2026-06-07 22:27:02','',NULL,''),(1042,'登录查询',501,1,'#','','','',1,0,'F','0','0','monitor:logininfor:query','#','admin','2026-06-07 22:27:02','',NULL,''),(1043,'登录删除',501,2,'#','','','',1,0,'F','0','0','monitor:logininfor:remove','#','admin','2026-06-07 22:27:02','',NULL,''),(1044,'日志导出',501,3,'#','','','',1,0,'F','0','0','monitor:logininfor:export','#','admin','2026-06-07 22:27:02','',NULL,''),(1045,'账户解锁',501,4,'#','','','',1,0,'F','0','0','monitor:logininfor:unlock','#','admin','2026-06-07 22:27:02','',NULL,''),(1046,'在线查询',109,1,'#','','','',1,0,'F','0','0','monitor:online:query','#','admin','2026-06-07 22:27:02','',NULL,''),(1047,'批量强退',109,2,'#','','','',1,0,'F','0','0','monitor:online:batchLogout','#','admin','2026-06-07 22:27:02','',NULL,''),(1048,'单条强退',109,3,'#','','','',1,0,'F','0','0','monitor:online:forceLogout','#','admin','2026-06-07 22:27:02','',NULL,''),(1049,'任务查询',110,1,'#','','','',1,0,'F','0','0','monitor:job:query','#','admin','2026-06-07 22:27:02','',NULL,''),(1050,'任务新增',110,2,'#','','','',1,0,'F','0','0','monitor:job:add','#','admin','2026-06-07 22:27:02','',NULL,''),(1051,'任务修改',110,3,'#','','','',1,0,'F','0','0','monitor:job:edit','#','admin','2026-06-07 22:27:02','',NULL,''),(1052,'任务删除',110,4,'#','','','',1,0,'F','0','0','monitor:job:remove','#','admin','2026-06-07 22:27:02','',NULL,''),(1053,'状态修改',110,5,'#','','','',1,0,'F','0','0','monitor:job:changeStatus','#','admin','2026-06-07 22:27:02','',NULL,''),(1054,'任务导出',110,6,'#','','','',1,0,'F','0','0','monitor:job:export','#','admin','2026-06-07 22:27:02','',NULL,''),(1055,'生成查询',116,1,'#','','','',1,0,'F','0','0','tool:gen:query','#','admin','2026-06-07 22:27:02','',NULL,''),(1056,'生成修改',116,2,'#','','','',1,0,'F','0','0','tool:gen:edit','#','admin','2026-06-07 22:27:02','',NULL,''),(1057,'生成删除',116,3,'#','','','',1,0,'F','0','0','tool:gen:remove','#','admin','2026-06-07 22:27:02','',NULL,''),(1058,'导入代码',116,4,'#','','','',1,0,'F','0','0','tool:gen:import','#','admin','2026-06-07 22:27:02','',NULL,''),(1059,'预览代码',116,5,'#','','','',1,0,'F','0','0','tool:gen:preview','#','admin','2026-06-07 22:27:02','',NULL,''),(1060,'生成代码',116,6,'#','','','',1,0,'F','0','0','tool:gen:code','#','admin','2026-06-07 22:27:02','',NULL,''),(2000,'GameClub',0,4,'/gameclub-portal',NULL,NULL,'',1,0,'M','0','0','','guide','admin','2026-06-07 22:56:42','admin','2026-06-15 00:29:23',''),(2001,'GameClub管理',0,3,'gameclub',NULL,NULL,'',1,0,'M','0','0','','tool','admin',NULL,'admin','2026-06-13 14:40:04',''),(2002,'游戏分区',2001,1,'partition','gameclub/partition/index',NULL,'',1,0,'C','0','0','gameclub:partition:list','tree','admin',NULL,'admin',NULL,''),(2003,'游戏分区查询',2002,1,'','',NULL,'',1,0,'F','0','0','gameclub:partition:query','#','admin',NULL,'admin',NULL,''),(2004,'游戏分区新增',2002,2,'','',NULL,'',1,0,'F','0','0','gameclub:partition:add','#','admin',NULL,'admin',NULL,''),(2005,'游戏分区修改',2002,3,'','',NULL,'',1,0,'F','0','0','gameclub:partition:edit','#','admin',NULL,'admin',NULL,''),(2006,'游戏分区删除',2002,4,'','',NULL,'',1,0,'F','0','0','gameclub:partition:remove','#','admin',NULL,'admin',NULL,''),(2007,'游戏分区导出',2002,5,'','',NULL,'',1,0,'F','0','0','gameclub:partition:export','#','admin',NULL,'admin',NULL,''),(2008,'工会管理',2001,2,'guild','gameclub/guild/index',NULL,'',1,0,'C','0','0','gameclub:guild:list','peoples','admin',NULL,'admin',NULL,''),(2009,'工会查询',2008,1,'','',NULL,'',1,0,'F','0','0','gameclub:guild:query','#','admin',NULL,'admin',NULL,''),(2010,'工会新增',2008,2,'','',NULL,'',1,0,'F','0','0','gameclub:guild:add','#','admin',NULL,'admin',NULL,''),(2011,'工会修改',2008,3,'','',NULL,'',1,0,'F','0','0','gameclub:guild:edit','#','admin',NULL,'admin',NULL,''),(2012,'工会删除',2008,4,'','',NULL,'',1,0,'F','0','0','gameclub:guild:remove','#','admin',NULL,'admin',NULL,''),(2021,'工会成员',2001,3,'member','gameclub/member/index',NULL,'',1,0,'C','0','0','gameclub:member:list','peoples','admin',NULL,'admin',NULL,''),(2022,'工会成员查询',2021,1,'','',NULL,'',1,0,'F','0','0','gameclub:member:query','#','admin',NULL,'admin',NULL,''),(2023,'工会成员新增',2021,2,'','',NULL,'',1,0,'F','0','0','gameclub:member:add','#','admin',NULL,'admin',NULL,''),(2024,'工会成员修改',2021,3,'','',NULL,'',1,0,'F','0','0','gameclub:member:edit','#','admin',NULL,'admin',NULL,''),(2025,'工会成员删除',2021,4,'','',NULL,'',1,0,'F','0','0','gameclub:member:remove','#','admin',NULL,'admin',NULL,''),(2026,'工会成员退出',2021,5,'','',NULL,'',1,0,'F','0','0','gameclub:member:quit','#','admin',NULL,'admin',NULL,''),(2027,'工会任务',2001,3,'task','gameclub/task/index',NULL,'',1,0,'C','0','0','gameclub:task:list','cascader','admin',NULL,'admin',NULL,''),(2028,'工会任务查询',2027,1,'','',NULL,'',1,0,'F','0','0','gameclub:task:query','#','admin',NULL,'admin',NULL,''),(2029,'工会任务新增',2027,2,'','',NULL,'',1,0,'F','0','0','gameclub:task:add','#','admin',NULL,'admin',NULL,''),(2030,'工会任务修改',2027,3,'','',NULL,'',1,0,'F','0','0','gameclub:task:edit','#','admin',NULL,'admin',NULL,''),(2031,'工会任务删除',2027,4,'','',NULL,'',1,0,'F','0','0','gameclub:task:remove','#','admin',NULL,'admin',NULL,''),(2037,'工会公告',2001,3,'announcement','gameclub/announcement/index',NULL,'',1,0,'C','0','0','gameclub:announcement:list','edit','admin',NULL,'admin',NULL,''),(2038,'工会申请',2001,4,'application','gameclub/application/index',NULL,'',1,0,'C','0','0','gameclub:application:list','form','admin',NULL,'admin',NULL,''),(3002,'建会申请',2001,7,'guildCreateApp','gameclub/guildCreateApp/index',NULL,'',1,0,'C','0','0','gameclub:guildCreateApp:list','building','admin',NULL,'admin',NULL,''),(3003,'申请查询',3002,1,'','',NULL,'',1,0,'F','0','0','gameclub:guildCreateApp:query','#','admin',NULL,'admin',NULL,''),(3004,'申请审批',3002,2,'','',NULL,'',1,0,'F','0','0','gameclub:guildCreateApp:approve','#','admin',NULL,'admin',NULL,''),(3005,'申请删除',3002,3,'','',NULL,'',1,0,'F','0','0','gameclub:guildCreateApp:remove','#','admin',NULL,'admin',NULL,'');
/*!40000 ALTER TABLE `sys_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_notice`
--

DROP TABLE IF EXISTS `sys_notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_notice` (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob COMMENT '公告内容',
  `status` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='通知公告表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_notice`
--

LOCK TABLES `sys_notice` WRITE;
/*!40000 ALTER TABLE `sys_notice` DISABLE KEYS */;
INSERT INTO `sys_notice` VALUES (1,'温馨提醒：2018-07-01 若依新版本发布啦','2',_binary '新版本内容','0','admin','2026-06-07 22:27:02','',NULL,'管理员'),(2,'维护通知：2018-07-01 若依系统凌晨维护','1',_binary '维护内容','0','admin','2026-06-07 22:27:02','',NULL,'管理员'),(3,'若依开源框架介绍','1',_binary '<p><span style=\"color: rgb(230, 0, 0);\">项目介绍</span></p><p><font color=\"#333333\">RuoYi开源项目是为企业用户定制的后台脚手架框架，为企业打造的一站式解决方案，降低企业开发成本，提升开发效率。主要包括用户管理、角色管理、部门管理、菜单管理、参数管理、字典管理、</font><span style=\"color: rgb(51, 51, 51);\">岗位管理</span><span style=\"color: rgb(51, 51, 51);\">、定时任务</span><span style=\"color: rgb(51, 51, 51);\">、</span><span style=\"color: rgb(51, 51, 51);\">服务监控、登录日志、操作日志、代码生成等功能。其中，还支持多数据源、数据权限、国际化、Redis缓存、Docker部署、滑动验证码、第三方认证登录、分布式事务、</span><font color=\"#333333\">分布式文件存储</font><span style=\"color: rgb(51, 51, 51);\">、分库分表处理等技术特点。</span></p><p><img src=\"https://foruda.gitee.com/images/1773931848342439032/a4d22313_1815095.png\" style=\"width: 64px;\"><br></p><p><span style=\"color: rgb(230, 0, 0);\">官网及演示</span></p><p><span style=\"color: rgb(51, 51, 51);\">若依官网地址：&nbsp;</span><a href=\"http://ruoyi.vip\" target=\"_blank\">http://ruoyi.vip</a><a href=\"http://ruoyi.vip\" target=\"_blank\"></a></p><p><span style=\"color: rgb(51, 51, 51);\">若依文档地址：&nbsp;</span><a href=\"http://doc.ruoyi.vip\" target=\"_blank\">http://doc.ruoyi.vip</a><br></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【不分离版】：&nbsp;</span><a href=\"http://demo.ruoyi.vip\" target=\"_blank\">http://demo.ruoyi.vip</a></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【分离版本】：&nbsp;</span><a href=\"http://vue.ruoyi.vip\" target=\"_blank\">http://vue.ruoyi.vip</a></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【微服务版】：&nbsp;</span><a href=\"http://cloud.ruoyi.vip\" target=\"_blank\">http://cloud.ruoyi.vip</a></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【移动端版】：&nbsp;</span><a href=\"http://h5.ruoyi.vip\" target=\"_blank\">http://h5.ruoyi.vip</a></p><p><br style=\"color: rgb(48, 49, 51); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px;\"></p>','0','admin','2026-06-07 22:27:02','',NULL,'管理员');
/*!40000 ALTER TABLE `sys_notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_notice_read`
--

DROP TABLE IF EXISTS `sys_notice_read`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_notice_read` (
  `read_id` bigint NOT NULL AUTO_INCREMENT COMMENT '已读主键',
  `notice_id` int NOT NULL COMMENT '公告id',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `read_time` datetime NOT NULL COMMENT '阅读时间',
  PRIMARY KEY (`read_id`),
  UNIQUE KEY `uk_user_notice` (`user_id`,`notice_id`) COMMENT '同一用户同一公告只记录一次'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='公告已读记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_notice_read`
--

LOCK TABLES `sys_notice_read` WRITE;
/*!40000 ALTER TABLE `sys_notice_read` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_notice_read` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_oper_log`
--

DROP TABLE IF EXISTS `sys_oper_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_oper_log` (
  `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '模块标题',
  `business_type` int DEFAULT '0' COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '请求方式',
  `operator_type` int DEFAULT '0' COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '返回参数',
  `status` int DEFAULT '0' COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint DEFAULT '0' COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`),
  KEY `idx_sys_oper_log_bt` (`business_type`),
  KEY `idx_sys_oper_log_s` (`status`),
  KEY `idx_sys_oper_log_ot` (`oper_time`)
) ENGINE=InnoDB AUTO_INCREMENT=245 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='操作日志记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_oper_log`
--

LOCK TABLES `sys_oper_log` WRITE;
/*!40000 ALTER TABLE `sys_oper_log` DISABLE KEYS */;
INSERT INTO `sys_oper_log` VALUES (100,'角色管理',2,'com.ruoyi.web.controller.system.SysRoleController.changeStatus()','PUT',1,'admin','研发部门','/system/role/changeStatus','127.0.0.1','内网IP','{\"admin\":true,\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":1,\"status\":\"1\"} ',NULL,1,'不允许操作超级管理员角色','2026-06-07 22:29:32',8),(101,'部门管理',3,'com.ruoyi.web.controller.system.SysDeptController.remove()','DELETE',1,'admin','研发部门','/system/dept/107','127.0.0.1','内网IP','107 ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 22:30:18',13),(102,'部门管理',3,'com.ruoyi.web.controller.system.SysDeptController.remove()','DELETE',1,'admin','研发部门','/system/dept/109','127.0.0.1','内网IP','109 ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 22:30:20',11),(103,'部门管理',3,'com.ruoyi.web.controller.system.SysDeptController.remove()','DELETE',1,'admin','研发部门','/system/dept/108','127.0.0.1','内网IP','108 ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 22:30:21',10),(104,'部门管理',3,'com.ruoyi.web.controller.system.SysDeptController.remove()','DELETE',1,'admin','研发部门','/system/dept/102','127.0.0.1','内网IP','102 ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 22:30:24',10),(105,'部门管理',3,'com.ruoyi.web.controller.system.SysDeptController.remove()','DELETE',1,'admin','研发部门','/system/dept/106','127.0.0.1','内网IP','106 ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 22:30:25',11),(106,'部门管理',3,'com.ruoyi.web.controller.system.SysDeptController.remove()','DELETE',1,'admin','研发部门','/system/dept/105','127.0.0.1','内网IP','105 ','{\"msg\":\"部门存在用户,不允许删除\",\"code\":601}',0,NULL,'2026-06-07 22:30:26',4),(107,'部门管理',3,'com.ruoyi.web.controller.system.SysDeptController.remove()','DELETE',1,'admin','研发部门','/system/dept/104','127.0.0.1','内网IP','104 ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 22:30:29',14),(108,'参数管理',2,'com.ruoyi.web.controller.system.SysConfigController.edit()','PUT',1,'admin','研发部门','/system/config','127.0.0.1','内网IP','{\"configId\":5,\"configKey\":\"sys.account.registerUser\",\"configName\":\"账号自助-是否开启用户注册功能\",\"configType\":\"Y\",\"configValue\":\"true\",\"createBy\":\"admin\",\"createTime\":\"2026-06-07 22:27:02\",\"params\":{},\"remark\":\"是否开启注册用户功能（true开启，false关闭）\",\"updateBy\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 22:44:54',18),(109,'部门管理',2,'com.ruoyi.web.controller.system.SysDeptController.edit()','PUT',1,'admin','研发部门','/system/dept','127.0.0.1','内网IP','{\"ancestors\":\"\",\"children\":[],\"deptId\":100,\"deptName\":\"网站汇总\",\"email\":\"2517487412@qq.com\",\"leader\":\"YuKki\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"phone\":\"15729728627\",\"status\":\"0\",\"updateBy\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 22:54:09',16),(110,'部门管理',1,'com.ruoyi.web.controller.system.SysDeptController.add()','POST',1,'admin','研发部门','/system/dept','127.0.0.1','内网IP','{\"ancestors\":\",100\",\"children\":[],\"createBy\":\"admin\",\"deptName\":\"GameClub工会\",\"email\":\"2517487412@qq.com\",\"leader\":\"YuKki\",\"orderNum\":1,\"params\":{},\"parentId\":100,\"phone\":\"15729728627\",\"status\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 22:54:50',12),(111,'部门管理',2,'com.ruoyi.web.controller.system.SysDeptController.edit()','PUT',1,'admin','研发部门','/system/dept','127.0.0.1','内网IP','{\"ancestors\":\",100\",\"children\":[],\"deptId\":201,\"deptName\":\"GameClub\",\"email\":\"2517487412@qq.com\",\"leader\":\"YuKki\",\"orderNum\":1,\"params\":{},\"parentId\":100,\"parentName\":\"网站汇总\",\"phone\":\"15729728627\",\"status\":\"0\",\"updateBy\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 22:55:13',20),(112,'部门管理',2,'com.ruoyi.web.controller.system.SysDeptController.edit()','PUT',1,'admin','研发部门','/system/dept','127.0.0.1','内网IP','{\"ancestors\":\",100\",\"children\":[],\"deptId\":201,\"deptName\":\"GameClub\",\"email\":\"2517487412@qq.com\",\"leader\":\"YuKki\",\"orderNum\":2,\"params\":{},\"parentId\":100,\"parentName\":\"网站汇总\",\"phone\":\"15729728627\",\"status\":\"0\",\"updateBy\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 22:55:21',21),(113,'菜单管理',1,'com.ruoyi.web.controller.system.SysMenuController.add()','POST',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createBy\":\"admin\",\"icon\":\"guide\",\"isCache\":\"0\",\"isFrame\":\"0\",\"menuName\":\"GameClub\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"https://\",\"status\":\"0\",\"visible\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 22:56:42',21),(114,'部门管理',1,'com.ruoyi.web.controller.system.SysDeptController.add()','POST',1,'admin','研发部门','/system/dept','127.0.0.1','内网IP','{\"ancestors\":\",100,201\",\"children\":[],\"createBy\":\"admin\",\"deptName\":\"英雄联盟\",\"orderNum\":1,\"params\":{},\"parentId\":201,\"status\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 22:57:49',14),(115,'部门管理',1,'com.ruoyi.web.controller.system.SysDeptController.add()','POST',1,'admin','研发部门','/system/dept','127.0.0.1','内网IP','{\"ancestors\":\",100,201\",\"children\":[],\"createBy\":\"admin\",\"deptName\":\"王者荣耀\",\"orderNum\":1,\"params\":{},\"parentId\":201,\"status\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 22:58:36',9),(116,'部门管理',1,'com.ruoyi.web.controller.system.SysDeptController.add()','POST',1,'admin','研发部门','/system/dept','127.0.0.1','内网IP','{\"ancestors\":\",100,201,202\",\"children\":[],\"createBy\":\"admin\",\"deptName\":\"YuKki工会\",\"email\":\"2517487412@qq.com\",\"leader\":\"YuKki\",\"orderNum\":1,\"params\":{},\"parentId\":202,\"phone\":\"15729728627\",\"status\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:00:57',11),(117,'部门管理',1,'com.ruoyi.web.controller.system.SysDeptController.add()','POST',1,'admin','研发部门','/system/dept','127.0.0.1','内网IP','{\"ancestors\":\",100,201\",\"children\":[],\"createBy\":\"admin\",\"deptName\":\"无工会用户\",\"orderNum\":0,\"params\":{},\"parentId\":201,\"status\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:01:46',10),(118,'部门管理',1,'com.ruoyi.web.controller.system.SysDeptController.add()','POST',1,'admin','研发部门','/system/dept','127.0.0.1','内网IP','{\"ancestors\":\",100,201,203\",\"children\":[],\"createBy\":\"admin\",\"deptName\":\"AAA工会\",\"leader\":\"\",\"orderNum\":0,\"params\":{},\"parentId\":203,\"status\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:02:22',13),(119,'保存部门排序',2,'com.ruoyi.web.controller.system.SysDeptController.updateSort()','PUT',1,'admin','研发部门','/system/dept/updateSort','127.0.0.1','内网IP','{\"deptIds\":\"205\",\"orderNums\":\"2\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:03:11',21),(120,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"monitor/job/index\",\"createTime\":\"2026-06-07 22:27:02\",\"icon\":\"job\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":110,\"menuName\":\"定时任务\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2,\"path\":\"job\",\"perms\":\"monitor:job:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"1\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:11:26',11),(121,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2026-06-07 22:27:01\",\"icon\":\"monitor\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2,\"menuName\":\"系统监控\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"monitor\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:11:53',11),(122,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"monitor/druid/index\",\"createTime\":\"2026-06-07 22:27:02\",\"icon\":\"druid\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":111,\"menuName\":\"数据监控\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":2,\"path\":\"druid\",\"perms\":\"monitor:druid:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"1\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:12:00',9),(123,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"monitor/server/index\",\"createTime\":\"2026-06-07 22:27:02\",\"icon\":\"server\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":112,\"menuName\":\"服务监控\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":2,\"path\":\"server\",\"perms\":\"monitor:server:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"1\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:12:04',87),(124,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"monitor/cache/index\",\"createTime\":\"2026-06-07 22:27:02\",\"icon\":\"redis\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":113,\"menuName\":\"缓存监控\",\"menuType\":\"C\",\"orderNum\":5,\"params\":{},\"parentId\":2,\"path\":\"cache\",\"perms\":\"monitor:cache:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"1\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:12:08',9),(125,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2026-06-07 22:27:01\",\"icon\":\"tool\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":3,\"menuName\":\"系统工具\",\"menuType\":\"M\",\"orderNum\":3,\"params\":{},\"parentId\":0,\"path\":\"tool\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"1\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:12:17',10),(126,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"tool/build/index\",\"createTime\":\"2026-06-07 22:27:02\",\"icon\":\"build\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":115,\"menuName\":\"表单构建\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":3,\"path\":\"build\",\"perms\":\"tool:build:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"1\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:12:25',12),(127,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"tool/gen/index\",\"createTime\":\"2026-06-07 22:27:02\",\"icon\":\"code\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":116,\"menuName\":\"代码生成\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":3,\"path\":\"gen\",\"perms\":\"tool:gen:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"1\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:12:28',10),(128,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"tool/swagger/index\",\"createTime\":\"2026-06-07 22:27:02\",\"icon\":\"swagger\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":117,\"menuName\":\"系统接口\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":3,\"path\":\"swagger\",\"perms\":\"tool:swagger:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:12:36',23),(129,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"monitor/online/index\",\"createTime\":\"2026-06-07 22:27:02\",\"icon\":\"online\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":109,\"menuName\":\"在线用户\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2,\"path\":\"online\",\"perms\":\"monitor:online:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:13:22',10),(130,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"monitor/cache/list\",\"createTime\":\"2026-06-07 22:27:02\",\"icon\":\"redis-list\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":114,\"menuName\":\"缓存列表\",\"menuType\":\"C\",\"orderNum\":6,\"params\":{},\"parentId\":2,\"path\":\"cacheList\",\"perms\":\"monitor:cache:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:13:47',9),(131,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2026-06-07 22:27:01\",\"icon\":\"guide\",\"isCache\":\"0\",\"isFrame\":\"0\",\"menuId\":4,\"menuName\":\"若依官网\",\"menuType\":\"M\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"http://ruoyi.vip\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:14:51',9),(132,'保存菜单排序',2,'com.ruoyi.web.controller.system.SysMenuController.updateSort()','PUT',1,'admin','研发部门','/system/menu/updateSort','127.0.0.1','内网IP','{\"menuIds\":\"2000\",\"orderNums\":\"4\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:14:56',8),(133,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"system/notice/index\",\"createTime\":\"2026-06-07 22:27:01\",\"icon\":\"message\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":107,\"menuName\":\"通知公告\",\"menuType\":\"C\",\"orderNum\":8,\"params\":{},\"parentId\":1,\"path\":\"notice\",\"perms\":\"system:notice:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:18:13',9),(134,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"\",\"createTime\":\"2026-06-07 22:27:01\",\"icon\":\"log\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":108,\"menuName\":\"日志管理\",\"menuType\":\"M\",\"orderNum\":9,\"params\":{},\"parentId\":1,\"path\":\"log\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:18:17',9),(135,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"system/dict/index\",\"createTime\":\"2026-06-07 22:27:01\",\"icon\":\"dict\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":105,\"menuName\":\"字典管理\",\"menuType\":\"C\",\"orderNum\":6,\"params\":{},\"parentId\":1,\"path\":\"dict\",\"perms\":\"system:dict:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:19:04',10),(136,'用户管理',1,'com.ruoyi.web.controller.system.SysUserController.add()','POST',1,'admin','研发部门','/system/user','127.0.0.1','内网IP','{\"admin\":false,\"createBy\":\"admin\",\"deptId\":202,\"email\":\"2517487412@qq.com\",\"nickName\":\"YuKki\",\"params\":{},\"phonenumber\":\"15729728627\",\"postIds\":[1],\"roleIds\":[2],\"sex\":\"0\",\"status\":\"0\",\"userId\":100,\"userName\":\"YuKki\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:20:42',82),(137,'用户管理',1,'com.ruoyi.web.controller.system.SysUserController.add()','POST',1,'admin','研发部门','/system/user','127.0.0.1','内网IP','{\"admin\":false,\"deptId\":204,\"email\":\"2517487412@qq.com\",\"nickName\":\"YuKki\",\"params\":{},\"phonenumber\":\"15729728627\",\"postIds\":[1],\"roleIds\":[2],\"sex\":\"0\",\"status\":\"0\",\"userName\":\"YuKki\"} ','{\"msg\":\"新增用户\'YuKki\'失败，登录账号已存在\",\"code\":500}',0,NULL,'2026-06-07 23:21:25',2),(138,'用户管理',2,'com.ruoyi.web.controller.system.SysUserController.edit()','PUT',1,'admin','研发部门','/system/user','127.0.0.1','内网IP','{\"admin\":false,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2026-06-07 23:20:42\",\"delFlag\":\"0\",\"dept\":{\"ancestors\":\",100,201\",\"children\":[],\"deptId\":202,\"deptName\":\"英雄联盟\",\"orderNum\":1,\"params\":{},\"parentId\":201,\"status\":\"0\"},\"deptId\":204,\"email\":\"2517487412@qq.com\",\"loginIp\":\"\",\"nickName\":\"YuKki\",\"params\":{},\"phonenumber\":\"15729728627\",\"postIds\":[1],\"roleIds\":[2],\"roles\":[{\"admin\":false,\"dataScope\":\"2\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"普通角色\",\"roleSort\":2,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":100,\"userName\":\"YuKki\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:21:45',19),(139,'菜单管理',3,'com.ruoyi.web.controller.system.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/2013','127.0.0.1','内网IP','2013 ','{\"msg\":\"存在子菜单,不允许删除\",\"code\":601}',0,NULL,'2026-06-08 00:45:31',18),(140,'菜单管理',3,'com.ruoyi.web.controller.system.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/2017','127.0.0.1','内网IP','2017 ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 00:45:45',17),(141,'菜单管理',3,'com.ruoyi.web.controller.system.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/2016','127.0.0.1','内网IP','2016 ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 00:45:48',13),(142,'菜单管理',3,'com.ruoyi.web.controller.system.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/2014','127.0.0.1','内网IP','2014 ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 00:45:50',12),(143,'菜单管理',3,'com.ruoyi.web.controller.system.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/2015','127.0.0.1','内网IP','2015 ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 00:45:52',11),(144,'菜单管理',3,'com.ruoyi.web.controller.system.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/2013','127.0.0.1','内网IP','2013 ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 00:45:56',12),(145,'保存菜单排序',2,'com.ruoyi.web.controller.system.SysMenuController.updateSort()','PUT',1,'admin',NULL,'/system/menu/updateSort','127.0.0.1','内网IP','{\"menuIds\":\"2027\",\"orderNums\":\"3\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 00:46:13',18),(146,'保存菜单排序',2,'com.ruoyi.web.controller.system.SysMenuController.updateSort()','PUT',1,'admin',NULL,'/system/menu/updateSort','127.0.0.1','内网IP','{\"menuIds\":\"2001\",\"orderNums\":\"3\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 00:46:35',6),(147,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"icon\":\"tool\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2001,\"menuName\":\"GameClub管理\",\"menuType\":\"M\",\"orderNum\":3,\"params\":{},\"parentId\":0,\"path\":\"gameclub\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 00:47:36',25),(148,'角色管理',2,'com.ruoyi.web.controller.system.SysRoleController.edit()','PUT',1,'admin',NULL,'/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2026-06-07 22:27:01\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,103,1016,1017,1018,1019,104,1020,1021,1022,1023,1024,105,1025,1026,1027,1028,1029,106,1030,1031,1032,1033,1034,107,1035,1036,1037,1038,108,500,1039,1040,1041,501,1042,1043,1044,1045,2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114,3,115,116,1055,1056,1057,1058,1059,1060,117,4,2000],\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"普通角色\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 01:10:06',43),(149,'个人信息',2,'com.ruoyi.web.controller.system.SysProfileController.updateProfile()','PUT',1,'admin',NULL,'/system/user/profile','127.0.0.1','内网IP','{\"admin\":false,\"email\":\"2517487412@qq.com\",\"nickName\":\"YuKki\",\"params\":{},\"phonenumber\":\"15729728627\",\"sex\":\"0\"} ','{\"msg\":\"修改用户\'admin\'失败，手机号码已存在\",\"code\":500}',0,NULL,'2026-06-08 01:11:29',5),(150,'个人信息',2,'com.ruoyi.web.controller.system.SysProfileController.updateProfile()','PUT',1,'admin',NULL,'/system/user/profile','127.0.0.1','内网IP','{\"admin\":false,\"email\":\"2517487412@qq.com\",\"nickName\":\"YuKki\",\"params\":{},\"phonenumber\":\"15729728627\",\"sex\":\"0\"} ','{\"msg\":\"修改用户\'admin\'失败，手机号码已存在\",\"code\":500}',0,NULL,'2026-06-08 01:11:34',3),(151,'个人信息',2,'com.ruoyi.web.controller.system.SysProfileController.updateProfile()','PUT',1,'admin',NULL,'/system/user/profile','127.0.0.1','内网IP','{\"admin\":false,\"email\":\"2517487412@qq.com\",\"nickName\":\"YuKki\",\"params\":{},\"phonenumber\":\"15729728628\",\"sex\":\"0\"} ','{\"msg\":\"修改用户\'admin\'失败，邮箱账号已存在\",\"code\":500}',0,NULL,'2026-06-08 01:11:46',5),(152,'用户管理',3,'com.ruoyi.web.controller.system.SysUserController.remove()','DELETE',1,'admin',NULL,'/system/user/100','127.0.0.1','内网IP','[100] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 01:11:57',14),(153,'个人信息',2,'com.ruoyi.web.controller.system.SysProfileController.updateProfile()','PUT',1,'admin',NULL,'/system/user/profile','127.0.0.1','内网IP','{\"admin\":false,\"email\":\"2517487412@qq.com\",\"nickName\":\"YuKki\",\"params\":{},\"phonenumber\":\"15729728628\",\"sex\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 01:12:02',20),(154,'个人信息',2,'com.ruoyi.web.controller.system.SysProfileController.updateProfile()','PUT',1,'admin',NULL,'/system/user/profile','127.0.0.1','内网IP','{\"admin\":false,\"email\":\"2517487412@qq.com\",\"nickName\":\"YuKki\",\"params\":{},\"phonenumber\":\"15729728627\",\"sex\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 01:12:06',10),(155,'角色管理',2,'com.ruoyi.web.controller.system.SysRoleController.changeStatus()','PUT',1,'admin',NULL,'/system/role/changeStatus','127.0.0.1','内网IP','{\"admin\":true,\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":1,\"status\":\"1\"} ',NULL,1,'不允许操作超级管理员角色','2026-06-08 01:14:23',5),(156,'角色管理',2,'com.ruoyi.web.controller.system.SysRoleController.changeStatus()','PUT',1,'admin',NULL,'/system/role/changeStatus','127.0.0.1','内网IP','{\"admin\":false,\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":2,\"status\":\"1\",\"updateBy\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 01:14:26',7),(157,'角色管理',2,'com.ruoyi.web.controller.system.SysRoleController.changeStatus()','PUT',1,'admin',NULL,'/system/role/changeStatus','127.0.0.1','内网IP','{\"admin\":false,\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":2,\"status\":\"0\",\"updateBy\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 01:14:27',7),(158,'岗位管理',2,'com.ruoyi.web.controller.system.SysPostController.edit()','PUT',1,'admin',NULL,'/system/post','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2026-06-07 22:27:01\",\"flag\":false,\"params\":{},\"postCode\":\"GuildMaster\",\"postId\":1,\"postName\":\"工会会长1\",\"postSort\":1,\"remark\":\"\",\"status\":\"0\",\"updateBy\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 01:14:44',16),(159,'岗位管理',2,'com.ruoyi.web.controller.system.SysPostController.edit()','PUT',1,'admin',NULL,'/system/post','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2026-06-07 22:27:01\",\"flag\":false,\"params\":{},\"postCode\":\"GuildMaster\",\"postId\":1,\"postName\":\"工会会长\",\"postSort\":1,\"remark\":\"\",\"status\":\"0\",\"updateBy\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 01:14:58',9),(160,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"system/dict/index\",\"createTime\":\"2026-06-07 22:27:01\",\"icon\":\"dict\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":105,\"menuName\":\"字典管理\",\"menuType\":\"C\",\"orderNum\":6,\"params\":{},\"parentId\":1,\"path\":\"dict\",\"perms\":\"system:dict:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 01:37:36',17),(161,'岗位管理',1,'com.ruoyi.web.controller.system.SysPostController.add()','POST',1,'admin',NULL,'/system/post','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"flag\":false,\"params\":{},\"postCode\":\"0\",\"postId\":5,\"postName\":\"若依系统管理员\",\"postSort\":0,\"status\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 01:44:58',15),(162,'岗位管理',2,'com.ruoyi.web.controller.system.SysPostController.edit()','PUT',1,'admin',NULL,'/system/post','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2026-06-08 01:44:58\",\"flag\":false,\"params\":{},\"postCode\":\"SuperAdmin\",\"postId\":5,\"postName\":\"若依系统管理员\",\"postSort\":0,\"status\":\"0\",\"updateBy\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 01:45:19',8),(163,'岗位管理',2,'com.ruoyi.web.controller.system.SysPostController.edit()','PUT',1,'admin',NULL,'/system/post','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2026-06-08 01:44:58\",\"flag\":false,\"params\":{},\"postCode\":\"SuperAdmin\",\"postId\":5,\"postName\":\"若依系统管理员\",\"postSort\":5,\"status\":\"0\",\"updateBy\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 01:45:36',10),(164,'用户业务网站登记',0,'com.ruoyi.web.controller.system.SysUserDeptController.registerToWebsite()','POST',1,'admin',NULL,'/system/userDept/register/GAMECLUB','127.0.0.1','内网IP','\"GAMECLUB\" ',NULL,1,'\r\n### Error querying database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'ud.created_at\' in \'field list\'\r\n### The error may exist in URL [jar:nested:/D:/RpoJec/RuoYi-Vue/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.9.2.jar!/mapper/system/SysUserDeptMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.SysUserDeptMapper.selectByUserAndWebsite-Inline\r\n### The error occurred while setting parameters\r\n### SQL: SELECT ud.id, ud.user_id, ud.dept_id, ud.website_code,                ud.is_primary, ud.joined_at, ud.created_at, ud.updated_at,                d.dept_name,                wc.website_name         FROM sys_user_dept ud         LEFT JOIN sys_dept d ON ud.dept_id = d.dept_id         LEFT JOIN sys_website_config wc ON ud.website_code = wc.website_code               WHERE ud.user_id = ? AND ud.website_code = ?\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'ud.created_at\' in \'field list\'\n; bad SQL grammar []','2026-06-09 03:42:28',8),(165,'用户业务网站登记',0,'com.ruoyi.web.controller.system.SysUserDeptController.registerToWebsite()','POST',1,'admin',NULL,'/system/userDept/register/GAMECLUB','127.0.0.1','内网IP','\"GAMECLUB\" ','{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"createdAt\":\"2026-06-09 03:44:01\",\"deptId\":205,\"deptName\":\"无工会用户\",\"id\":4,\"isPrimary\":0,\"joinedAt\":\"2026-06-09 03:44:01\",\"params\":{},\"updatedAt\":\"2026-06-09 03:44:01\",\"userId\":1,\"websiteCode\":\"GAMECLUB\",\"websiteName\":\"GameClub游戏工会平台\"}}',0,NULL,'2026-06-09 03:44:01',21),(166,'用户业务网站登记',0,'com.ruoyi.web.controller.system.SysUserDeptController.registerToWebsite()','POST',1,'admin',NULL,'/system/userDept/register/GAMECLUB','127.0.0.1','内网IP','\"GAMECLUB\" ','{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"createdAt\":\"2026-06-09 03:44:01\",\"deptId\":205,\"deptName\":\"无工会用户\",\"id\":4,\"isPrimary\":0,\"joinedAt\":\"2026-06-09 03:44:01\",\"params\":{},\"updatedAt\":\"2026-06-09 03:44:01\",\"userId\":1,\"websiteCode\":\"GAMECLUB\",\"websiteName\":\"GameClub游戏工会平台\"}}',0,NULL,'2026-06-09 03:49:58',15),(167,'游戏分区',1,'com.ruoyi.web.controller.system.GamePartitionController.add()','POST',1,'admin',NULL,'/system/gamePartition','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"gameCode\":\"cf\",\"gameName\":\"1112\",\"params\":{},\"sortOrder\":6,\"status\":1} ',NULL,1,'\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\r\n### The error may exist in URL [jar:nested:/D:/RpoJec/RuoYi-Vue/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.9.2.jar!/mapper/gameclub/GamePartitionMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.GamePartitionMapper.insertGamePartition-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO game_partition (                            game_name,               game_code,                                           sort_order,               status,               create_by,              created_at         ) VALUES (                            ?,               ?,                                           ?,               ?,               ?,              NOW()         )\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\n; bad SQL grammar []','2026-06-09 03:52:36',447),(168,'游戏分区',1,'com.ruoyi.web.controller.system.GamePartitionController.add()','POST',1,'admin',NULL,'/system/gamePartition','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"gameCode\":\"cf\",\"gameName\":\"1112\",\"params\":{},\"sortOrder\":6,\"status\":1} ',NULL,1,'\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\r\n### The error may exist in URL [jar:nested:/D:/RpoJec/RuoYi-Vue/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.9.2.jar!/mapper/gameclub/GamePartitionMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.GamePartitionMapper.insertGamePartition-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO game_partition (                            game_name,               game_code,                                           sort_order,               status,               create_by,              created_at         ) VALUES (                            ?,               ?,                                           ?,               ?,               ?,              NOW()         )\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\n; bad SQL grammar []','2026-06-09 03:52:40',5),(169,'游戏分区',2,'com.ruoyi.web.controller.system.GamePartitionController.changeStatus()','PUT',1,'admin',NULL,'/system/gamePartition/changeStatus','127.0.0.1','内网IP','{\"id\":\"1\",\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-09 03:52:52',9),(170,'游戏分区',2,'com.ruoyi.web.controller.system.GamePartitionController.changeStatus()','PUT',1,'admin',NULL,'/system/gamePartition/changeStatus','127.0.0.1','内网IP','{\"id\":\"1\",\"status\":\"1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-09 03:53:08',5),(171,'游戏分区',1,'com.ruoyi.web.controller.system.GamePartitionController.add()','POST',1,'admin',NULL,'/system/gamePartition','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"gameCode\":\"1\",\"gameName\":\"1\",\"params\":{},\"sortOrder\":0,\"status\":1} ',NULL,1,'\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\r\n### The error may exist in URL [jar:nested:/D:/RpoJec/RuoYi-Vue/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.9.2.jar!/mapper/gameclub/GamePartitionMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.GamePartitionMapper.insertGamePartition-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO game_partition (                            game_name,               game_code,                                           sort_order,               status,               create_by,              created_at         ) VALUES (                            ?,               ?,                                           ?,               ?,               ?,              NOW()         )\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\n; bad SQL grammar []','2026-06-09 03:53:40',5),(172,'游戏分区',1,'com.ruoyi.web.controller.system.GamePartitionController.add()','POST',1,'admin',NULL,'/system/gamePartition','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"gameCode\":\"1\",\"gameName\":\"1\",\"params\":{},\"sortOrder\":0,\"status\":1} ',NULL,1,'\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\r\n### The error may exist in URL [jar:nested:/D:/RpoJec/RuoYi-Vue/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.9.2.jar!/mapper/gameclub/GamePartitionMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.GamePartitionMapper.insertGamePartition-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO game_partition (                            game_name,               game_code,                                           sort_order,               status,               create_by,              created_at         ) VALUES (                            ?,               ?,                                           ?,               ?,               ?,              NOW()         )\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\n; bad SQL grammar []','2026-06-09 04:08:56',6),(173,'工会',1,'com.ruoyi.web.controller.system.GuildController.add()','POST',1,'admin',NULL,'/system/guild','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"gamePartitionId\":1,\"id\":1,\"memberCount\":0,\"name\":\"114\",\"params\":{},\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-09 04:09:08',44),(174,'工会',3,'com.ruoyi.web.controller.system.GuildController.remove()','DELETE',1,'admin',NULL,'/system/guild/1','127.0.0.1','内网IP','[1] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-09 04:09:50',4),(175,'游戏分区',1,'com.ruoyi.web.controller.system.GamePartitionController.add()','POST',1,'admin',NULL,'/system/gamePartition','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"gameCode\":\"122\",\"gameName\":\"12\",\"params\":{},\"sortOrder\":0,\"status\":1} ',NULL,1,'\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\r\n### The error may exist in URL [jar:nested:/D:/RpoJec/RuoYi-Vue/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.9.2.jar!/mapper/gameclub/GamePartitionMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.GamePartitionMapper.insertGamePartition-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO game_partition (                            game_name,               game_code,                                           sort_order,               status,               create_by,              created_at         ) VALUES (                            ?,               ?,                                           ?,               ?,               ?,              NOW()         )\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\n; bad SQL grammar []','2026-06-09 04:25:46',6),(176,'游戏分区',1,'com.ruoyi.web.controller.system.GamePartitionController.add()','POST',1,'admin',NULL,'/system/gamePartition','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"gameCode\":\"122\",\"gameName\":\"12\",\"params\":{},\"sortOrder\":0,\"status\":1} ',NULL,1,'\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\r\n### The error may exist in URL [jar:nested:/D:/RpoJec/RuoYi-Vue/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.9.2.jar!/mapper/gameclub/GamePartitionMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.GamePartitionMapper.insertGamePartition-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO game_partition (                            game_name,               game_code,                                           sort_order,               status,               create_by,              created_at         ) VALUES (                            ?,               ?,                                           ?,               ?,               ?,              NOW()         )\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\n; bad SQL grammar []','2026-06-09 04:25:50',5),(177,'游戏分区',1,'com.ruoyi.web.controller.system.GamePartitionController.add()','POST',1,'admin',NULL,'/system/gamePartition','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"gameCode\":\"1\",\"gameName\":\"11\",\"params\":{},\"sortOrder\":0,\"status\":1} ',NULL,1,'\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\r\n### The error may exist in URL [jar:nested:/D:/RpoJec/RuoYi-Vue/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.9.2.jar!/mapper/gameclub/GamePartitionMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.GamePartitionMapper.insertGamePartition-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO game_partition (                            game_name,               game_code,                                           sort_order,               status,               create_by,              created_at         ) VALUES (                            ?,               ?,                                           ?,               ?,               ?,              NOW()         )\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\n; bad SQL grammar []','2026-06-09 04:26:53',5),(178,'游戏分区',1,'com.ruoyi.web.controller.system.GamePartitionController.add()','POST',1,'admin',NULL,'/system/gamePartition','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"deptId\":207,\"gameCode\":\"1\",\"gameName\":\"1\",\"id\":7,\"params\":{},\"sortOrder\":0,\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-09 10:05:25',38),(179,'游戏分区',3,'com.ruoyi.web.controller.system.GamePartitionController.remove()','DELETE',1,'admin',NULL,'/system/gamePartition/7','127.0.0.1','内网IP','[7] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-09 10:05:29',7),(180,'部门管理',3,'com.ruoyi.web.controller.system.SysDeptController.remove()','DELETE',1,'admin',NULL,'/system/dept/207','127.0.0.1','内网IP','207 ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-09 10:06:33',10),(181,'游戏分区',3,'com.ruoyi.web.controller.system.GamePartitionController.remove()','DELETE',1,'admin',NULL,'/system/gamePartition/6','127.0.0.1','内网IP','[6] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-09 12:43:58',20),(182,'工会',1,'com.ruoyi.web.controller.system.GuildController.add()','POST',1,'admin',NULL,'/system/guild','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"deptId\":208,\"gamePartitionId\":1,\"id\":2,\"memberCount\":0,\"name\":\"1145\",\"params\":{},\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-09 12:44:09',48),(183,'工会',3,'com.ruoyi.web.controller.system.GuildController.remove()','DELETE',1,'admin',NULL,'/system/guild/2','127.0.0.1','内网IP','[2] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-09 12:44:44',13),(184,'工会',1,'com.ruoyi.web.controller.system.GuildController.add()','POST',1,'admin',NULL,'/system/guild','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"deptId\":209,\"description\":\"1\",\"gamePartitionId\":1,\"id\":3,\"memberCount\":0,\"name\":\"1\",\"params\":{},\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-09 12:46:04',17),(185,'工会',3,'com.ruoyi.web.controller.system.GuildController.remove()','DELETE',1,'admin',NULL,'/system/guild/3','127.0.0.1','内网IP','[3] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-09 12:46:07',11),(186,'工会',1,'com.ruoyi.web.controller.system.GuildController.add()','POST',1,'admin',NULL,'/system/guild','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"deptId\":210,\"description\":\"1\",\"gamePartitionId\":1,\"id\":4,\"memberCount\":0,\"name\":\"1\",\"params\":{},\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-09 12:52:33',15),(187,'工会',3,'com.ruoyi.web.controller.system.GuildController.remove()','DELETE',1,'admin',NULL,'/system/guild/4','127.0.0.1','内网IP','[4] ','{\"msg\":\"操作失败\",\"code\":500}',0,NULL,'2026-06-09 12:52:59',3),(188,'工会',1,'com.ruoyi.web.controller.system.GuildController.add()','POST',1,'admin',NULL,'/system/guild','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"deptId\":211,\"description\":\"5\",\"gamePartitionId\":1,\"id\":5,\"memberCount\":0,\"name\":\"5\",\"params\":{},\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-09 12:53:07',16),(189,'工会',3,'com.ruoyi.web.controller.system.GuildController.remove()','DELETE',1,'admin',NULL,'/system/guild/5','127.0.0.1','内网IP','[5] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-09 12:53:40',18),(190,'工会',1,'com.ruoyi.web.controller.system.GuildController.add()','POST',1,'admin',NULL,'/system/guild','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"deptId\":212,\"gamePartitionId\":1,\"id\":6,\"memberCount\":0,\"name\":\"111\",\"params\":{},\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-09 13:04:58',164),(191,'工会',3,'com.ruoyi.web.controller.system.GuildController.remove()','DELETE',1,'admin',NULL,'/system/guild/6','127.0.0.1','内网IP','[6] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-09 13:05:14',16),(192,'游戏分区',1,'com.ruoyi.web.controller.system.GamePartitionController.add()','POST',1,'admin',NULL,'/system/gamePartition','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"deptId\":213,\"gameCode\":\"none\",\"gameName\":\"无工会\",\"id\":8,\"params\":{},\"sortOrder\":0,\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-10 00:48:38',44),(193,'工会',1,'com.ruoyi.web.controller.system.GuildController.add()','POST',1,'admin',NULL,'/system/guild','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"deptId\":217,\"gamePartitionId\":5,\"id\":7,\"memberCount\":0,\"name\":\"121\",\"params\":{},\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-10 01:30:48',235),(194,'游戏分区',3,'com.ruoyi.web.controller.system.GamePartitionController.remove()','DELETE',1,'admin',NULL,'/system/gamePartition/5','127.0.0.1','内网IP','[5] ',NULL,1,'\r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Cannot delete or update a parent row: a foreign key constraint fails (`ry_vue`.`guild`, CONSTRAINT `fk_guild_partition` FOREIGN KEY (`game_partition_id`) REFERENCES `game_partition` (`id`))\r\n### The error may exist in URL [jar:file:/C:/Users/25174/.m2/repository/com/ruoyi/ruoyi-system/3.9.2/ruoyi-system-3.9.2.jar!/mapper/gameclub/GamePartitionMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.GamePartitionMapper.deleteGamePartitionById-Inline\r\n### The error occurred while setting parameters\r\n### SQL: DELETE FROM game_partition WHERE id = ?\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Cannot delete or update a parent row: a foreign key constraint fails (`ry_vue`.`guild`, CONSTRAINT `fk_guild_partition` FOREIGN KEY (`game_partition_id`) REFERENCES `game_partition` (`id`))\n; Cannot delete or update a parent row: a foreign key constraint fails (`ry_vue`.`guild`, CONSTRAINT `fk_guild_partition` FOREIGN KEY (`game_partition_id`) REFERENCES `game_partition` (`id`))','2026-06-10 01:49:09',482),(195,'工会',3,'com.ruoyi.web.controller.system.GuildController.remove()','DELETE',1,'admin',NULL,'/system/guild/7','127.0.0.1','内网IP','[7] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-10 01:49:16',41),(196,'游戏分区',3,'com.ruoyi.web.controller.system.GamePartitionController.remove()','DELETE',1,'admin',NULL,'/system/gamePartition/5','127.0.0.1','内网IP','[5] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-10 01:49:20',8),(197,'游戏分区',3,'com.ruoyi.web.controller.system.GamePartitionController.remove()','DELETE',1,'admin',NULL,'/system/gamePartition/8','127.0.0.1','内网IP','[8] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-10 01:49:51',11),(198,'游戏分区',1,'com.ruoyi.web.controller.system.GamePartitionController.add()','POST',1,'admin','网站汇总','/system/gamePartition','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"gameCode\":\"lol\",\"gameName\":\"英雄联盟\",\"params\":{},\"sortOrder\":0,\"status\":1} ',NULL,1,'游戏编码已存在，请重新输入！','2026-06-10 03:09:15',16),(199,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','网站汇总','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"icon\":\"tool\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2001,\"menuName\":\"GameClub管理\",\"menuType\":\"M\",\"orderNum\":3,\"params\":{},\"parentId\":0,\"path\":\"gameclub\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-13 14:40:04',35),(200,'游戏分区',1,'com.ruoyi.web.controller.system.GamePartitionController.add()','POST',1,'admin','网站汇总','/system/gamePartition','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"gameCode\":\"lol\",\"gameName\":\"英雄联盟\",\"params\":{},\"sortOrder\":0,\"status\":1} ',NULL,1,'游戏编码已存在，请重新输入！','2026-06-13 15:44:04',29),(201,'工会',1,'com.ruoyi.web.controller.system.GuildController.add()','POST',1,'admin','网站汇总','/system/guild','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"deptId\":218,\"gamePartitionId\":1,\"id\":8,\"memberCount\":0,\"name\":\"YuKki工会\",\"params\":{},\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-13 15:52:02',35),(202,'角色管理',4,'com.ruoyi.web.controller.system.SysRoleController.selectAuthUserAll()','PUT',1,'admin','网站汇总','/system/role/authUser/selectAll','127.0.0.1','内网IP','{\"roleId\":\"2\",\"userIds\":\"3\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-13 16:13:48',27),(203,'角色管理',2,'com.ruoyi.web.controller.system.SysRoleController.dataScope()','PUT',1,'admin','网站汇总','/system/role/dataScope','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2026-06-07 22:27:01\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":false,\"deptIds\":[100],\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"普通角色\",\"roleSort\":2,\"status\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-13 16:15:09',47),(204,'角色管理',2,'com.ruoyi.web.controller.system.SysRoleController.edit()','PUT',1,'admin','网站汇总','/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2026-06-07 22:27:01\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"menuIds\":[100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,103,1016,1017,1018,1019,104,1020,1021,1022,1023,1024,105,1025,1026,1027,1028,1029,106,1030,1031,1032,1033,1034,107,1035,1036,1037,1038,108,500,1039,1040,1041,501,1042,1043,1044,1045,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114,115,116,1055,1056,1057,1058,1059,1060,117,4,2000],\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"普通角色\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-13 16:15:16',24),(205,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','网站汇总','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2026-06-07 22:56:42\",\"icon\":\"guide\",\"isCache\":\"0\",\"isFrame\":\"0\",\"menuId\":2000,\"menuName\":\"GameClub\",\"menuType\":\"M\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"http://localhost:80/gameclub-portal\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 14:26:41',44),(206,'工会申请',2,'com.ruoyi.web.controller.system.GuildApplicationController.approve()','PUT',1,'admin','网站汇总','/system/guildApplication/approve','127.0.0.1','内网IP','{\"id\":1,\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 15:21:46',24),(207,'工会申请',2,'com.ruoyi.web.controller.system.GuildApplicationController.approve()','PUT',1,'admin','网站汇总','/system/guildApplication/approve','127.0.0.1','内网IP','{\"id\":2,\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 16:05:59',22),(208,'工会成员',2,'com.ruoyi.web.controller.system.GuildMemberController.edit()','PUT',1,'admin','网站汇总','/system/guildMember','127.0.0.1','内网IP','{\"createdAt\":\"2026-06-14 16:00:43\",\"gamePartitionId\":1,\"gamePartitionName\":\"英雄联盟\",\"guildId\":8,\"guildName\":\"YuKki工会\",\"id\":1,\"joinTime\":\"2026-06-14 16:00:43\",\"nickName\":\"YuKki\",\"params\":{},\"role\":1,\"status\":1,\"updatedAt\":\"2026-06-14 16:00:43\",\"userId\":1,\"userName\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 16:07:09',10),(209,'工会成员',2,'com.ruoyi.web.controller.system.GuildMemberController.edit()','PUT',1,'admin','网站汇总','/system/guildMember','127.0.0.1','内网IP','{\"createdAt\":\"2026-06-14 16:00:43\",\"gamePartitionId\":1,\"gamePartitionName\":\"英雄联盟\",\"guildId\":8,\"guildName\":\"YuKki工会\",\"id\":1,\"joinTime\":\"2026-06-14 16:00:43\",\"nickName\":\"YuKki\",\"params\":{},\"role\":2,\"status\":1,\"updatedAt\":\"2026-06-14 16:07:09\",\"userId\":1,\"userName\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 16:07:14',7),(210,'工会成员',2,'com.ruoyi.web.controller.system.GuildMemberController.edit()','PUT',1,'admin','网站汇总','/system/guildMember','127.0.0.1','内网IP','{\"createdAt\":\"2026-06-14 16:00:43\",\"gamePartitionId\":1,\"gamePartitionName\":\"英雄联盟\",\"guildId\":8,\"guildName\":\"YuKki工会\",\"id\":1,\"joinTime\":\"2026-06-14 16:00:43\",\"nickName\":\"YuKki\",\"params\":{},\"role\":1,\"status\":1,\"updatedAt\":\"2026-06-14 16:07:14\",\"userId\":1,\"userName\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 16:07:17',6),(211,'工会成员',2,'com.ruoyi.web.controller.system.GuildMemberController.edit()','PUT',1,'admin','网站汇总','/system/guildMember','127.0.0.1','内网IP','{\"createdAt\":\"2026-06-14 16:00:43\",\"gamePartitionId\":1,\"gamePartitionName\":\"英雄联盟\",\"guildId\":8,\"guildName\":\"YuKki工会\",\"id\":1,\"joinTime\":\"2026-06-14 16:00:43\",\"nickName\":\"YuKki\",\"params\":{},\"role\":3,\"status\":1,\"updatedAt\":\"2026-06-14 16:07:17\",\"userId\":1,\"userName\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 16:07:35',10),(212,'工会申请',2,'com.ruoyi.web.controller.system.GuildApplicationController.approve()','PUT',1,'admin','网站汇总','/system/guildApplication/approve','127.0.0.1','内网IP','{\"id\":3,\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 16:33:42',27),(213,'工会成员',2,'com.ruoyi.web.controller.system.GuildMemberController.edit()','PUT',1,'admin','网站汇总','/system/guildMember','127.0.0.1','内网IP','{\"createdAt\":\"2026-06-14 16:00:43\",\"gamePartitionId\":1,\"gamePartitionName\":\"英雄联盟\",\"guildId\":8,\"guildName\":\"YuKki工会\",\"id\":1,\"joinTime\":\"2026-06-14 16:00:43\",\"nickName\":\"YuKki\",\"params\":{},\"role\":1,\"status\":1,\"updatedAt\":\"2026-06-14 16:07:35\",\"userId\":1,\"userName\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 16:34:37',11),(214,'工会成员',2,'com.ruoyi.web.controller.system.GuildMemberController.edit()','PUT',1,'admin','网站汇总','/system/guildMember','127.0.0.1','内网IP','{\"createdAt\":\"2026-06-14 16:36:46\",\"gamePartitionId\":1,\"gamePartitionName\":\"英雄联盟\",\"guildId\":8,\"guildName\":\"YuKki工会\",\"id\":6,\"joinTime\":\"2026-06-14 16:36:46\",\"nickName\":\"sk\",\"params\":{},\"role\":2,\"status\":1,\"updatedAt\":\"2026-06-14 16:36:46\",\"userId\":3,\"userName\":\"sk\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 16:41:05',10),(215,'工会成员',3,'com.ruoyi.web.controller.system.GuildMemberController.remove()','DELETE',1,'admin','网站汇总','/system/guildMember/5','127.0.0.1','内网IP','[5] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 16:52:59',54),(216,'工会成员',2,'com.ruoyi.web.controller.system.GuildMemberController.edit()','PUT',1,'admin','网站汇总','/system/guildMember','127.0.0.1','内网IP','{\"createdAt\":\"2026-06-14 16:36:46\",\"gamePartitionId\":1,\"gamePartitionName\":\"英雄联盟\",\"guildId\":8,\"guildName\":\"YuKki工会\",\"id\":6,\"joinTime\":\"2026-06-14 16:36:46\",\"nickName\":\"sk\",\"params\":{},\"role\":3,\"status\":1,\"updatedAt\":\"2026-06-14 16:41:05\",\"userId\":3,\"userName\":\"sk\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 17:03:33',28),(217,'工会成员',3,'com.ruoyi.web.controller.system.GuildMemberController.remove()','DELETE',1,'admin','网站汇总','/system/guildMember/6','127.0.0.1','内网IP','[6] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 17:03:35',47),(218,'工会成员',1,'com.ruoyi.web.controller.system.GuildMemberController.add()','POST',1,'admin','YuKki工会','/system/guildMember','127.0.0.1','内网IP','{\"gamePartitionId\":1,\"guildId\":8,\"id\":7,\"joinTime\":\"2026-06-14 19:02:58\",\"params\":{},\"role\":3,\"status\":1,\"userId\":3} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 19:02:59',208),(219,'工会成员',1,'com.ruoyi.web.controller.system.GuildMemberController.add()','POST',1,'admin','YuKki工会','/system/guildMember','127.0.0.1','内网IP','{\"gamePartitionId\":1,\"guildId\":8,\"id\":8,\"joinTime\":\"2026-06-14 19:03:06\",\"params\":{},\"role\":3,\"status\":1,\"userId\":2} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 19:03:06',47),(220,'工会成员',3,'com.ruoyi.web.controller.system.GuildMemberController.remove()','DELETE',1,'admin','YuKki工会','/system/guildMember/8','127.0.0.1','内网IP','[8] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 19:03:29',45),(221,'工会成员',2,'com.ruoyi.web.controller.system.GuildMemberController.edit()','PUT',1,'admin','YuKki工会','/system/guildMember','127.0.0.1','内网IP','{\"createdAt\":\"2026-06-14 19:02:58\",\"gamePartitionId\":1,\"gamePartitionName\":\"英雄联盟\",\"guildId\":8,\"guildName\":\"YuKki工会\",\"id\":7,\"joinTime\":\"2026-06-14 19:02:59\",\"nickName\":\"sk\",\"params\":{},\"role\":4,\"status\":1,\"updatedAt\":\"2026-06-14 19:02:58\",\"userId\":3,\"userName\":\"sk\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 19:04:12',5),(222,'工会成员',2,'com.ruoyi.web.controller.system.GuildMemberController.edit()','PUT',1,'admin','YuKki工会','/system/guildMember','127.0.0.1','内网IP','{\"createdAt\":\"2026-06-14 19:02:58\",\"gamePartitionId\":1,\"gamePartitionName\":\"英雄联盟\",\"guildId\":8,\"guildName\":\"YuKki工会\",\"id\":7,\"joinTime\":\"2026-06-14 19:02:59\",\"nickName\":\"sk\",\"params\":{},\"role\":3,\"status\":1,\"updatedAt\":\"2026-06-14 19:04:11\",\"userId\":3,\"userName\":\"sk\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 19:04:29',5),(223,'用户管理',2,'com.ruoyi.web.controller.system.SysUserController.edit()','PUT',1,'admin','YuKki工会','/system/user','127.0.0.1','内网IP','{\"admin\":false,\"avatar\":\"\",\"createBy\":\"\",\"createTime\":\"2026-06-14 19:40:57\",\"delFlag\":\"0\",\"dept\":{\"ancestors\":\"\",\"children\":[],\"deptId\":100,\"deptName\":\"网站汇总\",\"leader\":\"YuKki\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"status\":\"0\"},\"deptId\":100,\"email\":\"157166879@qq.com\",\"loginDate\":\"2026-06-14 19:41:12\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"肝帝\",\"params\":{},\"phonenumber\":\"\",\"postIds\":[],\"pwdUpdateDate\":\"2026-06-14 19:40:58\",\"roleIds\":[2],\"roles\":[],\"sex\":\"0\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":102,\"userName\":\"肝帝\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 19:46:34',36),(224,'工会任务',1,'com.ruoyi.web.controller.system.GuildTaskController.add()','POST',1,'admin','YuKki工会','/system/guildTask','127.0.0.1','内网IP','{\"currentPlayers\":0,\"description\":\"随便玩玩\",\"endTime\":\"2026-06-14 22:00:00\",\"guildId\":8,\"joinDeadline\":\"2026-06-14 21:00:00\",\"maxPlayers\":3,\"minPlayers\":1,\"name\":\"First\",\"params\":{},\"publisherId\":1,\"status\":1,\"type\":1} ',NULL,1,'\r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'game_partition_id\' cannot be null\r\n### The error may exist in URL [jar:nested:/D:/RpoJec/RuoYi-Vue/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.9.2.jar!/mapper/gameclub/GuildTaskMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.GuildTaskMapper.insertGuildTask-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO guild_task (guild_id, game_partition_id, publisher_id, name, type, description, image, task_mode, min_players, max_players, start_time, join_deadline, end_time, status, created_at)         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'game_partition_id\' cannot be null\n; Column \'game_partition_id\' cannot be null','2026-06-14 20:04:32',567),(225,'工会任务',1,'com.ruoyi.web.controller.system.GuildTaskController.add()','POST',1,'admin','YuKki工会','/system/guildTask','127.0.0.1','内网IP','{\"currentPlayers\":0,\"endTime\":\"2026-06-15 00:00:00\",\"guildId\":8,\"joinDeadline\":\"2026-06-15 00:00:00\",\"maxPlayers\":3,\"minPlayers\":1,\"name\":\"1\",\"params\":{},\"publisherId\":1,\"status\":1,\"type\":1} ',NULL,1,'\r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'game_partition_id\' cannot be null\r\n### The error may exist in URL [jar:nested:/D:/RpoJec/RuoYi-Vue/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.9.2.jar!/mapper/gameclub/GuildTaskMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.GuildTaskMapper.insertGuildTask-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO guild_task (guild_id, game_partition_id, publisher_id, name, type, description, image, task_mode, min_players, max_players, start_time, join_deadline, end_time, status, created_at)         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'game_partition_id\' cannot be null\n; Column \'game_partition_id\' cannot be null','2026-06-14 20:05:42',3),(226,'工会任务',1,'com.ruoyi.web.controller.system.GuildTaskController.add()','POST',1,'admin','YuKki工会','/system/guildTask','127.0.0.1','内网IP','{\"currentPlayers\":0,\"description\":\"第一个任务\",\"endTime\":\"2026-06-14 22:00:00\",\"gamePartitionId\":1,\"guildId\":8,\"id\":1,\"joinDeadline\":\"2026-06-14 21:00:00\",\"maxPlayers\":3,\"minPlayers\":1,\"name\":\"First\",\"params\":{},\"publisherId\":1,\"status\":1,\"type\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 20:10:01',168),(227,'工会任务',3,'com.ruoyi.web.controller.system.GuildTaskController.remove()','DELETE',1,'admin','YuKki工会','/system/guildTask/1','127.0.0.1','内网IP','[1] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 20:10:17',6),(228,'工会申请',2,'com.ruoyi.web.controller.system.GuildApplicationController.approve()','PUT',1,'admin','YuKki工会','/system/guildApplication/approve','127.0.0.1','内网IP','{\"id\":5,\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 20:19:19',26),(229,'工会申请',2,'com.ruoyi.web.controller.system.GuildApplicationController.approve()','PUT',1,'admin','YuKki工会','/system/guildApplication/approve','127.0.0.1','内网IP','{\"id\":4,\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 20:31:02',5),(230,'工会申请',2,'com.ruoyi.web.controller.system.GuildApplicationController.approve()','PUT',1,'admin','YuKki工会','/system/guildApplication/approve','127.0.0.1','内网IP','{\"id\":7,\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-15 00:23:14',23),(231,'工会申请',2,'com.ruoyi.web.controller.system.GuildApplicationController.approve()','PUT',1,'admin','YuKki工会','/system/guildApplication/approve','127.0.0.1','内网IP','{\"id\":6,\"status\":2} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-15 00:28:41',34),(232,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','YuKki工会','/system/menu','192.168.2.55','内网IP','{\"children\":[],\"createTime\":\"2026-06-07 22:56:42\",\"icon\":\"guide\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2000,\"menuName\":\"GameClub\",\"menuType\":\"M\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"/gameclub-portal\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-15 00:29:23',23),(233,'工会申请',2,'com.ruoyi.web.controller.system.GuildApplicationController.approve()','PUT',1,'admin','YuKki工会','/system/guildApplication/approve','127.0.0.1','内网IP','{\"id\":8,\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-15 00:30:31',7),(234,'工会成员',2,'com.ruoyi.web.controller.system.GuildMemberController.changeRole()','PUT',1,'admin','YuKki工会','/system/guildMember/changeRole','127.0.0.1','内网IP','{\"role\":\"2\",\"id\":\"13\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-15 00:42:32',20),(235,'工会成员',2,'com.ruoyi.web.controller.system.GuildMemberController.changeRole()','PUT',1,'admin','YuKki工会','/system/guildMember/changeRole','127.0.0.1','内网IP','{\"role\":\"2\",\"id\":\"12\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-15 00:46:08',7),(236,'工会成员',2,'com.ruoyi.web.controller.system.GuildMemberController.changeRole()','PUT',1,'admin','YuKki工会','/system/guildMember/changeRole','127.0.0.1','内网IP','{\"role\":\"3\",\"id\":\"13\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-15 00:48:13',6),(237,'工会成员',2,'com.ruoyi.web.controller.system.GuildMemberController.changeRole()','PUT',1,'admin','YuKki工会','/system/guildMember/changeRole','127.0.0.1','内网IP','{\"role\":\"2\",\"id\":\"13\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-15 00:48:22',7),(238,'游戏分区',1,'com.ruoyi.web.controller.system.GamePartitionController.add()','POST',1,'admin','YuKki工会','/system/gamePartition','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"deptId\":219,\"gameCode\":\"wzry\",\"gameName\":\"王者荣耀\",\"id\":9,\"params\":{},\"sortOrder\":5,\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-15 21:07:26',246),(239,'工会',1,'com.ruoyi.web.controller.system.GuildController.add()','POST',1,'admin','YuKki工会','/system/guild','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"deptId\":220,\"gamePartitionId\":9,\"id\":9,\"memberCount\":0,\"name\":\"亡者工会\",\"params\":{},\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-15 21:09:20',230),(240,'部门管理',3,'com.ruoyi.web.controller.system.SysDeptController.remove()','DELETE',1,'admin','YuKki工会','/system/dept/203','127.0.0.1','内网IP','203 ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-15 21:10:31',12),(241,'工会申请',2,'com.ruoyi.web.controller.system.GuildApplicationController.approve()','PUT',1,'admin','YuKki工会','/system/guildApplication/approve','127.0.0.1','内网IP','{\"id\":12,\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-15 21:20:50',26),(242,'工会',3,'com.ruoyi.web.controller.system.GuildController.remove()','DELETE',1,'admin','YuKki工会','/system/guild/10','127.0.0.1','内网IP','[10] ',NULL,1,'\r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Cannot delete or update a parent row: a foreign key constraint fails (`ry_vue`.`guild_member`, CONSTRAINT `fk_member_guild` FOREIGN KEY (`guild_id`) REFERENCES `guild` (`id`))\r\n### The error may exist in URL [jar:file:/C:/Users/25174/.m2/repository/com/ruoyi/ruoyi-system/3.9.2/ruoyi-system-3.9.2.jar!/mapper/gameclub/GuildMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.GuildMapper.deleteGuildById-Inline\r\n### The error occurred while setting parameters\r\n### SQL: DELETE FROM guild WHERE id = ?\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Cannot delete or update a parent row: a foreign key constraint fails (`ry_vue`.`guild_member`, CONSTRAINT `fk_member_guild` FOREIGN KEY (`guild_id`) REFERENCES `guild` (`id`))\n; Cannot delete or update a parent row: a foreign key constraint fails (`ry_vue`.`guild_member`, CONSTRAINT `fk_member_guild` FOREIGN KEY (`guild_id`) REFERENCES `guild` (`id`))','2026-06-15 22:05:06',435),(243,'工会成员',3,'com.ruoyi.web.controller.system.GuildMemberController.remove()','DELETE',1,'admin','YuKki工会','/system/guildMember/18','127.0.0.1','内网IP','[18] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-15 22:05:20',19),(244,'工会',3,'com.ruoyi.web.controller.system.GuildController.remove()','DELETE',1,'admin','YuKki工会','/system/guild/10','127.0.0.1','内网IP','[10] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-15 22:05:26',11);
/*!40000 ALTER TABLE `sys_oper_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_post`
--

DROP TABLE IF EXISTS `sys_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_post` (
  `post_id` bigint NOT NULL AUTO_INCREMENT COMMENT '职称ID',
  `post_code` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='岗位信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_post`
--

LOCK TABLES `sys_post` WRITE;
/*!40000 ALTER TABLE `sys_post` DISABLE KEYS */;
INSERT INTO `sys_post` VALUES (1,'GuildMaster','工会会长',1,'0','admin','2026-06-07 22:27:01','admin','2026-06-08 01:14:58',''),(2,'GuildAdmin','工会管理员',2,'0','admin','2026-06-07 22:27:01','',NULL,''),(3,'GuildMember','工会成员',3,'0','admin','2026-06-07 22:27:01','',NULL,''),(4,'NormalUser','无工会用户',4,'0','admin','2026-06-07 22:27:01','',NULL,''),(5,'SuperAdmin','若依系统管理员',5,'0','admin','2026-06-08 01:44:58','admin','2026-06-08 01:45:36',NULL);
/*!40000 ALTER TABLE `sys_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role`
--

DROP TABLE IF EXISTS `sys_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role` (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) DEFAULT '1' COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) DEFAULT '1' COMMENT '部门树选择项是否关联显示',
  `status` char(1) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role`
--

LOCK TABLES `sys_role` WRITE;
/*!40000 ALTER TABLE `sys_role` DISABLE KEYS */;
INSERT INTO `sys_role` VALUES (1,'超级管理员','admin',1,'1',1,1,'0','0','admin','2026-06-07 22:27:01','',NULL,'超级管理员'),(2,'普通角色','common',2,'2',0,0,'0','0','admin','2026-06-07 22:27:01','admin','2026-06-13 16:15:16','普通角色');
/*!40000 ALTER TABLE `sys_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_dept`
--

DROP TABLE IF EXISTS `sys_role_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_dept` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`,`dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色和部门关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_dept`
--

LOCK TABLES `sys_role_dept` WRITE;
/*!40000 ALTER TABLE `sys_role_dept` DISABLE KEYS */;
INSERT INTO `sys_role_dept` VALUES (1,100),(1,201),(2,100);
/*!40000 ALTER TABLE `sys_role_dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_menu`
--

DROP TABLE IF EXISTS `sys_role_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_menu` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`,`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色和菜单关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_menu`
--

LOCK TABLES `sys_role_menu` WRITE;
/*!40000 ALTER TABLE `sys_role_menu` DISABLE KEYS */;
INSERT INTO `sys_role_menu` VALUES (1,2000),(1,2001),(1,2002),(1,2003),(1,2004),(1,2005),(1,2006),(1,2007),(1,2008),(1,2009),(1,2010),(1,2011),(1,2012),(1,2018),(1,2019),(1,2020),(1,2021),(1,2022),(1,2023),(1,2024),(1,2025),(1,2026),(1,2027),(1,2028),(1,2029),(1,2030),(1,2031),(1,2032),(1,2033),(1,2034),(1,2035),(1,2036),(1,2037),(1,2038),(1,2039),(1,2040),(2,4),(2,100),(2,101),(2,102),(2,103),(2,104),(2,105),(2,106),(2,107),(2,108),(2,109),(2,110),(2,111),(2,112),(2,113),(2,114),(2,115),(2,116),(2,117),(2,500),(2,501),(2,1000),(2,1001),(2,1002),(2,1003),(2,1004),(2,1005),(2,1006),(2,1007),(2,1008),(2,1009),(2,1010),(2,1011),(2,1012),(2,1013),(2,1014),(2,1015),(2,1016),(2,1017),(2,1018),(2,1019),(2,1020),(2,1021),(2,1022),(2,1023),(2,1024),(2,1025),(2,1026),(2,1027),(2,1028),(2,1029),(2,1030),(2,1031),(2,1032),(2,1033),(2,1034),(2,1035),(2,1036),(2,1037),(2,1038),(2,1039),(2,1040),(2,1041),(2,1042),(2,1043),(2,1044),(2,1045),(2,1046),(2,1047),(2,1048),(2,1049),(2,1050),(2,1051),(2,1052),(2,1053),(2,1054),(2,1055),(2,1056),(2,1057),(2,1058),(2,1059),(2,1060),(2,2000),(2,2002),(2,2003),(2,2008),(2,2009),(2,2021),(2,2022),(2,2037),(2,2038);
/*!40000 ALTER TABLE `sys_role_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user`
--

DROP TABLE IF EXISTS `sys_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user` (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '手机号码',
  `sex` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '密码',
  `status` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime DEFAULT NULL COMMENT '最后登录时间',
  `pwd_update_date` datetime DEFAULT NULL COMMENT '密码最后更新时间',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user`
--

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;
INSERT INTO `sys_user` VALUES (1,204,'admin','YuKki','00','2517487412@qq.com','15729728627','0','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','127.0.0.1','2026-06-22 20:48:19','2026-06-07 22:27:01','admin','2026-06-07 22:27:01','','2026-06-08 01:12:06','管理员'),(2,205,'ry','若依','00','ry@qq.com','15666666666','1','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','127.0.0.1','2026-06-14 19:38:48','2026-06-07 22:27:01','admin','2026-06-07 22:27:01','','2026-06-14 19:03:28','测试员'),(3,205,'sk','sk','00','','15555555555','0','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','127.0.0.1','2026-06-15 21:44:31',NULL,'',NULL,'','2026-06-15 22:05:20',NULL),(102,100,'肝帝','肝帝','00','157166879@qq.com','','0','','$2a$10$WpYBlxbr4TQBcoulotmL5OgqHxio/qPoasfluTNovBN1rY2LHWoJO','0','0','192.168.2.80','2026-06-16 16:32:35','2026-06-14 19:40:58','','2026-06-14 19:40:57','admin','2026-06-14 19:46:34',NULL),(103,100,'happypuppy','happypuppy','00','2889506632@qq.com','','0','','$2a$10$BySbfgiBV/VUZHnBAGuoouYYFf7.wzOObPr2BYbe1UZAMCG1Z30Fu','0','0','192.168.2.115','2026-06-15 00:49:02','2026-06-15 00:08:36','','2026-06-15 00:08:35','',NULL,NULL);
/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_dept`
--

DROP TABLE IF EXISTS `sys_user_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_dept` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `dept_id` bigint NOT NULL,
  `website_code` varchar(50) NOT NULL,
  `is_primary` tinyint DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `joined_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_website` (`user_id`,`website_code`),
  KEY `idx_dept_id` (`dept_id`),
  KEY `idx_website_code` (`website_code`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_dept`
--

LOCK TABLES `sys_user_dept` WRITE;
/*!40000 ALTER TABLE `sys_user_dept` DISABLE KEYS */;
INSERT INTO `sys_user_dept` VALUES (1,1,100,'DEFAULT',1,'2026-06-09 03:43:29','2026-06-09 03:15:16','2026-06-09 03:15:16'),(2,2,100,'DEFAULT',1,'2026-06-09 03:43:29','2026-06-09 03:15:16','2026-06-09 03:15:16'),(4,1,204,'GAMECLUB',0,'2026-06-09 03:44:01','2026-06-09 03:44:01','2026-06-14 16:44:11'),(5,2,205,'GAMECLUB',0,'2026-06-14 16:43:58','2026-06-14 16:43:58','2026-06-14 19:03:28'),(6,3,205,'GAMECLUB',0,'2026-06-14 16:43:58','2026-06-14 16:43:58','2026-06-15 22:05:20'),(7,102,100,'DEFAULT',1,'2026-06-14 19:40:57','2026-06-14 19:40:58','2026-06-14 19:40:57'),(8,103,100,'DEFAULT',1,'2026-06-15 00:08:35','2026-06-15 00:08:36','2026-06-15 00:08:35');
/*!40000 ALTER TABLE `sys_user_dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_post`
--

DROP TABLE IF EXISTS `sys_user_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_post` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`,`post_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户与岗位关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_post`
--

LOCK TABLES `sys_user_post` WRITE;
/*!40000 ALTER TABLE `sys_user_post` DISABLE KEYS */;
INSERT INTO `sys_user_post` VALUES (1,1),(2,4),(3,4);
/*!40000 ALTER TABLE `sys_user_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_role`
--

DROP TABLE IF EXISTS `sys_user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_role` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户和角色关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_role`
--

LOCK TABLES `sys_user_role` WRITE;
/*!40000 ALTER TABLE `sys_user_role` DISABLE KEYS */;
INSERT INTO `sys_user_role` VALUES (1,1),(2,1),(3,2),(102,2),(103,2);
/*!40000 ALTER TABLE `sys_user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_website_config`
--

DROP TABLE IF EXISTS `sys_website_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_website_config` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `website_code` varchar(50) NOT NULL,
  `website_name` varchar(100) NOT NULL,
  `root_dept_id` bigint NOT NULL,
  `default_dept_id` bigint NOT NULL,
  `status` char(1) DEFAULT '0',
  `remark` varchar(500) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_website_code` (`website_code`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_website_config`
--

LOCK TABLES `sys_website_config` WRITE;
/*!40000 ALTER TABLE `sys_website_config` DISABLE KEYS */;
INSERT INTO `sys_website_config` VALUES (1,'DEFAULT','网站汇总主站点',100,100,'0','若依系统主站点，所有用户的默认归属','2026-06-09 03:15:02','2026-06-09 03:15:02'),(2,'GAMECLUB','GameClub游戏工会平台',201,205,'0','GameClub游戏工会系统，新用户默认进入无工会用户区','2026-06-09 03:15:02','2026-06-09 03:15:02');
/*!40000 ALTER TABLE `sys_website_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_participant`
--

DROP TABLE IF EXISTS `task_participant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_participant` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `task_id` bigint NOT NULL COMMENT '任务ID',
  `user_id` bigint NOT NULL COMMENT '参与用户ID',
  `status` tinyint DEFAULT '1' COMMENT '状态：1-已接单 2-已放弃 3-已完成',
  `join_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '接单时间',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_task_user` (`task_id`,`user_id`),
  KEY `idx_user` (`user_id`),
  CONSTRAINT `fk_participant_task` FOREIGN KEY (`task_id`) REFERENCES `guild_task` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='任务参与表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_participant`
--

LOCK TABLES `task_participant` WRITE;
/*!40000 ALTER TABLE `task_participant` DISABLE KEYS */;
INSERT INTO `task_participant` VALUES (5,5,1,1,'2026-06-15 01:37:59','2026-06-15 01:37:59'),(6,5,3,1,'2026-06-15 01:38:27','2026-06-15 01:38:27'),(7,6,1,1,'2026-06-16 16:35:47','2026-06-16 16:35:47'),(8,6,102,1,'2026-06-16 16:36:05','2026-06-16 16:36:05');
/*!40000 ALTER TABLE `task_participant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_notification`
--

DROP TABLE IF EXISTS `user_notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_notification` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '消息ID',
  `user_id` bigint NOT NULL COMMENT '接收用户ID',
  `game_partition_id` bigint DEFAULT NULL COMMENT '所属游戏分区ID',
  `guild_id` bigint DEFAULT NULL COMMENT '所属工会ID',
  `type` tinyint NOT NULL COMMENT '消息类型：1-入会申请结果 2-任务状态变更 3-身份任免 4-被踢通知 5-拉黑通知 6-系统通知',
  `title` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '消息标题',
  `content` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '消息内容',
  `is_read` tinyint DEFAULT '0' COMMENT '是否已读：0-未读 1-已读',
  `related_id` bigint DEFAULT NULL COMMENT '关联ID（如申请ID、任务ID等）',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_is_read` (`is_read`),
  KEY `idx_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户消息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_notification`
--

LOCK TABLES `user_notification` WRITE;
/*!40000 ALTER TABLE `user_notification` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Current Database: `ry_vue`
--

/*!40000 DROP DATABASE IF EXISTS `ry_vue`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `ry_vue` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `ry_vue`;

--
-- Table structure for table `application_cooldown`
--

DROP TABLE IF EXISTS `application_cooldown`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `application_cooldown` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `guild_id` bigint NOT NULL COMMENT '工会ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `reject_count` int DEFAULT '0' COMMENT '24小时内被拒绝次数',
  `cooldown_end_time` datetime DEFAULT NULL COMMENT '冷却结束时间',
  `last_reject_time` datetime DEFAULT NULL COMMENT '最后一次被拒绝时间',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_guild_user` (`guild_id`,`user_id`),
  KEY `idx_cooldown_end` (`cooldown_end_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='申请冷却记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `application_cooldown`
--

LOCK TABLES `application_cooldown` WRITE;
/*!40000 ALTER TABLE `application_cooldown` DISABLE KEYS */;
/*!40000 ALTER TABLE `application_cooldown` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_partition`
--

DROP TABLE IF EXISTS `game_partition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_partition` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '分区ID',
  `game_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '游戏名称',
  `game_code` varchar(20) COLLATE utf8mb4_general_ci NOT NULL COMMENT '游戏编码（唯一）',
  `icon` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '游戏图标URL',
  `description` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '游戏简介',
  `sort_order` int DEFAULT '0' COMMENT '排序',
  `status` tinyint DEFAULT '1' COMMENT '状态：0-禁用 1-正常',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `dept_id` bigint DEFAULT NULL COMMENT '对应部门ID',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_game_code` (`game_code`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='游戏分区表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_partition`
--

LOCK TABLES `game_partition` WRITE;
/*!40000 ALTER TABLE `game_partition` DISABLE KEYS */;
INSERT INTO `game_partition` VALUES (1,'英雄联盟','lol','/images/games/lol.png','League of Legends - 全球最受欢迎的MOBA游戏',1,1,'2026-06-07 23:35:52','2026-06-09 03:53:08',202),(2,'魔兽世界','wow','/images/games/wow.png','World of Warcraft - 经典MMORPG',2,1,'2026-06-07 23:35:52','2026-06-09 03:15:02',203),(3,'DOTA2','dota2','/images/games/dota2.png','Dota 2 - 硬核MOBA竞技游戏',3,1,'2026-06-07 23:35:52','2026-06-10 00:57:27',214),(4,'CSGO','csgo','/images/games/csgo.png','Counter-Strike: Global Offensive - 经典射击游戏',4,1,'2026-06-07 23:35:52','2026-06-10 00:57:27',215),(9,'王者荣耀','wzry',NULL,NULL,5,1,'2026-06-15 21:07:26','2026-06-15 21:07:26',219);
/*!40000 ALTER TABLE `game_partition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gen_table`
--

DROP TABLE IF EXISTS `gen_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gen_table` (
  `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '生成功能作者',
  `form_col_num` int DEFAULT '1' COMMENT '表单布局（单列 双列 三列）',
  `gen_type` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='代码生成业务表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gen_table`
--

LOCK TABLES `gen_table` WRITE;
/*!40000 ALTER TABLE `gen_table` DISABLE KEYS */;
/*!40000 ALTER TABLE `gen_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gen_table_column`
--

DROP TABLE IF EXISTS `gen_table_column`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gen_table_column` (
  `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '字典类型',
  `sort` int DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='代码生成业务表字段';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gen_table_column`
--

LOCK TABLES `gen_table_column` WRITE;
/*!40000 ALTER TABLE `gen_table_column` DISABLE KEYS */;
/*!40000 ALTER TABLE `gen_table_column` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guild`
--

DROP TABLE IF EXISTS `guild`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guild` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '工会ID',
  `game_partition_id` bigint NOT NULL COMMENT '所属游戏分区',
  `name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '工会名称',
  `description` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '工会简介',
  `recruit_requirement` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '招募要求',
  `online_time` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '常驻在线时段',
  `avatar` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '工会头像URL',
  `banner` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '宣传图URL',
  `president_id` bigint DEFAULT NULL COMMENT '会长用户ID',
  `member_count` int DEFAULT '0' COMMENT '成员数量',
  `status` tinyint DEFAULT '1' COMMENT '状态：0-解散 1-正常',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间（软删除）',
  `archive_until` datetime DEFAULT NULL COMMENT '归档到期时间',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `dept_id` bigint DEFAULT NULL COMMENT '对应部门ID',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_partition_name` (`game_partition_id`,`name`),
  KEY `idx_game_partition` (`game_partition_id`),
  KEY `idx_president` (`president_id`),
  CONSTRAINT `fk_guild_partition` FOREIGN KEY (`game_partition_id`) REFERENCES `game_partition` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工会表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guild`
--

LOCK TABLES `guild` WRITE;
/*!40000 ALTER TABLE `guild` DISABLE KEYS */;
INSERT INTO `guild` VALUES (8,1,'YuKki工会',NULL,NULL,NULL,NULL,NULL,NULL,3,1,NULL,NULL,'2026-06-13 15:52:02','2026-06-15 21:44:19',204),(9,9,'亡者工会',NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL,NULL,'2026-06-15 21:09:20','2026-06-15 21:40:12',220);
/*!40000 ALTER TABLE `guild` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guild_announcement`
--

DROP TABLE IF EXISTS `guild_announcement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guild_announcement` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `guild_id` bigint NOT NULL COMMENT '工会ID',
  `game_partition_id` bigint NOT NULL COMMENT '游戏分区ID',
  `title` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '公告标题',
  `content` text COLLATE utf8mb4_general_ci NOT NULL COMMENT '公告内容',
  `is_top` tinyint DEFAULT '0' COMMENT '是否置顶：0-否 1-是',
  `publisher_id` bigint NOT NULL COMMENT '发布人ID',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_guild` (`guild_id`),
  KEY `idx_created` (`created_at`),
  CONSTRAINT `fk_announcement_guild` FOREIGN KEY (`guild_id`) REFERENCES `guild` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工会公告表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guild_announcement`
--

LOCK TABLES `guild_announcement` WRITE;
/*!40000 ALTER TABLE `guild_announcement` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild_announcement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guild_application`
--

DROP TABLE IF EXISTS `guild_application`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guild_application` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '申请ID',
  `guild_id` bigint NOT NULL COMMENT '工会ID',
  `game_partition_id` bigint NOT NULL COMMENT '游戏分区ID',
  `user_id` bigint NOT NULL COMMENT '申请人ID',
  `message` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '申请留言',
  `status` tinyint DEFAULT '0' COMMENT '状态：0-待审核 1-已通过 2-已拒绝 3-已过期',
  `reject_reason` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '拒绝理由',
  `reviewer_id` bigint DEFAULT NULL COMMENT '审核人ID',
  `review_time` datetime DEFAULT NULL COMMENT '审核时间',
  `expire_time` datetime DEFAULT NULL COMMENT '过期时间',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',
  PRIMARY KEY (`id`),
  KEY `idx_guild` (`guild_id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_status` (`status`),
  CONSTRAINT `fk_application_guild` FOREIGN KEY (`guild_id`) REFERENCES `guild` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='入会申请表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guild_application`
--

LOCK TABLES `guild_application` WRITE;
/*!40000 ALTER TABLE `guild_application` DISABLE KEYS */;
INSERT INTO `guild_application` VALUES (1,8,1,1,'*',1,NULL,NULL,'2026-06-14 15:21:46',NULL,'2026-06-14 15:05:23'),(2,8,1,1,'--',1,NULL,NULL,'2026-06-14 16:05:59',NULL,'2026-06-14 16:05:40'),(3,8,1,3,'****',1,NULL,NULL,'2026-06-14 16:33:42',NULL,'2026-06-14 16:32:58'),(4,8,1,102,'我要加入\n',1,NULL,NULL,'2026-06-14 20:31:02',NULL,'2026-06-14 19:47:17'),(5,8,1,1,'1',1,NULL,NULL,'2026-06-14 20:19:19',NULL,'2026-06-14 20:13:17'),(6,8,1,102,'00',2,NULL,NULL,'2026-06-15 00:28:41',NULL,'2026-06-14 20:35:26'),(7,8,1,103,'我是孙小狗，噜啦啦噜啦啦噜啦啦噜啦啦噜啦啦噜啦啦噜啦啦噜啦啦噜啦啦噜啦啦噜啦啦噜啦啦噜啦啦噜啦啦噜啦啦噜啦啦噜啦啦噜啦啦噜啦啦噜啦啦啦啦啦',1,NULL,NULL,'2026-06-15 00:23:14',NULL,'2026-06-15 00:23:00'),(8,8,1,103,'我是孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗孙小狗',1,NULL,NULL,'2026-06-15 00:30:31',NULL,'2026-06-15 00:30:19'),(9,8,1,3,'我要进入',1,NULL,NULL,'2026-06-15 00:59:17',NULL,'2026-06-15 00:59:11'),(10,8,1,3,'1',1,NULL,NULL,'2026-06-15 00:59:41',NULL,'2026-06-15 00:59:32'),(11,8,1,3,'9',1,NULL,NULL,'2026-06-15 01:12:02',NULL,'2026-06-15 01:11:57'),(12,9,9,1,'11\n',1,NULL,NULL,'2026-06-15 21:20:50',NULL,'2026-06-15 21:20:25');
/*!40000 ALTER TABLE `guild_application` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guild_blacklist`
--

DROP TABLE IF EXISTS `guild_blacklist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guild_blacklist` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `guild_id` bigint NOT NULL COMMENT '工会ID',
  `game_partition_id` bigint NOT NULL COMMENT '游戏分区ID',
  `user_id` bigint NOT NULL COMMENT '被拉黑用户ID',
  `reason` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '拉黑原因',
  `operator_id` bigint NOT NULL COMMENT '操作人ID',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '拉黑时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_guild_user` (`guild_id`,`user_id`),
  KEY `idx_user` (`user_id`),
  CONSTRAINT `fk_blacklist_guild` FOREIGN KEY (`guild_id`) REFERENCES `guild` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='黑名单表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guild_blacklist`
--

LOCK TABLES `guild_blacklist` WRITE;
/*!40000 ALTER TABLE `guild_blacklist` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild_blacklist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guild_chat_message`
--

DROP TABLE IF EXISTS `guild_chat_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guild_chat_message` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '消息ID',
  `guild_id` bigint NOT NULL COMMENT '工会ID',
  `sender_id` bigint NOT NULL COMMENT '发送者用户ID',
  `sender_name` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '发送者昵称',
  `content` varchar(2000) COLLATE utf8mb4_general_ci NOT NULL COMMENT '消息内容',
  `type` tinyint DEFAULT '1' COMMENT '消息类型：1-文本 2-系统通知 3-@提醒',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '发送时间',
  PRIMARY KEY (`id`),
  KEY `idx_guild_time` (`guild_id`,`created_at`),
  KEY `idx_sender` (`sender_id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工会聊天消息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guild_chat_message`
--

LOCK TABLES `guild_chat_message` WRITE;
/*!40000 ALTER TABLE `guild_chat_message` DISABLE KEYS */;
INSERT INTO `guild_chat_message` VALUES (1,8,1,'YuKki','卡了卡了',1,'2026-06-16 01:21:40'),(2,8,1,'YuKki','你好',1,'2026-06-16 01:21:55'),(3,8,1,'YuKki','你好你好',1,'2026-06-16 01:23:43'),(4,8,1,'YuKki','测试测试',1,'2026-06-16 01:24:02'),(5,8,1,'YuKki','测试测试',1,'2026-06-16 01:25:27'),(6,8,1,'YuKki','消息123',1,'2026-06-16 01:25:34'),(7,8,1,'YuKki','114111',1,'2026-06-16 01:25:41'),(8,8,1,'YuKki','hello',1,'2026-06-16 01:27:03'),(9,8,0,'AI助手','AI 助手调用失败：401 Authorization Required on POST request for \"https://api.deepseek.com/v1/chat/completions\": [no body]',2,'2026-06-16 01:48:58'),(10,8,0,'AI助手','AI 助手调用失败：401 Authorization Required on POST request for \"https://api.deepseek.com/v1/chat/completions\": [no body]',2,'2026-06-16 01:52:17'),(11,8,1,'YuKki','111',1,'2026-06-16 01:56:04'),(12,8,0,'AI助手','欢迎来到工会！这里是你的AI助手，有什么游戏问题、策略讨论或工会事务需要帮忙的？尽管问我吧！',2,'2026-06-16 01:56:13'),(13,8,0,'AI助手','我是工会的AI助手，专注于解答游戏问题、分享策略和管理工会事务。随时为你服务，请告诉我需要什么帮助！',2,'2026-06-16 01:56:25'),(14,8,0,'AI助手','您好！作为工会AI助手，我暂时无法识别您的具体身份。不过，如果您能告诉我您的游戏昵称或角色名，我可以更好地为您提供帮助。请问有什么问题或需要讨论的策略吗？',2,'2026-06-16 01:56:42'),(15,8,0,'AI助手','我是专门为游戏工会服务的AI助手，可以帮你解答游戏问题、讨论策略或管理工会事务。你可以直接问我任何相关的问题！',2,'2026-06-16 01:57:02'),(16,9,1,'YuKki','卡了卡了',1,'2026-06-16 01:57:54'),(17,9,0,'AI助手','我是属于“星辰之翼”工会的AI助手！有什么需要帮忙的吗？比如游戏策略、活动安排，还是其他工会事务？',2,'2026-06-16 01:58:29'),(18,9,0,'AI助手','请注意言辞，我们工会提倡友善交流。如有问题或需要帮助，请以礼貌的方式提出，我会尽力解答！',2,'2026-06-16 01:58:43'),(19,8,0,'AI助手','我是YuKki工会的AI助手，隶属于会长YuKki，由管理员happypuppy和肝帝共同管理。有什么需要帮忙的吗？',2,'2026-06-16 02:07:54'),(20,8,0,'AI助手','当前工会暂无新任务发布。若有新任务，会长YuKki或管理员happypuppy、肝帝会第一时间通知大家。请留意工会公告或群消息哦！',2,'2026-06-16 02:08:21'),(21,8,0,'AI助手','目前工会没有显示过期的任务。如果有任务已到期，一般会在任务列表中标注“已过期”或无法接取。你可以让会长YuKki或管理员happypuppy、肝帝在后台确认一下。需要我帮你转达给他们吗？',2,'2026-06-16 02:08:36'),(22,8,0,'AI助手','请问您需要什么帮助？请告诉我具体问题或需求，我会尽力协助您。',2,'2026-06-16 02:08:51'),(23,8,102,'肝帝','我是',1,'2026-06-16 16:32:43'),(24,8,102,'肝帝','肝帝',1,'2026-06-16 16:33:08'),(25,8,102,'肝帝','卡了卡了',1,'2026-06-16 16:33:21'),(26,8,1,'YuKki','卡了卡',1,'2026-06-16 16:33:30'),(27,8,0,'AI助手','你好，我是「YuKki工会」的AI助手，正在为你服务！请问有什么可以帮你的吗？',2,'2026-06-16 16:33:39'),(28,8,0,'AI助手','目前工会暂无新任务发布。请留意后续通知，保持活跃！如有疑问可联系：会长YuKki、管理员happypuppy或肝帝。',2,'2026-06-16 16:34:40'),(29,8,0,'AI助手','好的，已收到您的任务发布！请提供任务详情，工会成员将尽快处理。如有需要，可联系会长YuKki或管理员happypuppy、肝帝协调。',2,'2026-06-16 16:34:58'),(30,8,0,'AI助手','目前可接取的任务如下：\n1. **日常巡逻**（推荐等级30+，奖励金币+经验）\n2. **深渊探索**（推荐等级50+，奖励稀有材料）\n3. **护送商队**（推荐等级40+，奖励装备碎片）\n如需详细信息或接取，请告知任务编号。',2,'2026-06-16 16:35:20'),(31,9,1,'YuKki','1‘',1,'2026-06-22 20:48:40'),(32,9,0,'AI助手','AI 助手暂未配置 API Key，请联系管理员。',2,'2026-06-22 20:48:51');
/*!40000 ALTER TABLE `guild_chat_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guild_create_application`
--

DROP TABLE IF EXISTS `guild_create_application`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guild_create_application` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '申请ID',
  `game_partition_id` bigint NOT NULL COMMENT '游戏分区ID',
  `guild_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '工会名称',
  `description` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '工会简介',
  `recruit_requirement` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '招募要求',
  `applicant_id` bigint NOT NULL COMMENT '申请人ID',
  `status` tinyint DEFAULT '0' COMMENT '状态：0-待审核 1-已通过 2-已拒绝',
  `reject_reason` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '拒绝理由',
  `reviewer_id` bigint DEFAULT NULL COMMENT '审核人ID',
  `review_time` datetime DEFAULT NULL COMMENT '审核时间',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_partition_name` (`game_partition_id`,`guild_name`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工会创建申请表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guild_create_application`
--

LOCK TABLES `guild_create_application` WRITE;
/*!40000 ALTER TABLE `guild_create_application` DISABLE KEYS */;
INSERT INTO `guild_create_application` VALUES (1,1,'1','','',3,1,NULL,1,'2026-06-15 22:04:20','2026-06-15 21:53:40');
/*!40000 ALTER TABLE `guild_create_application` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guild_member`
--

DROP TABLE IF EXISTS `guild_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guild_member` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `guild_id` bigint NOT NULL COMMENT '工会ID',
  `game_partition_id` bigint NOT NULL COMMENT '游戏分区ID（冗余，用于隔离）',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role` tinyint NOT NULL COMMENT '角色：1-会长 2-管理员 3-普通成员',
  `join_time` datetime DEFAULT NULL COMMENT '入会时间',
  `status` tinyint DEFAULT '1' COMMENT '状态：0-已退出 1-正常',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_partition_user` (`game_partition_id`,`user_id`),
  KEY `idx_guild` (`guild_id`),
  KEY `idx_user` (`user_id`),
  CONSTRAINT `fk_member_guild` FOREIGN KEY (`guild_id`) REFERENCES `guild` (`id`),
  CONSTRAINT `fk_member_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工会成员表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guild_member`
--

LOCK TABLES `guild_member` WRITE;
/*!40000 ALTER TABLE `guild_member` DISABLE KEYS */;
INSERT INTO `guild_member` VALUES (1,8,1,1,1,'2026-06-14 16:00:43',1,'2026-06-14 16:00:43','2026-06-14 16:34:37'),(12,8,1,102,2,'2026-06-14 20:31:02',1,'2026-06-15 00:41:20','2026-06-15 00:46:08'),(13,8,1,103,2,'2026-06-15 00:30:31',1,'2026-06-15 00:41:20','2026-06-15 00:48:22'),(17,9,9,1,3,'2026-06-15 21:20:51',1,'2026-06-15 21:20:50','2026-06-15 21:20:50');
/*!40000 ALTER TABLE `guild_member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guild_message`
--

DROP TABLE IF EXISTS `guild_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guild_message` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '消息ID',
  `guild_id` bigint DEFAULT NULL COMMENT '工会ID',
  `receiver_id` bigint DEFAULT NULL COMMENT '接收者ID',
  `sender_id` bigint DEFAULT NULL COMMENT '发送者ID',
  `title` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '消息标题',
  `content` text COLLATE utf8mb4_unicode_ci COMMENT '消息内容',
  `msg_type` tinyint DEFAULT '1' COMMENT '消息类型：1-系统 2-工会',
  `status` tinyint DEFAULT '0' COMMENT '状态：0-未读 1-已读',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_guild_id` (`guild_id`),
  KEY `idx_receiver_id` (`receiver_id`),
  KEY `idx_sender_id` (`sender_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='工会消息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guild_message`
--

LOCK TABLES `guild_message` WRITE;
/*!40000 ALTER TABLE `guild_message` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guild_operation_log`
--

DROP TABLE IF EXISTS `guild_operation_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guild_operation_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `game_partition_id` bigint DEFAULT NULL COMMENT '游戏分区ID',
  `guild_id` bigint DEFAULT NULL COMMENT '工会ID',
  `operator_id` bigint NOT NULL COMMENT '操作人ID',
  `operator_role` tinyint DEFAULT NULL COMMENT '操作人角色：1-会长 2-管理员 3-普通成员',
  `operation_type` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '操作类型',
  `operation_desc` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '操作描述',
  `old_value` text COLLATE utf8mb4_general_ci COMMENT '修改前数据',
  `new_value` text COLLATE utf8mb4_general_ci COMMENT '修改后数据',
  `ip_address` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'IP地址',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  PRIMARY KEY (`id`),
  KEY `idx_guild` (`guild_id`),
  KEY `idx_operator` (`operator_id`),
  KEY `idx_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工会操作日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guild_operation_log`
--

LOCK TABLES `guild_operation_log` WRITE;
/*!40000 ALTER TABLE `guild_operation_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild_operation_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guild_task`
--

DROP TABLE IF EXISTS `guild_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guild_task` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `guild_id` bigint NOT NULL COMMENT '工会ID',
  `game_partition_id` bigint NOT NULL COMMENT '游戏分区ID',
  `publisher_id` bigint NOT NULL COMMENT '发布人ID',
  `name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务名称',
  `type` tinyint DEFAULT '1' COMMENT '任务类型：1-日常打卡 2-副本组队 3-活动任务 4-竞技任务',
  `description` text COLLATE utf8mb4_general_ci COMMENT '任务详情',
  `image` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '配图URL',
  `task_mode` tinyint DEFAULT '1' COMMENT '任务模式：1-单人 2-多人',
  `min_players` int DEFAULT '1' COMMENT '人数下限',
  `max_players` int DEFAULT '1' COMMENT '人数上限',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `join_deadline` datetime DEFAULT NULL COMMENT '接取截止时间',
  `end_time` datetime DEFAULT NULL COMMENT '截止时间',
  `status` tinyint DEFAULT '1' COMMENT '状态：1-未开始 2-进行中 3-已满员 4-已结束 5-已作废 6-已关闭 7-已完成',
  `current_players` int DEFAULT '0' COMMENT '当前参与人数',
  `version` int DEFAULT '0' COMMENT '乐观锁版本号',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_guild` (`guild_id`),
  KEY `idx_publisher` (`publisher_id`),
  KEY `idx_status` (`status`),
  KEY `idx_end_time` (`end_time`),
  CONSTRAINT `fk_task_guild` FOREIGN KEY (`guild_id`) REFERENCES `guild` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工会任务表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guild_task`
--

LOCK TABLES `guild_task` WRITE;
/*!40000 ALTER TABLE `guild_task` DISABLE KEYS */;
INSERT INTO `guild_task` VALUES (5,8,1,1,'1',1,NULL,NULL,NULL,1,2,NULL,'2026-06-15 01:38:39','2026-06-15 01:38:47',4,2,0,'2026-06-15 01:37:54','2026-06-15 01:39:38'),(6,8,1,1,'2',3,'测试测试',NULL,NULL,2,3,NULL,'2026-06-17 14:00:00','2026-06-18 14:00:00',1,2,0,'2026-06-16 16:34:32','2026-06-16 16:36:05');
/*!40000 ALTER TABLE `guild_task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_config`
--

DROP TABLE IF EXISTS `sys_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_config` (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) COLLATE utf8mb4_unicode_ci DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='参数配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_config`
--

LOCK TABLES `sys_config` WRITE;
/*!40000 ALTER TABLE `sys_config` DISABLE KEYS */;
INSERT INTO `sys_config` VALUES (1,'主框架页-默认皮肤样式名称','sys.index.skinName','skin-blue','Y','admin','2026-06-07 22:27:02','',NULL,'蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow'),(2,'用户管理-账号初始密码','sys.user.initPassword','123456','Y','admin','2026-06-07 22:27:02','',NULL,'初始化密码 123456'),(3,'主框架页-侧边栏主题','sys.index.sideTheme','theme-dark','Y','admin','2026-06-07 22:27:02','',NULL,'深色主题theme-dark，浅色主题theme-light'),(4,'账号自助-验证码开关','sys.account.captchaEnabled','true','Y','admin','2026-06-07 22:27:02','',NULL,'是否开启验证码功能（true开启，false关闭）'),(5,'账号自助-是否开启用户注册功能','sys.account.registerUser','true','Y','admin','2026-06-07 22:27:02','admin','2026-06-07 22:44:54','是否开启注册用户功能（true开启，false关闭）'),(6,'用户登录-黑名单列表','sys.login.blackIPList','','Y','admin','2026-06-07 22:27:02','',NULL,'设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）'),(7,'用户管理-初始密码修改策略','sys.account.initPasswordModify','1','Y','admin','2026-06-07 22:27:02','',NULL,'0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框'),(8,'用户管理-账号密码更新周期','sys.account.passwordValidateDays','0','Y','admin','2026-06-07 22:27:02','',NULL,'密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框'),(9,'用户管理-密码字符范围','sys.account.chrtype','0','Y','admin','2026-06-07 22:27:02','',NULL,'默认任意字符范围，0任意（密码可以输入任意字符），1数字（密码只能为0-9数字），2英文字母（密码只能为a-z和A-Z字母），3字母和数字（密码必须包含字母，数字）,4字母数字和特殊字符（目前支持的特殊字符包括：~!@#$%^&*()-=_+）');
/*!40000 ALTER TABLE `sys_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dept`
--

DROP TABLE IF EXISTS `sys_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dept` (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint DEFAULT '0' COMMENT '父部门id',
  `ancestors` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '部门名称',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `leader` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '邮箱',
  `status` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`)
) ENGINE=InnoDB AUTO_INCREMENT=222 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='部门表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dept`
--

LOCK TABLES `sys_dept` WRITE;
/*!40000 ALTER TABLE `sys_dept` DISABLE KEYS */;
INSERT INTO `sys_dept` VALUES (100,0,'','网站汇总',0,'YuKki','15729728627','2517487412@qq.com','0','0','admin','2026-06-07 00:00:00','admin','2026-06-07 22:54:09'),(201,100,',100','GameClub',2,'YuKki','15729728627','2517487412@qq.com','0','0','admin','2026-06-07 22:54:50','admin','2026-06-07 22:55:21'),(202,201,',100,201','英雄联盟',1,NULL,NULL,NULL,'0','0','admin','2026-06-07 22:57:49','',NULL),(204,202,',100,201,202','YuKki工会',1,'YuKki','15729728627','2517487412@qq.com','0','0','admin','2026-06-07 23:00:57','',NULL),(205,201,',100,201','无工会用户',2,NULL,NULL,NULL,'0','0','admin','2026-06-07 23:01:46','',NULL),(214,201,',100,201','DOTA2',1,NULL,NULL,NULL,'0','0','system','2026-06-10 00:57:27','',NULL),(215,201,',100,201','CSGO',1,NULL,NULL,NULL,'0','0','system','2026-06-10 00:57:27','',NULL),(219,201,',100,201','王者荣耀',5,NULL,NULL,NULL,'0','0','system','2026-06-15 21:07:26','',NULL),(220,219,',100,201,219','亡者工会',0,NULL,NULL,NULL,'0','0','system','2026-06-15 21:09:20','',NULL);
/*!40000 ALTER TABLE `sys_dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_data`
--

DROP TABLE IF EXISTS `sys_dict_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_data` (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int DEFAULT '0' COMMENT '字典排序',
  `dict_label` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) COLLATE utf8mb4_unicode_ci DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='字典数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_data`
--

LOCK TABLES `sys_dict_data` WRITE;
/*!40000 ALTER TABLE `sys_dict_data` DISABLE KEYS */;
INSERT INTO `sys_dict_data` VALUES (1,1,'男','0','sys_user_sex','','','Y','0','admin','2026-06-07 22:27:02','',NULL,'性别男'),(2,2,'女','1','sys_user_sex','','','N','0','admin','2026-06-07 22:27:02','',NULL,'性别女'),(3,3,'未知','2','sys_user_sex','','','N','0','admin','2026-06-07 22:27:02','',NULL,'性别未知'),(4,1,'显示','0','sys_show_hide','','primary','Y','0','admin','2026-06-07 22:27:02','',NULL,'显示菜单'),(5,2,'隐藏','1','sys_show_hide','','danger','N','0','admin','2026-06-07 22:27:02','',NULL,'隐藏菜单'),(6,1,'正常','0','sys_normal_disable','','primary','Y','0','admin','2026-06-07 22:27:02','',NULL,'正常状态'),(7,2,'停用','1','sys_normal_disable','','danger','N','0','admin','2026-06-07 22:27:02','',NULL,'停用状态'),(8,1,'正常','0','sys_job_status','','primary','Y','0','admin','2026-06-07 22:27:02','',NULL,'正常状态'),(9,2,'暂停','1','sys_job_status','','danger','N','0','admin','2026-06-07 22:27:02','',NULL,'停用状态'),(10,1,'默认','DEFAULT','sys_job_group','','','Y','0','admin','2026-06-07 22:27:02','',NULL,'默认分组'),(11,2,'系统','SYSTEM','sys_job_group','','','N','0','admin','2026-06-07 22:27:02','',NULL,'系统分组'),(12,1,'是','Y','sys_yes_no','','primary','Y','0','admin','2026-06-07 22:27:02','',NULL,'系统默认是'),(13,2,'否','N','sys_yes_no','','danger','N','0','admin','2026-06-07 22:27:02','',NULL,'系统默认否'),(14,1,'通知','1','sys_notice_type','','warning','Y','0','admin','2026-06-07 22:27:02','',NULL,'通知'),(15,2,'公告','2','sys_notice_type','','success','N','0','admin','2026-06-07 22:27:02','',NULL,'公告'),(16,1,'正常','0','sys_notice_status','','primary','Y','0','admin','2026-06-07 22:27:02','',NULL,'正常状态'),(17,2,'关闭','1','sys_notice_status','','danger','N','0','admin','2026-06-07 22:27:02','',NULL,'关闭状态'),(18,99,'其他','0','sys_oper_type','','info','N','0','admin','2026-06-07 22:27:02','',NULL,'其他操作'),(19,1,'新增','1','sys_oper_type','','info','N','0','admin','2026-06-07 22:27:02','',NULL,'新增操作'),(20,2,'修改','2','sys_oper_type','','info','N','0','admin','2026-06-07 22:27:02','',NULL,'修改操作'),(21,3,'删除','3','sys_oper_type','','danger','N','0','admin','2026-06-07 22:27:02','',NULL,'删除操作'),(22,4,'授权','4','sys_oper_type','','primary','N','0','admin','2026-06-07 22:27:02','',NULL,'授权操作'),(23,5,'导出','5','sys_oper_type','','warning','N','0','admin','2026-06-07 22:27:02','',NULL,'导出操作'),(24,6,'导入','6','sys_oper_type','','warning','N','0','admin','2026-06-07 22:27:02','',NULL,'导入操作'),(25,7,'强退','7','sys_oper_type','','danger','N','0','admin','2026-06-07 22:27:02','',NULL,'强退操作'),(26,8,'生成代码','8','sys_oper_type','','warning','N','0','admin','2026-06-07 22:27:02','',NULL,'生成操作'),(27,9,'清空数据','9','sys_oper_type','','danger','N','0','admin','2026-06-07 22:27:02','',NULL,'清空操作'),(28,1,'成功','0','sys_common_status','','primary','N','0','admin','2026-06-07 22:27:02','',NULL,'正常状态'),(29,2,'失败','1','sys_common_status','','danger','N','0','admin','2026-06-07 22:27:02','',NULL,'停用状态');
/*!40000 ALTER TABLE `sys_dict_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_type`
--

DROP TABLE IF EXISTS `sys_dict_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_type` (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '字典类型',
  `status` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`),
  UNIQUE KEY `dict_type` (`dict_type`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='字典类型表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_type`
--

LOCK TABLES `sys_dict_type` WRITE;
/*!40000 ALTER TABLE `sys_dict_type` DISABLE KEYS */;
INSERT INTO `sys_dict_type` VALUES (1,'用户性别','sys_user_sex','0','admin','2026-06-07 22:27:02','',NULL,'用户性别列表'),(2,'菜单状态','sys_show_hide','0','admin','2026-06-07 22:27:02','',NULL,'菜单状态列表'),(3,'系统开关','sys_normal_disable','0','admin','2026-06-07 22:27:02','',NULL,'系统开关列表'),(4,'任务状态','sys_job_status','0','admin','2026-06-07 22:27:02','',NULL,'任务状态列表'),(5,'任务分组','sys_job_group','0','admin','2026-06-07 22:27:02','',NULL,'任务分组列表'),(6,'系统是否','sys_yes_no','0','admin','2026-06-07 22:27:02','',NULL,'系统是否列表'),(7,'通知类型','sys_notice_type','0','admin','2026-06-07 22:27:02','',NULL,'通知类型列表'),(8,'通知状态','sys_notice_status','0','admin','2026-06-07 22:27:02','',NULL,'通知状态列表'),(9,'操作类型','sys_oper_type','0','admin','2026-06-07 22:27:02','',NULL,'操作类型列表'),(10,'系统状态','sys_common_status','0','admin','2026-06-07 22:27:02','',NULL,'登录状态列表');
/*!40000 ALTER TABLE `sys_dict_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_job`
--

DROP TABLE IF EXISTS `sys_job`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_job` (
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`,`job_name`,`job_group`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='定时任务调度表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_job`
--

LOCK TABLES `sys_job` WRITE;
/*!40000 ALTER TABLE `sys_job` DISABLE KEYS */;
INSERT INTO `sys_job` VALUES (1,'系统默认（无参）','DEFAULT','ryTask.ryNoParams','0/10 * * * * ?','3','1','1','admin','2026-06-07 22:27:02','',NULL,''),(2,'系统默认（有参）','DEFAULT','ryTask.ryParams(\'ry\')','0/15 * * * * ?','3','1','1','admin','2026-06-07 22:27:02','',NULL,''),(3,'系统默认（多参）','DEFAULT','ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)','0/20 * * * * ?','3','1','1','admin','2026-06-07 22:27:02','',NULL,'');
/*!40000 ALTER TABLE `sys_job` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_job_log`
--

DROP TABLE IF EXISTS `sys_job_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_job_log` (
  `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '日志信息',
  `status` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '异常信息',
  `start_time` datetime DEFAULT NULL COMMENT '执行开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '执行结束时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='定时任务调度日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_job_log`
--

LOCK TABLES `sys_job_log` WRITE;
/*!40000 ALTER TABLE `sys_job_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_job_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_logininfor`
--

DROP TABLE IF EXISTS `sys_logininfor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_logininfor` (
  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '操作系统',
  `status` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '提示消息',
  `login_time` datetime DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`),
  KEY `idx_sys_logininfor_s` (`status`),
  KEY `idx_sys_logininfor_lt` (`login_time`)
) ENGINE=InnoDB AUTO_INCREMENT=211 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统访问记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_logininfor`
--

LOCK TABLES `sys_logininfor` WRITE;
/*!40000 ALTER TABLE `sys_logininfor` DISABLE KEYS */;
INSERT INTO `sys_logininfor` VALUES (100,'admin','127.0.0.1','内网IP','Chrome 148','Windows10','0','退出成功','2026-06-07 22:30:02'),(101,'admin','127.0.0.1','内网IP','Chrome 148','Windows10','0','登录成功','2026-06-07 22:30:03'),(102,'admin','127.0.0.1','内网IP','Chrome 148','Windows10','0','登录成功','2026-06-07 23:56:38'),(103,'admin','127.0.0.1','内网IP','Chrome 148','Windows10','0','退出成功','2026-06-08 01:36:26'),(104,'ry','127.0.0.1','内网IP','Chrome 148','Windows10','0','登录成功','2026-06-08 01:36:30'),(105,'ry','127.0.0.1','内网IP','Chrome 148','Windows10','0','退出成功','2026-06-08 01:36:58'),(106,'admin','127.0.0.1','内网IP','Chrome 148','Windows10','1','验证码错误','2026-06-08 01:37:03'),(107,'admin','127.0.0.1','内网IP','Chrome 148','Windows10','1','验证码错误','2026-06-08 01:37:05'),(108,'admin','127.0.0.1','内网IP','Chrome 148','Windows10','0','登录成功','2026-06-08 01:37:10'),(109,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','登录成功','2026-06-09 01:43:07'),(110,'admin','127.0.0.1','内网IP','Chrome 148','Windows10','0','登录成功','2026-06-09 01:56:41'),(111,'admin','127.0.0.1','内网IP','Chrome 148','Windows10','0','登录成功','2026-06-09 03:22:52'),(112,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.8457','Windows 10.0','1','验证码已失效','2026-06-09 03:38:33'),(113,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.8457','Windows 10.0','0','登录成功','2026-06-09 03:42:02'),(114,'testuser','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.8457','Windows 10.0','1','用户不存在/密码错误','2026-06-09 03:44:24'),(115,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.8457','Windows 10.0','0','登录成功','2026-06-09 03:49:57'),(116,'admin','127.0.0.1','内网IP','Chrome 148','Windows10','0','登录成功','2026-06-09 10:05:08'),(117,'admin','127.0.0.1','内网IP','Chrome 148','Windows10','0','登录成功','2026-06-09 12:43:40'),(118,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','登录成功','2026-06-10 00:43:11'),(119,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','登录成功','2026-06-10 01:29:53'),(120,'admin','127.0.0.1','内网IP','Chrome 148','Windows10','0','登录成功','2026-06-10 01:40:56'),(121,'admin','127.0.0.1','内网IP','Chrome 148','Windows10','0','登录成功','2026-06-10 03:14:59'),(122,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-13 14:39:23'),(123,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-13 14:47:14'),(124,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','登录成功','2026-06-13 15:35:59'),(125,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','退出成功','2026-06-13 15:38:44'),(126,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','登录成功','2026-06-13 15:38:47'),(127,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-13 16:04:15'),(128,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-13 16:05:34'),(129,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-13 16:14:07'),(130,'sk','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-13 16:14:13'),(131,'sk','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-13 16:14:48'),(132,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-13 16:14:52'),(133,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-13 16:15:21'),(134,'sk','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-13 16:15:28'),(135,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-14 14:25:32'),(136,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-14 14:27:01'),(137,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','1','验证码错误','2026-06-14 14:27:04'),(138,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','1','验证码错误','2026-06-14 14:27:07'),(139,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-14 14:27:13'),(140,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-14 14:57:28'),(141,'sk','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-14 14:57:35'),(142,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','登录成功','2026-06-14 15:05:03'),(143,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','退出成功','2026-06-14 16:29:51'),(144,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','登录成功','2026-06-14 16:29:55'),(145,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','退出成功','2026-06-14 16:30:13'),(146,'sk','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','登录成功','2026-06-14 16:30:23'),(147,'sk','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','退出成功','2026-06-14 16:33:07'),(148,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','登录成功','2026-06-14 16:33:09'),(149,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','登录成功','2026-06-14 18:40:56'),(150,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','退出成功','2026-06-14 18:45:59'),(151,'sk','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','登录成功','2026-06-14 18:46:07'),(152,'sk','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-14 18:46:21'),(153,'sk','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-14 18:47:14'),(154,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-14 18:47:17'),(155,'sk','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','退出成功','2026-06-14 19:12:04'),(156,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','登录成功','2026-06-14 19:12:08'),(157,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','退出成功','2026-06-14 19:38:26'),(158,'ry','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','登录成功','2026-06-14 19:38:30'),(159,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-14 19:38:40'),(160,'ry','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-14 19:38:48'),(161,'ry','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-14 19:39:14'),(162,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-14 19:39:17'),(163,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-14 19:39:33'),(164,'肝帝','127.0.0.1','内网IP','Chrome 149','Windows10','0','注册成功','2026-06-14 19:40:57'),(165,'肝帝','127.0.0.1','内网IP','Chrome 149','Windows10','1','用户不存在/密码错误','2026-06-14 19:41:06'),(166,'肝帝','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-14 19:41:11'),(167,'ry','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','退出成功','2026-06-14 19:41:42'),(168,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','登录成功','2026-06-14 19:41:44'),(169,'肝帝','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-14 19:46:21'),(170,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-14 19:46:23'),(171,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-14 19:46:41'),(172,'肝帝','127.0.0.1','内网IP','Chrome 149','Windows10','1','用户不存在/密码错误','2026-06-14 19:46:46'),(173,'肝帝','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-14 19:46:51'),(174,'肝帝','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-14 19:47:22'),(175,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-14 19:47:25'),(176,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','退出成功','2026-06-14 20:34:04'),(177,'肝帝','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','登录成功','2026-06-14 20:34:46'),(178,'肝帝','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','退出成功','2026-06-14 20:36:48'),(179,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','1','验证码错误','2026-06-14 20:36:51'),(180,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','登录成功','2026-06-14 20:37:07'),(181,'admin','192.168.2.55','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-15 00:06:58'),(182,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-15 00:07:19'),(183,'happypuppy','192.168.2.115','内网IP','Chrome 148','Windows10','0','注册成功','2026-06-15 00:08:35'),(184,'happypuppy','192.168.2.115','内网IP','Chrome 148','Windows10','0','登录成功','2026-06-15 00:08:51'),(185,'admin','192.168.2.80','内网IP','Quark 7.4.6.681','Windows XP x64 Edition','0','登录成功','2026-06-15 00:20:48'),(186,'happypuppy','192.168.2.115','内网IP','Chrome 148','Windows10','0','退出成功','2026-06-15 00:48:55'),(187,'happypuppy','192.168.2.115','内网IP','Chrome 148','Windows10','0','登录成功','2026-06-15 00:49:01'),(188,'sk','192.168.2.80','内网IP','Quark 7.4.6.681','Windows XP x64 Edition','0','登录成功','2026-06-15 00:58:46'),(189,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-15 21:06:31'),(190,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-15 21:44:23'),(191,'sk','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-15 21:44:31'),(192,'sk','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-15 21:54:21'),(193,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-15 21:54:27'),(194,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-15 22:29:23'),(195,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-15 22:34:07'),(196,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','登录成功','2026-06-16 00:21:50'),(197,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','退出成功','2026-06-16 00:22:39'),(198,'admin','127.0.0.1','内网IP','TraeCN 1.107.1','Windows 10.0','0','登录成功','2026-06-16 00:22:42'),(199,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-16 00:48:19'),(200,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-16 00:53:54'),(201,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-16 00:53:59'),(202,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-16 00:58:39'),(203,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-16 01:29:17'),(204,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','1','验证码已失效','2026-06-16 01:55:24'),(205,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-16 01:55:27'),(206,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-16 16:31:52'),(207,'肝帝','192.168.2.80','内网IP','Quark 7.4.6.681','Windows XP x64 Edition','1','用户不存在/密码错误','2026-06-16 16:32:25'),(208,'肝帝','192.168.2.80','内网IP','Quark 7.4.6.681','Windows XP x64 Edition','1','验证码错误','2026-06-16 16:32:31'),(209,'肝帝','192.168.2.80','内网IP','Quark 7.4.6.681','Windows XP x64 Edition','0','登录成功','2026-06-16 16:32:35'),(210,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-22 20:48:20');
/*!40000 ALTER TABLE `sys_logininfor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_menu`
--

DROP TABLE IF EXISTS `sys_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_menu` (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint DEFAULT '0' COMMENT '父菜单ID',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `path` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '路由名称',
  `is_frame` int DEFAULT '1' COMMENT '是否为外链（0是 1否）',
  `is_cache` int DEFAULT '0' COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3006 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='菜单权限表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_menu`
--

LOCK TABLES `sys_menu` WRITE;
/*!40000 ALTER TABLE `sys_menu` DISABLE KEYS */;
INSERT INTO `sys_menu` VALUES (1,'系统管理',0,1,'system',NULL,'','',1,0,'M','0','0','','system','admin','2026-06-07 22:27:01','',NULL,'系统管理目录'),(2,'系统监控',0,2,'monitor',NULL,'','',1,0,'M','0','0','','monitor','admin','2026-06-07 22:27:01','admin','2026-06-07 23:11:53','系统监控目录'),(3,'系统工具',0,3,'tool',NULL,'','',1,0,'M','1','1','','tool','admin','2026-06-07 22:27:01','admin','2026-06-07 23:12:17','系统工具目录'),(4,'若依官网',0,4,'http://ruoyi.vip',NULL,'','',0,0,'M','0','1','','guide','admin','2026-06-07 22:27:01','admin','2026-06-07 23:14:51','若依官网地址'),(100,'用户管理',1,1,'user','system/user/index','','',1,0,'C','0','0','system:user:list','user','admin','2026-06-07 22:27:01','',NULL,'用户管理菜单'),(101,'角色管理',1,2,'role','system/role/index','','',1,0,'C','0','0','system:role:list','peoples','admin','2026-06-07 22:27:01','',NULL,'角色管理菜单'),(102,'菜单管理',1,3,'menu','system/menu/index','','',1,0,'C','0','0','system:menu:list','tree-table','admin','2026-06-07 22:27:01','',NULL,'菜单管理菜单'),(103,'部门管理',1,4,'dept','system/dept/index','','',1,0,'C','0','0','system:dept:list','tree','admin','2026-06-07 22:27:01','',NULL,'部门管理菜单'),(104,'岗位管理',1,5,'post','system/post/index','','',1,0,'C','0','0','system:post:list','post','admin','2026-06-07 22:27:01','',NULL,'岗位管理菜单'),(105,'字典管理',1,6,'dict','system/dict/index','','',1,0,'C','0','0','system:dict:list','dict','admin','2026-06-07 22:27:01','admin','2026-06-08 01:37:36','字典管理菜单'),(106,'参数设置',1,7,'config','system/config/index','','',1,0,'C','0','0','system:config:list','edit','admin','2026-06-07 22:27:01','',NULL,'参数设置菜单'),(107,'通知公告',1,8,'notice','system/notice/index','','',1,0,'C','1','0','system:notice:list','message','admin','2026-06-07 22:27:01','admin','2026-06-07 23:18:13','通知公告菜单'),(108,'日志管理',1,9,'log','','','',1,0,'M','1','0','','log','admin','2026-06-07 22:27:01','admin','2026-06-07 23:18:17','日志管理菜单'),(109,'在线用户',2,1,'online','monitor/online/index','','',1,0,'C','0','0','monitor:online:list','online','admin','2026-06-07 22:27:02','admin','2026-06-07 23:13:22','在线用户菜单'),(110,'定时任务',2,2,'job','monitor/job/index','','',1,0,'C','1','1','monitor:job:list','job','admin','2026-06-07 22:27:02','admin','2026-06-07 23:11:26','定时任务菜单'),(111,'数据监控',2,3,'druid','monitor/druid/index','','',1,0,'C','1','1','monitor:druid:list','druid','admin','2026-06-07 22:27:02','admin','2026-06-07 23:12:00','数据监控菜单'),(112,'服务监控',2,4,'server','monitor/server/index','','',1,0,'C','1','1','monitor:server:list','server','admin','2026-06-07 22:27:02','admin','2026-06-07 23:12:04','服务监控菜单'),(113,'缓存监控',2,5,'cache','monitor/cache/index','','',1,0,'C','1','1','monitor:cache:list','redis','admin','2026-06-07 22:27:02','admin','2026-06-07 23:12:08','缓存监控菜单'),(114,'缓存列表',2,6,'cacheList','monitor/cache/list','','',1,0,'C','0','1','monitor:cache:list','redis-list','admin','2026-06-07 22:27:02','admin','2026-06-07 23:13:47','缓存列表菜单'),(115,'表单构建',3,1,'build','tool/build/index','','',1,0,'C','1','1','tool:build:list','build','admin','2026-06-07 22:27:02','admin','2026-06-07 23:12:25','表单构建菜单'),(116,'代码生成',3,2,'gen','tool/gen/index','','',1,0,'C','1','1','tool:gen:list','code','admin','2026-06-07 22:27:02','admin','2026-06-07 23:12:28','代码生成菜单'),(117,'系统接口',3,3,'swagger','tool/swagger/index','','',1,0,'C','0','1','tool:swagger:list','swagger','admin','2026-06-07 22:27:02','admin','2026-06-07 23:12:36','系统接口菜单'),(500,'操作日志',108,1,'operlog','monitor/operlog/index','','',1,0,'C','0','0','monitor:operlog:list','form','admin','2026-06-07 22:27:02','',NULL,'操作日志菜单'),(501,'登录日志',108,2,'logininfor','monitor/logininfor/index','','',1,0,'C','0','0','monitor:logininfor:list','logininfor','admin','2026-06-07 22:27:02','',NULL,'登录日志菜单'),(1000,'用户查询',100,1,'','','','',1,0,'F','0','0','system:user:query','#','admin','2026-06-07 22:27:02','',NULL,''),(1001,'用户新增',100,2,'','','','',1,0,'F','0','0','system:user:add','#','admin','2026-06-07 22:27:02','',NULL,''),(1002,'用户修改',100,3,'','','','',1,0,'F','0','0','system:user:edit','#','admin','2026-06-07 22:27:02','',NULL,''),(1003,'用户删除',100,4,'','','','',1,0,'F','0','0','system:user:remove','#','admin','2026-06-07 22:27:02','',NULL,''),(1004,'用户导出',100,5,'','','','',1,0,'F','0','0','system:user:export','#','admin','2026-06-07 22:27:02','',NULL,''),(1005,'用户导入',100,6,'','','','',1,0,'F','0','0','system:user:import','#','admin','2026-06-07 22:27:02','',NULL,''),(1006,'重置密码',100,7,'','','','',1,0,'F','0','0','system:user:resetPwd','#','admin','2026-06-07 22:27:02','',NULL,''),(1007,'角色查询',101,1,'','','','',1,0,'F','0','0','system:role:query','#','admin','2026-06-07 22:27:02','',NULL,''),(1008,'角色新增',101,2,'','','','',1,0,'F','0','0','system:role:add','#','admin','2026-06-07 22:27:02','',NULL,''),(1009,'角色修改',101,3,'','','','',1,0,'F','0','0','system:role:edit','#','admin','2026-06-07 22:27:02','',NULL,''),(1010,'角色删除',101,4,'','','','',1,0,'F','0','0','system:role:remove','#','admin','2026-06-07 22:27:02','',NULL,''),(1011,'角色导出',101,5,'','','','',1,0,'F','0','0','system:role:export','#','admin','2026-06-07 22:27:02','',NULL,''),(1012,'菜单查询',102,1,'','','','',1,0,'F','0','0','system:menu:query','#','admin','2026-06-07 22:27:02','',NULL,''),(1013,'菜单新增',102,2,'','','','',1,0,'F','0','0','system:menu:add','#','admin','2026-06-07 22:27:02','',NULL,''),(1014,'菜单修改',102,3,'','','','',1,0,'F','0','0','system:menu:edit','#','admin','2026-06-07 22:27:02','',NULL,''),(1015,'菜单删除',102,4,'','','','',1,0,'F','0','0','system:menu:remove','#','admin','2026-06-07 22:27:02','',NULL,''),(1016,'部门查询',103,1,'','','','',1,0,'F','0','0','system:dept:query','#','admin','2026-06-07 22:27:02','',NULL,''),(1017,'部门新增',103,2,'','','','',1,0,'F','0','0','system:dept:add','#','admin','2026-06-07 22:27:02','',NULL,''),(1018,'部门修改',103,3,'','','','',1,0,'F','0','0','system:dept:edit','#','admin','2026-06-07 22:27:02','',NULL,''),(1019,'部门删除',103,4,'','','','',1,0,'F','0','0','system:dept:remove','#','admin','2026-06-07 22:27:02','',NULL,''),(1020,'岗位查询',104,1,'','','','',1,0,'F','0','0','system:post:query','#','admin','2026-06-07 22:27:02','',NULL,''),(1021,'岗位新增',104,2,'','','','',1,0,'F','0','0','system:post:add','#','admin','2026-06-07 22:27:02','',NULL,''),(1022,'岗位修改',104,3,'','','','',1,0,'F','0','0','system:post:edit','#','admin','2026-06-07 22:27:02','',NULL,''),(1023,'岗位删除',104,4,'','','','',1,0,'F','0','0','system:post:remove','#','admin','2026-06-07 22:27:02','',NULL,''),(1024,'岗位导出',104,5,'','','','',1,0,'F','0','0','system:post:export','#','admin','2026-06-07 22:27:02','',NULL,''),(1025,'字典查询',105,1,'#','','','',1,0,'F','0','0','system:dict:query','#','admin','2026-06-07 22:27:02','',NULL,''),(1026,'字典新增',105,2,'#','','','',1,0,'F','0','0','system:dict:add','#','admin','2026-06-07 22:27:02','',NULL,''),(1027,'字典修改',105,3,'#','','','',1,0,'F','0','0','system:dict:edit','#','admin','2026-06-07 22:27:02','',NULL,''),(1028,'字典删除',105,4,'#','','','',1,0,'F','0','0','system:dict:remove','#','admin','2026-06-07 22:27:02','',NULL,''),(1029,'字典导出',105,5,'#','','','',1,0,'F','0','0','system:dict:export','#','admin','2026-06-07 22:27:02','',NULL,''),(1030,'参数查询',106,1,'#','','','',1,0,'F','0','0','system:config:query','#','admin','2026-06-07 22:27:02','',NULL,''),(1031,'参数新增',106,2,'#','','','',1,0,'F','0','0','system:config:add','#','admin','2026-06-07 22:27:02','',NULL,''),(1032,'参数修改',106,3,'#','','','',1,0,'F','0','0','system:config:edit','#','admin','2026-06-07 22:27:02','',NULL,''),(1033,'参数删除',106,4,'#','','','',1,0,'F','0','0','system:config:remove','#','admin','2026-06-07 22:27:02','',NULL,''),(1034,'参数导出',106,5,'#','','','',1,0,'F','0','0','system:config:export','#','admin','2026-06-07 22:27:02','',NULL,''),(1035,'公告查询',107,1,'#','','','',1,0,'F','0','0','system:notice:query','#','admin','2026-06-07 22:27:02','',NULL,''),(1036,'公告新增',107,2,'#','','','',1,0,'F','0','0','system:notice:add','#','admin','2026-06-07 22:27:02','',NULL,''),(1037,'公告修改',107,3,'#','','','',1,0,'F','0','0','system:notice:edit','#','admin','2026-06-07 22:27:02','',NULL,''),(1038,'公告删除',107,4,'#','','','',1,0,'F','0','0','system:notice:remove','#','admin','2026-06-07 22:27:02','',NULL,''),(1039,'操作查询',500,1,'#','','','',1,0,'F','0','0','monitor:operlog:query','#','admin','2026-06-07 22:27:02','',NULL,''),(1040,'操作删除',500,2,'#','','','',1,0,'F','0','0','monitor:operlog:remove','#','admin','2026-06-07 22:27:02','',NULL,''),(1041,'日志导出',500,3,'#','','','',1,0,'F','0','0','monitor:operlog:export','#','admin','2026-06-07 22:27:02','',NULL,''),(1042,'登录查询',501,1,'#','','','',1,0,'F','0','0','monitor:logininfor:query','#','admin','2026-06-07 22:27:02','',NULL,''),(1043,'登录删除',501,2,'#','','','',1,0,'F','0','0','monitor:logininfor:remove','#','admin','2026-06-07 22:27:02','',NULL,''),(1044,'日志导出',501,3,'#','','','',1,0,'F','0','0','monitor:logininfor:export','#','admin','2026-06-07 22:27:02','',NULL,''),(1045,'账户解锁',501,4,'#','','','',1,0,'F','0','0','monitor:logininfor:unlock','#','admin','2026-06-07 22:27:02','',NULL,''),(1046,'在线查询',109,1,'#','','','',1,0,'F','0','0','monitor:online:query','#','admin','2026-06-07 22:27:02','',NULL,''),(1047,'批量强退',109,2,'#','','','',1,0,'F','0','0','monitor:online:batchLogout','#','admin','2026-06-07 22:27:02','',NULL,''),(1048,'单条强退',109,3,'#','','','',1,0,'F','0','0','monitor:online:forceLogout','#','admin','2026-06-07 22:27:02','',NULL,''),(1049,'任务查询',110,1,'#','','','',1,0,'F','0','0','monitor:job:query','#','admin','2026-06-07 22:27:02','',NULL,''),(1050,'任务新增',110,2,'#','','','',1,0,'F','0','0','monitor:job:add','#','admin','2026-06-07 22:27:02','',NULL,''),(1051,'任务修改',110,3,'#','','','',1,0,'F','0','0','monitor:job:edit','#','admin','2026-06-07 22:27:02','',NULL,''),(1052,'任务删除',110,4,'#','','','',1,0,'F','0','0','monitor:job:remove','#','admin','2026-06-07 22:27:02','',NULL,''),(1053,'状态修改',110,5,'#','','','',1,0,'F','0','0','monitor:job:changeStatus','#','admin','2026-06-07 22:27:02','',NULL,''),(1054,'任务导出',110,6,'#','','','',1,0,'F','0','0','monitor:job:export','#','admin','2026-06-07 22:27:02','',NULL,''),(1055,'生成查询',116,1,'#','','','',1,0,'F','0','0','tool:gen:query','#','admin','2026-06-07 22:27:02','',NULL,''),(1056,'生成修改',116,2,'#','','','',1,0,'F','0','0','tool:gen:edit','#','admin','2026-06-07 22:27:02','',NULL,''),(1057,'生成删除',116,3,'#','','','',1,0,'F','0','0','tool:gen:remove','#','admin','2026-06-07 22:27:02','',NULL,''),(1058,'导入代码',116,4,'#','','','',1,0,'F','0','0','tool:gen:import','#','admin','2026-06-07 22:27:02','',NULL,''),(1059,'预览代码',116,5,'#','','','',1,0,'F','0','0','tool:gen:preview','#','admin','2026-06-07 22:27:02','',NULL,''),(1060,'生成代码',116,6,'#','','','',1,0,'F','0','0','tool:gen:code','#','admin','2026-06-07 22:27:02','',NULL,''),(2000,'GameClub',0,4,'/gameclub-portal',NULL,NULL,'',1,0,'M','0','0','','guide','admin','2026-06-07 22:56:42','admin','2026-06-15 00:29:23',''),(2001,'GameClub管理',0,3,'gameclub',NULL,NULL,'',1,0,'M','0','0','','tool','admin',NULL,'admin','2026-06-13 14:40:04',''),(2002,'游戏分区',2001,1,'partition','gameclub/partition/index',NULL,'',1,0,'C','0','0','gameclub:partition:list','tree','admin',NULL,'admin',NULL,''),(2003,'游戏分区查询',2002,1,'','',NULL,'',1,0,'F','0','0','gameclub:partition:query','#','admin',NULL,'admin',NULL,''),(2004,'游戏分区新增',2002,2,'','',NULL,'',1,0,'F','0','0','gameclub:partition:add','#','admin',NULL,'admin',NULL,''),(2005,'游戏分区修改',2002,3,'','',NULL,'',1,0,'F','0','0','gameclub:partition:edit','#','admin',NULL,'admin',NULL,''),(2006,'游戏分区删除',2002,4,'','',NULL,'',1,0,'F','0','0','gameclub:partition:remove','#','admin',NULL,'admin',NULL,''),(2007,'游戏分区导出',2002,5,'','',NULL,'',1,0,'F','0','0','gameclub:partition:export','#','admin',NULL,'admin',NULL,''),(2008,'工会管理',2001,2,'guild','gameclub/guild/index',NULL,'',1,0,'C','0','0','gameclub:guild:list','peoples','admin',NULL,'admin',NULL,''),(2009,'工会查询',2008,1,'','',NULL,'',1,0,'F','0','0','gameclub:guild:query','#','admin',NULL,'admin',NULL,''),(2010,'工会新增',2008,2,'','',NULL,'',1,0,'F','0','0','gameclub:guild:add','#','admin',NULL,'admin',NULL,''),(2011,'工会修改',2008,3,'','',NULL,'',1,0,'F','0','0','gameclub:guild:edit','#','admin',NULL,'admin',NULL,''),(2012,'工会删除',2008,4,'','',NULL,'',1,0,'F','0','0','gameclub:guild:remove','#','admin',NULL,'admin',NULL,''),(2021,'工会成员',2001,3,'member','gameclub/member/index',NULL,'',1,0,'C','0','0','gameclub:member:list','peoples','admin',NULL,'admin',NULL,''),(2022,'工会成员查询',2021,1,'','',NULL,'',1,0,'F','0','0','gameclub:member:query','#','admin',NULL,'admin',NULL,''),(2023,'工会成员新增',2021,2,'','',NULL,'',1,0,'F','0','0','gameclub:member:add','#','admin',NULL,'admin',NULL,''),(2024,'工会成员修改',2021,3,'','',NULL,'',1,0,'F','0','0','gameclub:member:edit','#','admin',NULL,'admin',NULL,''),(2025,'工会成员删除',2021,4,'','',NULL,'',1,0,'F','0','0','gameclub:member:remove','#','admin',NULL,'admin',NULL,''),(2026,'工会成员退出',2021,5,'','',NULL,'',1,0,'F','0','0','gameclub:member:quit','#','admin',NULL,'admin',NULL,''),(2027,'工会任务',2001,3,'task','gameclub/task/index',NULL,'',1,0,'C','0','0','gameclub:task:list','cascader','admin',NULL,'admin',NULL,''),(2028,'工会任务查询',2027,1,'','',NULL,'',1,0,'F','0','0','gameclub:task:query','#','admin',NULL,'admin',NULL,''),(2029,'工会任务新增',2027,2,'','',NULL,'',1,0,'F','0','0','gameclub:task:add','#','admin',NULL,'admin',NULL,''),(2030,'工会任务修改',2027,3,'','',NULL,'',1,0,'F','0','0','gameclub:task:edit','#','admin',NULL,'admin',NULL,''),(2031,'工会任务删除',2027,4,'','',NULL,'',1,0,'F','0','0','gameclub:task:remove','#','admin',NULL,'admin',NULL,''),(2037,'工会公告',2001,3,'announcement','gameclub/announcement/index',NULL,'',1,0,'C','0','0','gameclub:announcement:list','edit','admin',NULL,'admin',NULL,''),(2038,'工会申请',2001,4,'application','gameclub/application/index',NULL,'',1,0,'C','0','0','gameclub:application:list','form','admin',NULL,'admin',NULL,''),(3002,'建会申请',2001,7,'guildCreateApp','gameclub/guildCreateApp/index',NULL,'',1,0,'C','0','0','gameclub:guildCreateApp:list','building','admin',NULL,'admin',NULL,''),(3003,'申请查询',3002,1,'','',NULL,'',1,0,'F','0','0','gameclub:guildCreateApp:query','#','admin',NULL,'admin',NULL,''),(3004,'申请审批',3002,2,'','',NULL,'',1,0,'F','0','0','gameclub:guildCreateApp:approve','#','admin',NULL,'admin',NULL,''),(3005,'申请删除',3002,3,'','',NULL,'',1,0,'F','0','0','gameclub:guildCreateApp:remove','#','admin',NULL,'admin',NULL,'');
/*!40000 ALTER TABLE `sys_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_notice`
--

DROP TABLE IF EXISTS `sys_notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_notice` (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob COMMENT '公告内容',
  `status` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='通知公告表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_notice`
--

LOCK TABLES `sys_notice` WRITE;
/*!40000 ALTER TABLE `sys_notice` DISABLE KEYS */;
INSERT INTO `sys_notice` VALUES (1,'温馨提醒：2018-07-01 若依新版本发布啦','2',_binary '新版本内容','0','admin','2026-06-07 22:27:02','',NULL,'管理员'),(2,'维护通知：2018-07-01 若依系统凌晨维护','1',_binary '维护内容','0','admin','2026-06-07 22:27:02','',NULL,'管理员'),(3,'若依开源框架介绍','1',_binary '<p><span style=\"color: rgb(230, 0, 0);\">项目介绍</span></p><p><font color=\"#333333\">RuoYi开源项目是为企业用户定制的后台脚手架框架，为企业打造的一站式解决方案，降低企业开发成本，提升开发效率。主要包括用户管理、角色管理、部门管理、菜单管理、参数管理、字典管理、</font><span style=\"color: rgb(51, 51, 51);\">岗位管理</span><span style=\"color: rgb(51, 51, 51);\">、定时任务</span><span style=\"color: rgb(51, 51, 51);\">、</span><span style=\"color: rgb(51, 51, 51);\">服务监控、登录日志、操作日志、代码生成等功能。其中，还支持多数据源、数据权限、国际化、Redis缓存、Docker部署、滑动验证码、第三方认证登录、分布式事务、</span><font color=\"#333333\">分布式文件存储</font><span style=\"color: rgb(51, 51, 51);\">、分库分表处理等技术特点。</span></p><p><img src=\"https://foruda.gitee.com/images/1773931848342439032/a4d22313_1815095.png\" style=\"width: 64px;\"><br></p><p><span style=\"color: rgb(230, 0, 0);\">官网及演示</span></p><p><span style=\"color: rgb(51, 51, 51);\">若依官网地址：&nbsp;</span><a href=\"http://ruoyi.vip\" target=\"_blank\">http://ruoyi.vip</a><a href=\"http://ruoyi.vip\" target=\"_blank\"></a></p><p><span style=\"color: rgb(51, 51, 51);\">若依文档地址：&nbsp;</span><a href=\"http://doc.ruoyi.vip\" target=\"_blank\">http://doc.ruoyi.vip</a><br></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【不分离版】：&nbsp;</span><a href=\"http://demo.ruoyi.vip\" target=\"_blank\">http://demo.ruoyi.vip</a></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【分离版本】：&nbsp;</span><a href=\"http://vue.ruoyi.vip\" target=\"_blank\">http://vue.ruoyi.vip</a></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【微服务版】：&nbsp;</span><a href=\"http://cloud.ruoyi.vip\" target=\"_blank\">http://cloud.ruoyi.vip</a></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【移动端版】：&nbsp;</span><a href=\"http://h5.ruoyi.vip\" target=\"_blank\">http://h5.ruoyi.vip</a></p><p><br style=\"color: rgb(48, 49, 51); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px;\"></p>','0','admin','2026-06-07 22:27:02','',NULL,'管理员');
/*!40000 ALTER TABLE `sys_notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_notice_read`
--

DROP TABLE IF EXISTS `sys_notice_read`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_notice_read` (
  `read_id` bigint NOT NULL AUTO_INCREMENT COMMENT '已读主键',
  `notice_id` int NOT NULL COMMENT '公告id',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `read_time` datetime NOT NULL COMMENT '阅读时间',
  PRIMARY KEY (`read_id`),
  UNIQUE KEY `uk_user_notice` (`user_id`,`notice_id`) COMMENT '同一用户同一公告只记录一次'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='公告已读记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_notice_read`
--

LOCK TABLES `sys_notice_read` WRITE;
/*!40000 ALTER TABLE `sys_notice_read` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_notice_read` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_oper_log`
--

DROP TABLE IF EXISTS `sys_oper_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_oper_log` (
  `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '模块标题',
  `business_type` int DEFAULT '0' COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '请求方式',
  `operator_type` int DEFAULT '0' COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '返回参数',
  `status` int DEFAULT '0' COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint DEFAULT '0' COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`),
  KEY `idx_sys_oper_log_bt` (`business_type`),
  KEY `idx_sys_oper_log_s` (`status`),
  KEY `idx_sys_oper_log_ot` (`oper_time`)
) ENGINE=InnoDB AUTO_INCREMENT=245 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='操作日志记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_oper_log`
--

LOCK TABLES `sys_oper_log` WRITE;
/*!40000 ALTER TABLE `sys_oper_log` DISABLE KEYS */;
INSERT INTO `sys_oper_log` VALUES (100,'角色管理',2,'com.ruoyi.web.controller.system.SysRoleController.changeStatus()','PUT',1,'admin','研发部门','/system/role/changeStatus','127.0.0.1','内网IP','{\"admin\":true,\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":1,\"status\":\"1\"} ',NULL,1,'不允许操作超级管理员角色','2026-06-07 22:29:32',8),(101,'部门管理',3,'com.ruoyi.web.controller.system.SysDeptController.remove()','DELETE',1,'admin','研发部门','/system/dept/107','127.0.0.1','内网IP','107 ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 22:30:18',13),(102,'部门管理',3,'com.ruoyi.web.controller.system.SysDeptController.remove()','DELETE',1,'admin','研发部门','/system/dept/109','127.0.0.1','内网IP','109 ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 22:30:20',11),(103,'部门管理',3,'com.ruoyi.web.controller.system.SysDeptController.remove()','DELETE',1,'admin','研发部门','/system/dept/108','127.0.0.1','内网IP','108 ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 22:30:21',10),(104,'部门管理',3,'com.ruoyi.web.controller.system.SysDeptController.remove()','DELETE',1,'admin','研发部门','/system/dept/102','127.0.0.1','内网IP','102 ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 22:30:24',10),(105,'部门管理',3,'com.ruoyi.web.controller.system.SysDeptController.remove()','DELETE',1,'admin','研发部门','/system/dept/106','127.0.0.1','内网IP','106 ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 22:30:25',11),(106,'部门管理',3,'com.ruoyi.web.controller.system.SysDeptController.remove()','DELETE',1,'admin','研发部门','/system/dept/105','127.0.0.1','内网IP','105 ','{\"msg\":\"部门存在用户,不允许删除\",\"code\":601}',0,NULL,'2026-06-07 22:30:26',4),(107,'部门管理',3,'com.ruoyi.web.controller.system.SysDeptController.remove()','DELETE',1,'admin','研发部门','/system/dept/104','127.0.0.1','内网IP','104 ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 22:30:29',14),(108,'参数管理',2,'com.ruoyi.web.controller.system.SysConfigController.edit()','PUT',1,'admin','研发部门','/system/config','127.0.0.1','内网IP','{\"configId\":5,\"configKey\":\"sys.account.registerUser\",\"configName\":\"账号自助-是否开启用户注册功能\",\"configType\":\"Y\",\"configValue\":\"true\",\"createBy\":\"admin\",\"createTime\":\"2026-06-07 22:27:02\",\"params\":{},\"remark\":\"是否开启注册用户功能（true开启，false关闭）\",\"updateBy\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 22:44:54',18),(109,'部门管理',2,'com.ruoyi.web.controller.system.SysDeptController.edit()','PUT',1,'admin','研发部门','/system/dept','127.0.0.1','内网IP','{\"ancestors\":\"\",\"children\":[],\"deptId\":100,\"deptName\":\"网站汇总\",\"email\":\"2517487412@qq.com\",\"leader\":\"YuKki\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"phone\":\"15729728627\",\"status\":\"0\",\"updateBy\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 22:54:09',16),(110,'部门管理',1,'com.ruoyi.web.controller.system.SysDeptController.add()','POST',1,'admin','研发部门','/system/dept','127.0.0.1','内网IP','{\"ancestors\":\",100\",\"children\":[],\"createBy\":\"admin\",\"deptName\":\"GameClub工会\",\"email\":\"2517487412@qq.com\",\"leader\":\"YuKki\",\"orderNum\":1,\"params\":{},\"parentId\":100,\"phone\":\"15729728627\",\"status\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 22:54:50',12),(111,'部门管理',2,'com.ruoyi.web.controller.system.SysDeptController.edit()','PUT',1,'admin','研发部门','/system/dept','127.0.0.1','内网IP','{\"ancestors\":\",100\",\"children\":[],\"deptId\":201,\"deptName\":\"GameClub\",\"email\":\"2517487412@qq.com\",\"leader\":\"YuKki\",\"orderNum\":1,\"params\":{},\"parentId\":100,\"parentName\":\"网站汇总\",\"phone\":\"15729728627\",\"status\":\"0\",\"updateBy\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 22:55:13',20),(112,'部门管理',2,'com.ruoyi.web.controller.system.SysDeptController.edit()','PUT',1,'admin','研发部门','/system/dept','127.0.0.1','内网IP','{\"ancestors\":\",100\",\"children\":[],\"deptId\":201,\"deptName\":\"GameClub\",\"email\":\"2517487412@qq.com\",\"leader\":\"YuKki\",\"orderNum\":2,\"params\":{},\"parentId\":100,\"parentName\":\"网站汇总\",\"phone\":\"15729728627\",\"status\":\"0\",\"updateBy\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 22:55:21',21),(113,'菜单管理',1,'com.ruoyi.web.controller.system.SysMenuController.add()','POST',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createBy\":\"admin\",\"icon\":\"guide\",\"isCache\":\"0\",\"isFrame\":\"0\",\"menuName\":\"GameClub\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"https://\",\"status\":\"0\",\"visible\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 22:56:42',21),(114,'部门管理',1,'com.ruoyi.web.controller.system.SysDeptController.add()','POST',1,'admin','研发部门','/system/dept','127.0.0.1','内网IP','{\"ancestors\":\",100,201\",\"children\":[],\"createBy\":\"admin\",\"deptName\":\"英雄联盟\",\"orderNum\":1,\"params\":{},\"parentId\":201,\"status\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 22:57:49',14),(115,'部门管理',1,'com.ruoyi.web.controller.system.SysDeptController.add()','POST',1,'admin','研发部门','/system/dept','127.0.0.1','内网IP','{\"ancestors\":\",100,201\",\"children\":[],\"createBy\":\"admin\",\"deptName\":\"王者荣耀\",\"orderNum\":1,\"params\":{},\"parentId\":201,\"status\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 22:58:36',9),(116,'部门管理',1,'com.ruoyi.web.controller.system.SysDeptController.add()','POST',1,'admin','研发部门','/system/dept','127.0.0.1','内网IP','{\"ancestors\":\",100,201,202\",\"children\":[],\"createBy\":\"admin\",\"deptName\":\"YuKki工会\",\"email\":\"2517487412@qq.com\",\"leader\":\"YuKki\",\"orderNum\":1,\"params\":{},\"parentId\":202,\"phone\":\"15729728627\",\"status\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:00:57',11),(117,'部门管理',1,'com.ruoyi.web.controller.system.SysDeptController.add()','POST',1,'admin','研发部门','/system/dept','127.0.0.1','内网IP','{\"ancestors\":\",100,201\",\"children\":[],\"createBy\":\"admin\",\"deptName\":\"无工会用户\",\"orderNum\":0,\"params\":{},\"parentId\":201,\"status\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:01:46',10),(118,'部门管理',1,'com.ruoyi.web.controller.system.SysDeptController.add()','POST',1,'admin','研发部门','/system/dept','127.0.0.1','内网IP','{\"ancestors\":\",100,201,203\",\"children\":[],\"createBy\":\"admin\",\"deptName\":\"AAA工会\",\"leader\":\"\",\"orderNum\":0,\"params\":{},\"parentId\":203,\"status\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:02:22',13),(119,'保存部门排序',2,'com.ruoyi.web.controller.system.SysDeptController.updateSort()','PUT',1,'admin','研发部门','/system/dept/updateSort','127.0.0.1','内网IP','{\"deptIds\":\"205\",\"orderNums\":\"2\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:03:11',21),(120,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"monitor/job/index\",\"createTime\":\"2026-06-07 22:27:02\",\"icon\":\"job\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":110,\"menuName\":\"定时任务\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2,\"path\":\"job\",\"perms\":\"monitor:job:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"1\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:11:26',11),(121,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2026-06-07 22:27:01\",\"icon\":\"monitor\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2,\"menuName\":\"系统监控\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"monitor\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:11:53',11),(122,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"monitor/druid/index\",\"createTime\":\"2026-06-07 22:27:02\",\"icon\":\"druid\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":111,\"menuName\":\"数据监控\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":2,\"path\":\"druid\",\"perms\":\"monitor:druid:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"1\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:12:00',9),(123,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"monitor/server/index\",\"createTime\":\"2026-06-07 22:27:02\",\"icon\":\"server\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":112,\"menuName\":\"服务监控\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":2,\"path\":\"server\",\"perms\":\"monitor:server:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"1\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:12:04',87),(124,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"monitor/cache/index\",\"createTime\":\"2026-06-07 22:27:02\",\"icon\":\"redis\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":113,\"menuName\":\"缓存监控\",\"menuType\":\"C\",\"orderNum\":5,\"params\":{},\"parentId\":2,\"path\":\"cache\",\"perms\":\"monitor:cache:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"1\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:12:08',9),(125,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2026-06-07 22:27:01\",\"icon\":\"tool\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":3,\"menuName\":\"系统工具\",\"menuType\":\"M\",\"orderNum\":3,\"params\":{},\"parentId\":0,\"path\":\"tool\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"1\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:12:17',10),(126,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"tool/build/index\",\"createTime\":\"2026-06-07 22:27:02\",\"icon\":\"build\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":115,\"menuName\":\"表单构建\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":3,\"path\":\"build\",\"perms\":\"tool:build:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"1\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:12:25',12),(127,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"tool/gen/index\",\"createTime\":\"2026-06-07 22:27:02\",\"icon\":\"code\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":116,\"menuName\":\"代码生成\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":3,\"path\":\"gen\",\"perms\":\"tool:gen:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"1\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:12:28',10),(128,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"tool/swagger/index\",\"createTime\":\"2026-06-07 22:27:02\",\"icon\":\"swagger\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":117,\"menuName\":\"系统接口\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":3,\"path\":\"swagger\",\"perms\":\"tool:swagger:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:12:36',23),(129,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"monitor/online/index\",\"createTime\":\"2026-06-07 22:27:02\",\"icon\":\"online\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":109,\"menuName\":\"在线用户\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2,\"path\":\"online\",\"perms\":\"monitor:online:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:13:22',10),(130,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"monitor/cache/list\",\"createTime\":\"2026-06-07 22:27:02\",\"icon\":\"redis-list\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":114,\"menuName\":\"缓存列表\",\"menuType\":\"C\",\"orderNum\":6,\"params\":{},\"parentId\":2,\"path\":\"cacheList\",\"perms\":\"monitor:cache:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:13:47',9),(131,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2026-06-07 22:27:01\",\"icon\":\"guide\",\"isCache\":\"0\",\"isFrame\":\"0\",\"menuId\":4,\"menuName\":\"若依官网\",\"menuType\":\"M\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"http://ruoyi.vip\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:14:51',9),(132,'保存菜单排序',2,'com.ruoyi.web.controller.system.SysMenuController.updateSort()','PUT',1,'admin','研发部门','/system/menu/updateSort','127.0.0.1','内网IP','{\"menuIds\":\"2000\",\"orderNums\":\"4\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:14:56',8),(133,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"system/notice/index\",\"createTime\":\"2026-06-07 22:27:01\",\"icon\":\"message\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":107,\"menuName\":\"通知公告\",\"menuType\":\"C\",\"orderNum\":8,\"params\":{},\"parentId\":1,\"path\":\"notice\",\"perms\":\"system:notice:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:18:13',9),(134,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"\",\"createTime\":\"2026-06-07 22:27:01\",\"icon\":\"log\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":108,\"menuName\":\"日志管理\",\"menuType\":\"M\",\"orderNum\":9,\"params\":{},\"parentId\":1,\"path\":\"log\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:18:17',9),(135,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"system/dict/index\",\"createTime\":\"2026-06-07 22:27:01\",\"icon\":\"dict\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":105,\"menuName\":\"字典管理\",\"menuType\":\"C\",\"orderNum\":6,\"params\":{},\"parentId\":1,\"path\":\"dict\",\"perms\":\"system:dict:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:19:04',10),(136,'用户管理',1,'com.ruoyi.web.controller.system.SysUserController.add()','POST',1,'admin','研发部门','/system/user','127.0.0.1','内网IP','{\"admin\":false,\"createBy\":\"admin\",\"deptId\":202,\"email\":\"2517487412@qq.com\",\"nickName\":\"YuKki\",\"params\":{},\"phonenumber\":\"15729728627\",\"postIds\":[1],\"roleIds\":[2],\"sex\":\"0\",\"status\":\"0\",\"userId\":100,\"userName\":\"YuKki\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:20:42',82),(137,'用户管理',1,'com.ruoyi.web.controller.system.SysUserController.add()','POST',1,'admin','研发部门','/system/user','127.0.0.1','内网IP','{\"admin\":false,\"deptId\":204,\"email\":\"2517487412@qq.com\",\"nickName\":\"YuKki\",\"params\":{},\"phonenumber\":\"15729728627\",\"postIds\":[1],\"roleIds\":[2],\"sex\":\"0\",\"status\":\"0\",\"userName\":\"YuKki\"} ','{\"msg\":\"新增用户\'YuKki\'失败，登录账号已存在\",\"code\":500}',0,NULL,'2026-06-07 23:21:25',2),(138,'用户管理',2,'com.ruoyi.web.controller.system.SysUserController.edit()','PUT',1,'admin','研发部门','/system/user','127.0.0.1','内网IP','{\"admin\":false,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2026-06-07 23:20:42\",\"delFlag\":\"0\",\"dept\":{\"ancestors\":\",100,201\",\"children\":[],\"deptId\":202,\"deptName\":\"英雄联盟\",\"orderNum\":1,\"params\":{},\"parentId\":201,\"status\":\"0\"},\"deptId\":204,\"email\":\"2517487412@qq.com\",\"loginIp\":\"\",\"nickName\":\"YuKki\",\"params\":{},\"phonenumber\":\"15729728627\",\"postIds\":[1],\"roleIds\":[2],\"roles\":[{\"admin\":false,\"dataScope\":\"2\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"普通角色\",\"roleSort\":2,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":100,\"userName\":\"YuKki\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-07 23:21:45',19),(139,'菜单管理',3,'com.ruoyi.web.controller.system.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/2013','127.0.0.1','内网IP','2013 ','{\"msg\":\"存在子菜单,不允许删除\",\"code\":601}',0,NULL,'2026-06-08 00:45:31',18),(140,'菜单管理',3,'com.ruoyi.web.controller.system.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/2017','127.0.0.1','内网IP','2017 ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 00:45:45',17),(141,'菜单管理',3,'com.ruoyi.web.controller.system.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/2016','127.0.0.1','内网IP','2016 ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 00:45:48',13),(142,'菜单管理',3,'com.ruoyi.web.controller.system.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/2014','127.0.0.1','内网IP','2014 ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 00:45:50',12),(143,'菜单管理',3,'com.ruoyi.web.controller.system.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/2015','127.0.0.1','内网IP','2015 ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 00:45:52',11),(144,'菜单管理',3,'com.ruoyi.web.controller.system.SysMenuController.remove()','DELETE',1,'admin',NULL,'/system/menu/2013','127.0.0.1','内网IP','2013 ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 00:45:56',12),(145,'保存菜单排序',2,'com.ruoyi.web.controller.system.SysMenuController.updateSort()','PUT',1,'admin',NULL,'/system/menu/updateSort','127.0.0.1','内网IP','{\"menuIds\":\"2027\",\"orderNums\":\"3\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 00:46:13',18),(146,'保存菜单排序',2,'com.ruoyi.web.controller.system.SysMenuController.updateSort()','PUT',1,'admin',NULL,'/system/menu/updateSort','127.0.0.1','内网IP','{\"menuIds\":\"2001\",\"orderNums\":\"3\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 00:46:35',6),(147,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"icon\":\"tool\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2001,\"menuName\":\"GameClub管理\",\"menuType\":\"M\",\"orderNum\":3,\"params\":{},\"parentId\":0,\"path\":\"gameclub\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 00:47:36',25),(148,'角色管理',2,'com.ruoyi.web.controller.system.SysRoleController.edit()','PUT',1,'admin',NULL,'/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2026-06-07 22:27:01\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,103,1016,1017,1018,1019,104,1020,1021,1022,1023,1024,105,1025,1026,1027,1028,1029,106,1030,1031,1032,1033,1034,107,1035,1036,1037,1038,108,500,1039,1040,1041,501,1042,1043,1044,1045,2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114,3,115,116,1055,1056,1057,1058,1059,1060,117,4,2000],\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"普通角色\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 01:10:06',43),(149,'个人信息',2,'com.ruoyi.web.controller.system.SysProfileController.updateProfile()','PUT',1,'admin',NULL,'/system/user/profile','127.0.0.1','内网IP','{\"admin\":false,\"email\":\"2517487412@qq.com\",\"nickName\":\"YuKki\",\"params\":{},\"phonenumber\":\"15729728627\",\"sex\":\"0\"} ','{\"msg\":\"修改用户\'admin\'失败，手机号码已存在\",\"code\":500}',0,NULL,'2026-06-08 01:11:29',5),(150,'个人信息',2,'com.ruoyi.web.controller.system.SysProfileController.updateProfile()','PUT',1,'admin',NULL,'/system/user/profile','127.0.0.1','内网IP','{\"admin\":false,\"email\":\"2517487412@qq.com\",\"nickName\":\"YuKki\",\"params\":{},\"phonenumber\":\"15729728627\",\"sex\":\"0\"} ','{\"msg\":\"修改用户\'admin\'失败，手机号码已存在\",\"code\":500}',0,NULL,'2026-06-08 01:11:34',3),(151,'个人信息',2,'com.ruoyi.web.controller.system.SysProfileController.updateProfile()','PUT',1,'admin',NULL,'/system/user/profile','127.0.0.1','内网IP','{\"admin\":false,\"email\":\"2517487412@qq.com\",\"nickName\":\"YuKki\",\"params\":{},\"phonenumber\":\"15729728628\",\"sex\":\"0\"} ','{\"msg\":\"修改用户\'admin\'失败，邮箱账号已存在\",\"code\":500}',0,NULL,'2026-06-08 01:11:46',5),(152,'用户管理',3,'com.ruoyi.web.controller.system.SysUserController.remove()','DELETE',1,'admin',NULL,'/system/user/100','127.0.0.1','内网IP','[100] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 01:11:57',14),(153,'个人信息',2,'com.ruoyi.web.controller.system.SysProfileController.updateProfile()','PUT',1,'admin',NULL,'/system/user/profile','127.0.0.1','内网IP','{\"admin\":false,\"email\":\"2517487412@qq.com\",\"nickName\":\"YuKki\",\"params\":{},\"phonenumber\":\"15729728628\",\"sex\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 01:12:02',20),(154,'个人信息',2,'com.ruoyi.web.controller.system.SysProfileController.updateProfile()','PUT',1,'admin',NULL,'/system/user/profile','127.0.0.1','内网IP','{\"admin\":false,\"email\":\"2517487412@qq.com\",\"nickName\":\"YuKki\",\"params\":{},\"phonenumber\":\"15729728627\",\"sex\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 01:12:06',10),(155,'角色管理',2,'com.ruoyi.web.controller.system.SysRoleController.changeStatus()','PUT',1,'admin',NULL,'/system/role/changeStatus','127.0.0.1','内网IP','{\"admin\":true,\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":1,\"status\":\"1\"} ',NULL,1,'不允许操作超级管理员角色','2026-06-08 01:14:23',5),(156,'角色管理',2,'com.ruoyi.web.controller.system.SysRoleController.changeStatus()','PUT',1,'admin',NULL,'/system/role/changeStatus','127.0.0.1','内网IP','{\"admin\":false,\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":2,\"status\":\"1\",\"updateBy\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 01:14:26',7),(157,'角色管理',2,'com.ruoyi.web.controller.system.SysRoleController.changeStatus()','PUT',1,'admin',NULL,'/system/role/changeStatus','127.0.0.1','内网IP','{\"admin\":false,\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":2,\"status\":\"0\",\"updateBy\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 01:14:27',7),(158,'岗位管理',2,'com.ruoyi.web.controller.system.SysPostController.edit()','PUT',1,'admin',NULL,'/system/post','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2026-06-07 22:27:01\",\"flag\":false,\"params\":{},\"postCode\":\"GuildMaster\",\"postId\":1,\"postName\":\"工会会长1\",\"postSort\":1,\"remark\":\"\",\"status\":\"0\",\"updateBy\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 01:14:44',16),(159,'岗位管理',2,'com.ruoyi.web.controller.system.SysPostController.edit()','PUT',1,'admin',NULL,'/system/post','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2026-06-07 22:27:01\",\"flag\":false,\"params\":{},\"postCode\":\"GuildMaster\",\"postId\":1,\"postName\":\"工会会长\",\"postSort\":1,\"remark\":\"\",\"status\":\"0\",\"updateBy\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 01:14:58',9),(160,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin',NULL,'/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"system/dict/index\",\"createTime\":\"2026-06-07 22:27:01\",\"icon\":\"dict\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":105,\"menuName\":\"字典管理\",\"menuType\":\"C\",\"orderNum\":6,\"params\":{},\"parentId\":1,\"path\":\"dict\",\"perms\":\"system:dict:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 01:37:36',17),(161,'岗位管理',1,'com.ruoyi.web.controller.system.SysPostController.add()','POST',1,'admin',NULL,'/system/post','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"flag\":false,\"params\":{},\"postCode\":\"0\",\"postId\":5,\"postName\":\"若依系统管理员\",\"postSort\":0,\"status\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 01:44:58',15),(162,'岗位管理',2,'com.ruoyi.web.controller.system.SysPostController.edit()','PUT',1,'admin',NULL,'/system/post','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2026-06-08 01:44:58\",\"flag\":false,\"params\":{},\"postCode\":\"SuperAdmin\",\"postId\":5,\"postName\":\"若依系统管理员\",\"postSort\":0,\"status\":\"0\",\"updateBy\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 01:45:19',8),(163,'岗位管理',2,'com.ruoyi.web.controller.system.SysPostController.edit()','PUT',1,'admin',NULL,'/system/post','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2026-06-08 01:44:58\",\"flag\":false,\"params\":{},\"postCode\":\"SuperAdmin\",\"postId\":5,\"postName\":\"若依系统管理员\",\"postSort\":5,\"status\":\"0\",\"updateBy\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-08 01:45:36',10),(164,'用户业务网站登记',0,'com.ruoyi.web.controller.system.SysUserDeptController.registerToWebsite()','POST',1,'admin',NULL,'/system/userDept/register/GAMECLUB','127.0.0.1','内网IP','\"GAMECLUB\" ',NULL,1,'\r\n### Error querying database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'ud.created_at\' in \'field list\'\r\n### The error may exist in URL [jar:nested:/D:/RpoJec/RuoYi-Vue/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.9.2.jar!/mapper/system/SysUserDeptMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.SysUserDeptMapper.selectByUserAndWebsite-Inline\r\n### The error occurred while setting parameters\r\n### SQL: SELECT ud.id, ud.user_id, ud.dept_id, ud.website_code,                ud.is_primary, ud.joined_at, ud.created_at, ud.updated_at,                d.dept_name,                wc.website_name         FROM sys_user_dept ud         LEFT JOIN sys_dept d ON ud.dept_id = d.dept_id         LEFT JOIN sys_website_config wc ON ud.website_code = wc.website_code               WHERE ud.user_id = ? AND ud.website_code = ?\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'ud.created_at\' in \'field list\'\n; bad SQL grammar []','2026-06-09 03:42:28',8),(165,'用户业务网站登记',0,'com.ruoyi.web.controller.system.SysUserDeptController.registerToWebsite()','POST',1,'admin',NULL,'/system/userDept/register/GAMECLUB','127.0.0.1','内网IP','\"GAMECLUB\" ','{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"createdAt\":\"2026-06-09 03:44:01\",\"deptId\":205,\"deptName\":\"无工会用户\",\"id\":4,\"isPrimary\":0,\"joinedAt\":\"2026-06-09 03:44:01\",\"params\":{},\"updatedAt\":\"2026-06-09 03:44:01\",\"userId\":1,\"websiteCode\":\"GAMECLUB\",\"websiteName\":\"GameClub游戏工会平台\"}}',0,NULL,'2026-06-09 03:44:01',21),(166,'用户业务网站登记',0,'com.ruoyi.web.controller.system.SysUserDeptController.registerToWebsite()','POST',1,'admin',NULL,'/system/userDept/register/GAMECLUB','127.0.0.1','内网IP','\"GAMECLUB\" ','{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"createdAt\":\"2026-06-09 03:44:01\",\"deptId\":205,\"deptName\":\"无工会用户\",\"id\":4,\"isPrimary\":0,\"joinedAt\":\"2026-06-09 03:44:01\",\"params\":{},\"updatedAt\":\"2026-06-09 03:44:01\",\"userId\":1,\"websiteCode\":\"GAMECLUB\",\"websiteName\":\"GameClub游戏工会平台\"}}',0,NULL,'2026-06-09 03:49:58',15),(167,'游戏分区',1,'com.ruoyi.web.controller.system.GamePartitionController.add()','POST',1,'admin',NULL,'/system/gamePartition','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"gameCode\":\"cf\",\"gameName\":\"1112\",\"params\":{},\"sortOrder\":6,\"status\":1} ',NULL,1,'\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\r\n### The error may exist in URL [jar:nested:/D:/RpoJec/RuoYi-Vue/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.9.2.jar!/mapper/gameclub/GamePartitionMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.GamePartitionMapper.insertGamePartition-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO game_partition (                            game_name,               game_code,                                           sort_order,               status,               create_by,              created_at         ) VALUES (                            ?,               ?,                                           ?,               ?,               ?,              NOW()         )\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\n; bad SQL grammar []','2026-06-09 03:52:36',447),(168,'游戏分区',1,'com.ruoyi.web.controller.system.GamePartitionController.add()','POST',1,'admin',NULL,'/system/gamePartition','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"gameCode\":\"cf\",\"gameName\":\"1112\",\"params\":{},\"sortOrder\":6,\"status\":1} ',NULL,1,'\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\r\n### The error may exist in URL [jar:nested:/D:/RpoJec/RuoYi-Vue/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.9.2.jar!/mapper/gameclub/GamePartitionMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.GamePartitionMapper.insertGamePartition-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO game_partition (                            game_name,               game_code,                                           sort_order,               status,               create_by,              created_at         ) VALUES (                            ?,               ?,                                           ?,               ?,               ?,              NOW()         )\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\n; bad SQL grammar []','2026-06-09 03:52:40',5),(169,'游戏分区',2,'com.ruoyi.web.controller.system.GamePartitionController.changeStatus()','PUT',1,'admin',NULL,'/system/gamePartition/changeStatus','127.0.0.1','内网IP','{\"id\":\"1\",\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-09 03:52:52',9),(170,'游戏分区',2,'com.ruoyi.web.controller.system.GamePartitionController.changeStatus()','PUT',1,'admin',NULL,'/system/gamePartition/changeStatus','127.0.0.1','内网IP','{\"id\":\"1\",\"status\":\"1\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-09 03:53:08',5),(171,'游戏分区',1,'com.ruoyi.web.controller.system.GamePartitionController.add()','POST',1,'admin',NULL,'/system/gamePartition','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"gameCode\":\"1\",\"gameName\":\"1\",\"params\":{},\"sortOrder\":0,\"status\":1} ',NULL,1,'\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\r\n### The error may exist in URL [jar:nested:/D:/RpoJec/RuoYi-Vue/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.9.2.jar!/mapper/gameclub/GamePartitionMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.GamePartitionMapper.insertGamePartition-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO game_partition (                            game_name,               game_code,                                           sort_order,               status,               create_by,              created_at         ) VALUES (                            ?,               ?,                                           ?,               ?,               ?,              NOW()         )\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\n; bad SQL grammar []','2026-06-09 03:53:40',5),(172,'游戏分区',1,'com.ruoyi.web.controller.system.GamePartitionController.add()','POST',1,'admin',NULL,'/system/gamePartition','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"gameCode\":\"1\",\"gameName\":\"1\",\"params\":{},\"sortOrder\":0,\"status\":1} ',NULL,1,'\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\r\n### The error may exist in URL [jar:nested:/D:/RpoJec/RuoYi-Vue/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.9.2.jar!/mapper/gameclub/GamePartitionMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.GamePartitionMapper.insertGamePartition-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO game_partition (                            game_name,               game_code,                                           sort_order,               status,               create_by,              created_at         ) VALUES (                            ?,               ?,                                           ?,               ?,               ?,              NOW()         )\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\n; bad SQL grammar []','2026-06-09 04:08:56',6),(173,'工会',1,'com.ruoyi.web.controller.system.GuildController.add()','POST',1,'admin',NULL,'/system/guild','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"gamePartitionId\":1,\"id\":1,\"memberCount\":0,\"name\":\"114\",\"params\":{},\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-09 04:09:08',44),(174,'工会',3,'com.ruoyi.web.controller.system.GuildController.remove()','DELETE',1,'admin',NULL,'/system/guild/1','127.0.0.1','内网IP','[1] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-09 04:09:50',4),(175,'游戏分区',1,'com.ruoyi.web.controller.system.GamePartitionController.add()','POST',1,'admin',NULL,'/system/gamePartition','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"gameCode\":\"122\",\"gameName\":\"12\",\"params\":{},\"sortOrder\":0,\"status\":1} ',NULL,1,'\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\r\n### The error may exist in URL [jar:nested:/D:/RpoJec/RuoYi-Vue/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.9.2.jar!/mapper/gameclub/GamePartitionMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.GamePartitionMapper.insertGamePartition-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO game_partition (                            game_name,               game_code,                                           sort_order,               status,               create_by,              created_at         ) VALUES (                            ?,               ?,                                           ?,               ?,               ?,              NOW()         )\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\n; bad SQL grammar []','2026-06-09 04:25:46',6),(176,'游戏分区',1,'com.ruoyi.web.controller.system.GamePartitionController.add()','POST',1,'admin',NULL,'/system/gamePartition','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"gameCode\":\"122\",\"gameName\":\"12\",\"params\":{},\"sortOrder\":0,\"status\":1} ',NULL,1,'\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\r\n### The error may exist in URL [jar:nested:/D:/RpoJec/RuoYi-Vue/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.9.2.jar!/mapper/gameclub/GamePartitionMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.GamePartitionMapper.insertGamePartition-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO game_partition (                            game_name,               game_code,                                           sort_order,               status,               create_by,              created_at         ) VALUES (                            ?,               ?,                                           ?,               ?,               ?,              NOW()         )\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\n; bad SQL grammar []','2026-06-09 04:25:50',5),(177,'游戏分区',1,'com.ruoyi.web.controller.system.GamePartitionController.add()','POST',1,'admin',NULL,'/system/gamePartition','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"gameCode\":\"1\",\"gameName\":\"11\",\"params\":{},\"sortOrder\":0,\"status\":1} ',NULL,1,'\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\r\n### The error may exist in URL [jar:nested:/D:/RpoJec/RuoYi-Vue/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.9.2.jar!/mapper/gameclub/GamePartitionMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.GamePartitionMapper.insertGamePartition-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO game_partition (                            game_name,               game_code,                                           sort_order,               status,               create_by,              created_at         ) VALUES (                            ?,               ?,                                           ?,               ?,               ?,              NOW()         )\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\n; bad SQL grammar []','2026-06-09 04:26:53',5),(178,'游戏分区',1,'com.ruoyi.web.controller.system.GamePartitionController.add()','POST',1,'admin',NULL,'/system/gamePartition','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"deptId\":207,\"gameCode\":\"1\",\"gameName\":\"1\",\"id\":7,\"params\":{},\"sortOrder\":0,\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-09 10:05:25',38),(179,'游戏分区',3,'com.ruoyi.web.controller.system.GamePartitionController.remove()','DELETE',1,'admin',NULL,'/system/gamePartition/7','127.0.0.1','内网IP','[7] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-09 10:05:29',7),(180,'部门管理',3,'com.ruoyi.web.controller.system.SysDeptController.remove()','DELETE',1,'admin',NULL,'/system/dept/207','127.0.0.1','内网IP','207 ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-09 10:06:33',10),(181,'游戏分区',3,'com.ruoyi.web.controller.system.GamePartitionController.remove()','DELETE',1,'admin',NULL,'/system/gamePartition/6','127.0.0.1','内网IP','[6] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-09 12:43:58',20),(182,'工会',1,'com.ruoyi.web.controller.system.GuildController.add()','POST',1,'admin',NULL,'/system/guild','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"deptId\":208,\"gamePartitionId\":1,\"id\":2,\"memberCount\":0,\"name\":\"1145\",\"params\":{},\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-09 12:44:09',48),(183,'工会',3,'com.ruoyi.web.controller.system.GuildController.remove()','DELETE',1,'admin',NULL,'/system/guild/2','127.0.0.1','内网IP','[2] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-09 12:44:44',13),(184,'工会',1,'com.ruoyi.web.controller.system.GuildController.add()','POST',1,'admin',NULL,'/system/guild','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"deptId\":209,\"description\":\"1\",\"gamePartitionId\":1,\"id\":3,\"memberCount\":0,\"name\":\"1\",\"params\":{},\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-09 12:46:04',17),(185,'工会',3,'com.ruoyi.web.controller.system.GuildController.remove()','DELETE',1,'admin',NULL,'/system/guild/3','127.0.0.1','内网IP','[3] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-09 12:46:07',11),(186,'工会',1,'com.ruoyi.web.controller.system.GuildController.add()','POST',1,'admin',NULL,'/system/guild','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"deptId\":210,\"description\":\"1\",\"gamePartitionId\":1,\"id\":4,\"memberCount\":0,\"name\":\"1\",\"params\":{},\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-09 12:52:33',15),(187,'工会',3,'com.ruoyi.web.controller.system.GuildController.remove()','DELETE',1,'admin',NULL,'/system/guild/4','127.0.0.1','内网IP','[4] ','{\"msg\":\"操作失败\",\"code\":500}',0,NULL,'2026-06-09 12:52:59',3),(188,'工会',1,'com.ruoyi.web.controller.system.GuildController.add()','POST',1,'admin',NULL,'/system/guild','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"deptId\":211,\"description\":\"5\",\"gamePartitionId\":1,\"id\":5,\"memberCount\":0,\"name\":\"5\",\"params\":{},\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-09 12:53:07',16),(189,'工会',3,'com.ruoyi.web.controller.system.GuildController.remove()','DELETE',1,'admin',NULL,'/system/guild/5','127.0.0.1','内网IP','[5] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-09 12:53:40',18),(190,'工会',1,'com.ruoyi.web.controller.system.GuildController.add()','POST',1,'admin',NULL,'/system/guild','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"deptId\":212,\"gamePartitionId\":1,\"id\":6,\"memberCount\":0,\"name\":\"111\",\"params\":{},\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-09 13:04:58',164),(191,'工会',3,'com.ruoyi.web.controller.system.GuildController.remove()','DELETE',1,'admin',NULL,'/system/guild/6','127.0.0.1','内网IP','[6] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-09 13:05:14',16),(192,'游戏分区',1,'com.ruoyi.web.controller.system.GamePartitionController.add()','POST',1,'admin',NULL,'/system/gamePartition','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"deptId\":213,\"gameCode\":\"none\",\"gameName\":\"无工会\",\"id\":8,\"params\":{},\"sortOrder\":0,\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-10 00:48:38',44),(193,'工会',1,'com.ruoyi.web.controller.system.GuildController.add()','POST',1,'admin',NULL,'/system/guild','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"deptId\":217,\"gamePartitionId\":5,\"id\":7,\"memberCount\":0,\"name\":\"121\",\"params\":{},\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-10 01:30:48',235),(194,'游戏分区',3,'com.ruoyi.web.controller.system.GamePartitionController.remove()','DELETE',1,'admin',NULL,'/system/gamePartition/5','127.0.0.1','内网IP','[5] ',NULL,1,'\r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Cannot delete or update a parent row: a foreign key constraint fails (`ry_vue`.`guild`, CONSTRAINT `fk_guild_partition` FOREIGN KEY (`game_partition_id`) REFERENCES `game_partition` (`id`))\r\n### The error may exist in URL [jar:file:/C:/Users/25174/.m2/repository/com/ruoyi/ruoyi-system/3.9.2/ruoyi-system-3.9.2.jar!/mapper/gameclub/GamePartitionMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.GamePartitionMapper.deleteGamePartitionById-Inline\r\n### The error occurred while setting parameters\r\n### SQL: DELETE FROM game_partition WHERE id = ?\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Cannot delete or update a parent row: a foreign key constraint fails (`ry_vue`.`guild`, CONSTRAINT `fk_guild_partition` FOREIGN KEY (`game_partition_id`) REFERENCES `game_partition` (`id`))\n; Cannot delete or update a parent row: a foreign key constraint fails (`ry_vue`.`guild`, CONSTRAINT `fk_guild_partition` FOREIGN KEY (`game_partition_id`) REFERENCES `game_partition` (`id`))','2026-06-10 01:49:09',482),(195,'工会',3,'com.ruoyi.web.controller.system.GuildController.remove()','DELETE',1,'admin',NULL,'/system/guild/7','127.0.0.1','内网IP','[7] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-10 01:49:16',41),(196,'游戏分区',3,'com.ruoyi.web.controller.system.GamePartitionController.remove()','DELETE',1,'admin',NULL,'/system/gamePartition/5','127.0.0.1','内网IP','[5] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-10 01:49:20',8),(197,'游戏分区',3,'com.ruoyi.web.controller.system.GamePartitionController.remove()','DELETE',1,'admin',NULL,'/system/gamePartition/8','127.0.0.1','内网IP','[8] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-10 01:49:51',11),(198,'游戏分区',1,'com.ruoyi.web.controller.system.GamePartitionController.add()','POST',1,'admin','网站汇总','/system/gamePartition','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"gameCode\":\"lol\",\"gameName\":\"英雄联盟\",\"params\":{},\"sortOrder\":0,\"status\":1} ',NULL,1,'游戏编码已存在，请重新输入！','2026-06-10 03:09:15',16),(199,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','网站汇总','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"icon\":\"tool\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2001,\"menuName\":\"GameClub管理\",\"menuType\":\"M\",\"orderNum\":3,\"params\":{},\"parentId\":0,\"path\":\"gameclub\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-13 14:40:04',35),(200,'游戏分区',1,'com.ruoyi.web.controller.system.GamePartitionController.add()','POST',1,'admin','网站汇总','/system/gamePartition','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"gameCode\":\"lol\",\"gameName\":\"英雄联盟\",\"params\":{},\"sortOrder\":0,\"status\":1} ',NULL,1,'游戏编码已存在，请重新输入！','2026-06-13 15:44:04',29),(201,'工会',1,'com.ruoyi.web.controller.system.GuildController.add()','POST',1,'admin','网站汇总','/system/guild','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"deptId\":218,\"gamePartitionId\":1,\"id\":8,\"memberCount\":0,\"name\":\"YuKki工会\",\"params\":{},\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-13 15:52:02',35),(202,'角色管理',4,'com.ruoyi.web.controller.system.SysRoleController.selectAuthUserAll()','PUT',1,'admin','网站汇总','/system/role/authUser/selectAll','127.0.0.1','内网IP','{\"roleId\":\"2\",\"userIds\":\"3\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-13 16:13:48',27),(203,'角色管理',2,'com.ruoyi.web.controller.system.SysRoleController.dataScope()','PUT',1,'admin','网站汇总','/system/role/dataScope','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2026-06-07 22:27:01\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":false,\"deptIds\":[100],\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"普通角色\",\"roleSort\":2,\"status\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-13 16:15:09',47),(204,'角色管理',2,'com.ruoyi.web.controller.system.SysRoleController.edit()','PUT',1,'admin','网站汇总','/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2026-06-07 22:27:01\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"menuIds\":[100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,103,1016,1017,1018,1019,104,1020,1021,1022,1023,1024,105,1025,1026,1027,1028,1029,106,1030,1031,1032,1033,1034,107,1035,1036,1037,1038,108,500,1039,1040,1041,501,1042,1043,1044,1045,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114,115,116,1055,1056,1057,1058,1059,1060,117,4,2000],\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"普通角色\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-13 16:15:16',24),(205,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','网站汇总','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2026-06-07 22:56:42\",\"icon\":\"guide\",\"isCache\":\"0\",\"isFrame\":\"0\",\"menuId\":2000,\"menuName\":\"GameClub\",\"menuType\":\"M\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"http://localhost:80/gameclub-portal\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 14:26:41',44),(206,'工会申请',2,'com.ruoyi.web.controller.system.GuildApplicationController.approve()','PUT',1,'admin','网站汇总','/system/guildApplication/approve','127.0.0.1','内网IP','{\"id\":1,\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 15:21:46',24),(207,'工会申请',2,'com.ruoyi.web.controller.system.GuildApplicationController.approve()','PUT',1,'admin','网站汇总','/system/guildApplication/approve','127.0.0.1','内网IP','{\"id\":2,\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 16:05:59',22),(208,'工会成员',2,'com.ruoyi.web.controller.system.GuildMemberController.edit()','PUT',1,'admin','网站汇总','/system/guildMember','127.0.0.1','内网IP','{\"createdAt\":\"2026-06-14 16:00:43\",\"gamePartitionId\":1,\"gamePartitionName\":\"英雄联盟\",\"guildId\":8,\"guildName\":\"YuKki工会\",\"id\":1,\"joinTime\":\"2026-06-14 16:00:43\",\"nickName\":\"YuKki\",\"params\":{},\"role\":1,\"status\":1,\"updatedAt\":\"2026-06-14 16:00:43\",\"userId\":1,\"userName\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 16:07:09',10),(209,'工会成员',2,'com.ruoyi.web.controller.system.GuildMemberController.edit()','PUT',1,'admin','网站汇总','/system/guildMember','127.0.0.1','内网IP','{\"createdAt\":\"2026-06-14 16:00:43\",\"gamePartitionId\":1,\"gamePartitionName\":\"英雄联盟\",\"guildId\":8,\"guildName\":\"YuKki工会\",\"id\":1,\"joinTime\":\"2026-06-14 16:00:43\",\"nickName\":\"YuKki\",\"params\":{},\"role\":2,\"status\":1,\"updatedAt\":\"2026-06-14 16:07:09\",\"userId\":1,\"userName\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 16:07:14',7),(210,'工会成员',2,'com.ruoyi.web.controller.system.GuildMemberController.edit()','PUT',1,'admin','网站汇总','/system/guildMember','127.0.0.1','内网IP','{\"createdAt\":\"2026-06-14 16:00:43\",\"gamePartitionId\":1,\"gamePartitionName\":\"英雄联盟\",\"guildId\":8,\"guildName\":\"YuKki工会\",\"id\":1,\"joinTime\":\"2026-06-14 16:00:43\",\"nickName\":\"YuKki\",\"params\":{},\"role\":1,\"status\":1,\"updatedAt\":\"2026-06-14 16:07:14\",\"userId\":1,\"userName\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 16:07:17',6),(211,'工会成员',2,'com.ruoyi.web.controller.system.GuildMemberController.edit()','PUT',1,'admin','网站汇总','/system/guildMember','127.0.0.1','内网IP','{\"createdAt\":\"2026-06-14 16:00:43\",\"gamePartitionId\":1,\"gamePartitionName\":\"英雄联盟\",\"guildId\":8,\"guildName\":\"YuKki工会\",\"id\":1,\"joinTime\":\"2026-06-14 16:00:43\",\"nickName\":\"YuKki\",\"params\":{},\"role\":3,\"status\":1,\"updatedAt\":\"2026-06-14 16:07:17\",\"userId\":1,\"userName\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 16:07:35',10),(212,'工会申请',2,'com.ruoyi.web.controller.system.GuildApplicationController.approve()','PUT',1,'admin','网站汇总','/system/guildApplication/approve','127.0.0.1','内网IP','{\"id\":3,\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 16:33:42',27),(213,'工会成员',2,'com.ruoyi.web.controller.system.GuildMemberController.edit()','PUT',1,'admin','网站汇总','/system/guildMember','127.0.0.1','内网IP','{\"createdAt\":\"2026-06-14 16:00:43\",\"gamePartitionId\":1,\"gamePartitionName\":\"英雄联盟\",\"guildId\":8,\"guildName\":\"YuKki工会\",\"id\":1,\"joinTime\":\"2026-06-14 16:00:43\",\"nickName\":\"YuKki\",\"params\":{},\"role\":1,\"status\":1,\"updatedAt\":\"2026-06-14 16:07:35\",\"userId\":1,\"userName\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 16:34:37',11),(214,'工会成员',2,'com.ruoyi.web.controller.system.GuildMemberController.edit()','PUT',1,'admin','网站汇总','/system/guildMember','127.0.0.1','内网IP','{\"createdAt\":\"2026-06-14 16:36:46\",\"gamePartitionId\":1,\"gamePartitionName\":\"英雄联盟\",\"guildId\":8,\"guildName\":\"YuKki工会\",\"id\":6,\"joinTime\":\"2026-06-14 16:36:46\",\"nickName\":\"sk\",\"params\":{},\"role\":2,\"status\":1,\"updatedAt\":\"2026-06-14 16:36:46\",\"userId\":3,\"userName\":\"sk\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 16:41:05',10),(215,'工会成员',3,'com.ruoyi.web.controller.system.GuildMemberController.remove()','DELETE',1,'admin','网站汇总','/system/guildMember/5','127.0.0.1','内网IP','[5] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 16:52:59',54),(216,'工会成员',2,'com.ruoyi.web.controller.system.GuildMemberController.edit()','PUT',1,'admin','网站汇总','/system/guildMember','127.0.0.1','内网IP','{\"createdAt\":\"2026-06-14 16:36:46\",\"gamePartitionId\":1,\"gamePartitionName\":\"英雄联盟\",\"guildId\":8,\"guildName\":\"YuKki工会\",\"id\":6,\"joinTime\":\"2026-06-14 16:36:46\",\"nickName\":\"sk\",\"params\":{},\"role\":3,\"status\":1,\"updatedAt\":\"2026-06-14 16:41:05\",\"userId\":3,\"userName\":\"sk\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 17:03:33',28),(217,'工会成员',3,'com.ruoyi.web.controller.system.GuildMemberController.remove()','DELETE',1,'admin','网站汇总','/system/guildMember/6','127.0.0.1','内网IP','[6] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 17:03:35',47),(218,'工会成员',1,'com.ruoyi.web.controller.system.GuildMemberController.add()','POST',1,'admin','YuKki工会','/system/guildMember','127.0.0.1','内网IP','{\"gamePartitionId\":1,\"guildId\":8,\"id\":7,\"joinTime\":\"2026-06-14 19:02:58\",\"params\":{},\"role\":3,\"status\":1,\"userId\":3} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 19:02:59',208),(219,'工会成员',1,'com.ruoyi.web.controller.system.GuildMemberController.add()','POST',1,'admin','YuKki工会','/system/guildMember','127.0.0.1','内网IP','{\"gamePartitionId\":1,\"guildId\":8,\"id\":8,\"joinTime\":\"2026-06-14 19:03:06\",\"params\":{},\"role\":3,\"status\":1,\"userId\":2} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 19:03:06',47),(220,'工会成员',3,'com.ruoyi.web.controller.system.GuildMemberController.remove()','DELETE',1,'admin','YuKki工会','/system/guildMember/8','127.0.0.1','内网IP','[8] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 19:03:29',45),(221,'工会成员',2,'com.ruoyi.web.controller.system.GuildMemberController.edit()','PUT',1,'admin','YuKki工会','/system/guildMember','127.0.0.1','内网IP','{\"createdAt\":\"2026-06-14 19:02:58\",\"gamePartitionId\":1,\"gamePartitionName\":\"英雄联盟\",\"guildId\":8,\"guildName\":\"YuKki工会\",\"id\":7,\"joinTime\":\"2026-06-14 19:02:59\",\"nickName\":\"sk\",\"params\":{},\"role\":4,\"status\":1,\"updatedAt\":\"2026-06-14 19:02:58\",\"userId\":3,\"userName\":\"sk\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 19:04:12',5),(222,'工会成员',2,'com.ruoyi.web.controller.system.GuildMemberController.edit()','PUT',1,'admin','YuKki工会','/system/guildMember','127.0.0.1','内网IP','{\"createdAt\":\"2026-06-14 19:02:58\",\"gamePartitionId\":1,\"gamePartitionName\":\"英雄联盟\",\"guildId\":8,\"guildName\":\"YuKki工会\",\"id\":7,\"joinTime\":\"2026-06-14 19:02:59\",\"nickName\":\"sk\",\"params\":{},\"role\":3,\"status\":1,\"updatedAt\":\"2026-06-14 19:04:11\",\"userId\":3,\"userName\":\"sk\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 19:04:29',5),(223,'用户管理',2,'com.ruoyi.web.controller.system.SysUserController.edit()','PUT',1,'admin','YuKki工会','/system/user','127.0.0.1','内网IP','{\"admin\":false,\"avatar\":\"\",\"createBy\":\"\",\"createTime\":\"2026-06-14 19:40:57\",\"delFlag\":\"0\",\"dept\":{\"ancestors\":\"\",\"children\":[],\"deptId\":100,\"deptName\":\"网站汇总\",\"leader\":\"YuKki\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"status\":\"0\"},\"deptId\":100,\"email\":\"157166879@qq.com\",\"loginDate\":\"2026-06-14 19:41:12\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"肝帝\",\"params\":{},\"phonenumber\":\"\",\"postIds\":[],\"pwdUpdateDate\":\"2026-06-14 19:40:58\",\"roleIds\":[2],\"roles\":[],\"sex\":\"0\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":102,\"userName\":\"肝帝\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 19:46:34',36),(224,'工会任务',1,'com.ruoyi.web.controller.system.GuildTaskController.add()','POST',1,'admin','YuKki工会','/system/guildTask','127.0.0.1','内网IP','{\"currentPlayers\":0,\"description\":\"随便玩玩\",\"endTime\":\"2026-06-14 22:00:00\",\"guildId\":8,\"joinDeadline\":\"2026-06-14 21:00:00\",\"maxPlayers\":3,\"minPlayers\":1,\"name\":\"First\",\"params\":{},\"publisherId\":1,\"status\":1,\"type\":1} ',NULL,1,'\r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'game_partition_id\' cannot be null\r\n### The error may exist in URL [jar:nested:/D:/RpoJec/RuoYi-Vue/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.9.2.jar!/mapper/gameclub/GuildTaskMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.GuildTaskMapper.insertGuildTask-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO guild_task (guild_id, game_partition_id, publisher_id, name, type, description, image, task_mode, min_players, max_players, start_time, join_deadline, end_time, status, created_at)         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'game_partition_id\' cannot be null\n; Column \'game_partition_id\' cannot be null','2026-06-14 20:04:32',567),(225,'工会任务',1,'com.ruoyi.web.controller.system.GuildTaskController.add()','POST',1,'admin','YuKki工会','/system/guildTask','127.0.0.1','内网IP','{\"currentPlayers\":0,\"endTime\":\"2026-06-15 00:00:00\",\"guildId\":8,\"joinDeadline\":\"2026-06-15 00:00:00\",\"maxPlayers\":3,\"minPlayers\":1,\"name\":\"1\",\"params\":{},\"publisherId\":1,\"status\":1,\"type\":1} ',NULL,1,'\r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'game_partition_id\' cannot be null\r\n### The error may exist in URL [jar:nested:/D:/RpoJec/RuoYi-Vue/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.9.2.jar!/mapper/gameclub/GuildTaskMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.GuildTaskMapper.insertGuildTask-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO guild_task (guild_id, game_partition_id, publisher_id, name, type, description, image, task_mode, min_players, max_players, start_time, join_deadline, end_time, status, created_at)         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'game_partition_id\' cannot be null\n; Column \'game_partition_id\' cannot be null','2026-06-14 20:05:42',3),(226,'工会任务',1,'com.ruoyi.web.controller.system.GuildTaskController.add()','POST',1,'admin','YuKki工会','/system/guildTask','127.0.0.1','内网IP','{\"currentPlayers\":0,\"description\":\"第一个任务\",\"endTime\":\"2026-06-14 22:00:00\",\"gamePartitionId\":1,\"guildId\":8,\"id\":1,\"joinDeadline\":\"2026-06-14 21:00:00\",\"maxPlayers\":3,\"minPlayers\":1,\"name\":\"First\",\"params\":{},\"publisherId\":1,\"status\":1,\"type\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 20:10:01',168),(227,'工会任务',3,'com.ruoyi.web.controller.system.GuildTaskController.remove()','DELETE',1,'admin','YuKki工会','/system/guildTask/1','127.0.0.1','内网IP','[1] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 20:10:17',6),(228,'工会申请',2,'com.ruoyi.web.controller.system.GuildApplicationController.approve()','PUT',1,'admin','YuKki工会','/system/guildApplication/approve','127.0.0.1','内网IP','{\"id\":5,\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 20:19:19',26),(229,'工会申请',2,'com.ruoyi.web.controller.system.GuildApplicationController.approve()','PUT',1,'admin','YuKki工会','/system/guildApplication/approve','127.0.0.1','内网IP','{\"id\":4,\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-14 20:31:02',5),(230,'工会申请',2,'com.ruoyi.web.controller.system.GuildApplicationController.approve()','PUT',1,'admin','YuKki工会','/system/guildApplication/approve','127.0.0.1','内网IP','{\"id\":7,\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-15 00:23:14',23),(231,'工会申请',2,'com.ruoyi.web.controller.system.GuildApplicationController.approve()','PUT',1,'admin','YuKki工会','/system/guildApplication/approve','127.0.0.1','内网IP','{\"id\":6,\"status\":2} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-15 00:28:41',34),(232,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','YuKki工会','/system/menu','192.168.2.55','内网IP','{\"children\":[],\"createTime\":\"2026-06-07 22:56:42\",\"icon\":\"guide\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2000,\"menuName\":\"GameClub\",\"menuType\":\"M\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"/gameclub-portal\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-15 00:29:23',23),(233,'工会申请',2,'com.ruoyi.web.controller.system.GuildApplicationController.approve()','PUT',1,'admin','YuKki工会','/system/guildApplication/approve','127.0.0.1','内网IP','{\"id\":8,\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-15 00:30:31',7),(234,'工会成员',2,'com.ruoyi.web.controller.system.GuildMemberController.changeRole()','PUT',1,'admin','YuKki工会','/system/guildMember/changeRole','127.0.0.1','内网IP','{\"role\":\"2\",\"id\":\"13\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-15 00:42:32',20),(235,'工会成员',2,'com.ruoyi.web.controller.system.GuildMemberController.changeRole()','PUT',1,'admin','YuKki工会','/system/guildMember/changeRole','127.0.0.1','内网IP','{\"role\":\"2\",\"id\":\"12\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-15 00:46:08',7),(236,'工会成员',2,'com.ruoyi.web.controller.system.GuildMemberController.changeRole()','PUT',1,'admin','YuKki工会','/system/guildMember/changeRole','127.0.0.1','内网IP','{\"role\":\"3\",\"id\":\"13\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-15 00:48:13',6),(237,'工会成员',2,'com.ruoyi.web.controller.system.GuildMemberController.changeRole()','PUT',1,'admin','YuKki工会','/system/guildMember/changeRole','127.0.0.1','内网IP','{\"role\":\"2\",\"id\":\"13\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-15 00:48:22',7),(238,'游戏分区',1,'com.ruoyi.web.controller.system.GamePartitionController.add()','POST',1,'admin','YuKki工会','/system/gamePartition','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"deptId\":219,\"gameCode\":\"wzry\",\"gameName\":\"王者荣耀\",\"id\":9,\"params\":{},\"sortOrder\":5,\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-15 21:07:26',246),(239,'工会',1,'com.ruoyi.web.controller.system.GuildController.add()','POST',1,'admin','YuKki工会','/system/guild','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"deptId\":220,\"gamePartitionId\":9,\"id\":9,\"memberCount\":0,\"name\":\"亡者工会\",\"params\":{},\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-15 21:09:20',230),(240,'部门管理',3,'com.ruoyi.web.controller.system.SysDeptController.remove()','DELETE',1,'admin','YuKki工会','/system/dept/203','127.0.0.1','内网IP','203 ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-15 21:10:31',12),(241,'工会申请',2,'com.ruoyi.web.controller.system.GuildApplicationController.approve()','PUT',1,'admin','YuKki工会','/system/guildApplication/approve','127.0.0.1','内网IP','{\"id\":12,\"status\":1} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-15 21:20:50',26),(242,'工会',3,'com.ruoyi.web.controller.system.GuildController.remove()','DELETE',1,'admin','YuKki工会','/system/guild/10','127.0.0.1','内网IP','[10] ',NULL,1,'\r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Cannot delete or update a parent row: a foreign key constraint fails (`ry_vue`.`guild_member`, CONSTRAINT `fk_member_guild` FOREIGN KEY (`guild_id`) REFERENCES `guild` (`id`))\r\n### The error may exist in URL [jar:file:/C:/Users/25174/.m2/repository/com/ruoyi/ruoyi-system/3.9.2/ruoyi-system-3.9.2.jar!/mapper/gameclub/GuildMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.GuildMapper.deleteGuildById-Inline\r\n### The error occurred while setting parameters\r\n### SQL: DELETE FROM guild WHERE id = ?\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Cannot delete or update a parent row: a foreign key constraint fails (`ry_vue`.`guild_member`, CONSTRAINT `fk_member_guild` FOREIGN KEY (`guild_id`) REFERENCES `guild` (`id`))\n; Cannot delete or update a parent row: a foreign key constraint fails (`ry_vue`.`guild_member`, CONSTRAINT `fk_member_guild` FOREIGN KEY (`guild_id`) REFERENCES `guild` (`id`))','2026-06-15 22:05:06',435),(243,'工会成员',3,'com.ruoyi.web.controller.system.GuildMemberController.remove()','DELETE',1,'admin','YuKki工会','/system/guildMember/18','127.0.0.1','内网IP','[18] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-15 22:05:20',19),(244,'工会',3,'com.ruoyi.web.controller.system.GuildController.remove()','DELETE',1,'admin','YuKki工会','/system/guild/10','127.0.0.1','内网IP','[10] ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-15 22:05:26',11);
/*!40000 ALTER TABLE `sys_oper_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_post`
--

DROP TABLE IF EXISTS `sys_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_post` (
  `post_id` bigint NOT NULL AUTO_INCREMENT COMMENT '职称ID',
  `post_code` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='岗位信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_post`
--

LOCK TABLES `sys_post` WRITE;
/*!40000 ALTER TABLE `sys_post` DISABLE KEYS */;
INSERT INTO `sys_post` VALUES (1,'GuildMaster','工会会长',1,'0','admin','2026-06-07 22:27:01','admin','2026-06-08 01:14:58',''),(2,'GuildAdmin','工会管理员',2,'0','admin','2026-06-07 22:27:01','',NULL,''),(3,'GuildMember','工会成员',3,'0','admin','2026-06-07 22:27:01','',NULL,''),(4,'NormalUser','无工会用户',4,'0','admin','2026-06-07 22:27:01','',NULL,''),(5,'SuperAdmin','若依系统管理员',5,'0','admin','2026-06-08 01:44:58','admin','2026-06-08 01:45:36',NULL);
/*!40000 ALTER TABLE `sys_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role`
--

DROP TABLE IF EXISTS `sys_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role` (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) DEFAULT '1' COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) DEFAULT '1' COMMENT '部门树选择项是否关联显示',
  `status` char(1) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role`
--

LOCK TABLES `sys_role` WRITE;
/*!40000 ALTER TABLE `sys_role` DISABLE KEYS */;
INSERT INTO `sys_role` VALUES (1,'超级管理员','admin',1,'1',1,1,'0','0','admin','2026-06-07 22:27:01','',NULL,'超级管理员'),(2,'普通角色','common',2,'2',0,0,'0','0','admin','2026-06-07 22:27:01','admin','2026-06-13 16:15:16','普通角色');
/*!40000 ALTER TABLE `sys_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_dept`
--

DROP TABLE IF EXISTS `sys_role_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_dept` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`,`dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色和部门关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_dept`
--

LOCK TABLES `sys_role_dept` WRITE;
/*!40000 ALTER TABLE `sys_role_dept` DISABLE KEYS */;
INSERT INTO `sys_role_dept` VALUES (1,100),(1,201),(2,100);
/*!40000 ALTER TABLE `sys_role_dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_menu`
--

DROP TABLE IF EXISTS `sys_role_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_menu` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`,`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色和菜单关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_menu`
--

LOCK TABLES `sys_role_menu` WRITE;
/*!40000 ALTER TABLE `sys_role_menu` DISABLE KEYS */;
INSERT INTO `sys_role_menu` VALUES (1,2000),(1,2001),(1,2002),(1,2003),(1,2004),(1,2005),(1,2006),(1,2007),(1,2008),(1,2009),(1,2010),(1,2011),(1,2012),(1,2018),(1,2019),(1,2020),(1,2021),(1,2022),(1,2023),(1,2024),(1,2025),(1,2026),(1,2027),(1,2028),(1,2029),(1,2030),(1,2031),(1,2032),(1,2033),(1,2034),(1,2035),(1,2036),(1,2037),(1,2038),(1,2039),(1,2040),(2,4),(2,100),(2,101),(2,102),(2,103),(2,104),(2,105),(2,106),(2,107),(2,108),(2,109),(2,110),(2,111),(2,112),(2,113),(2,114),(2,115),(2,116),(2,117),(2,500),(2,501),(2,1000),(2,1001),(2,1002),(2,1003),(2,1004),(2,1005),(2,1006),(2,1007),(2,1008),(2,1009),(2,1010),(2,1011),(2,1012),(2,1013),(2,1014),(2,1015),(2,1016),(2,1017),(2,1018),(2,1019),(2,1020),(2,1021),(2,1022),(2,1023),(2,1024),(2,1025),(2,1026),(2,1027),(2,1028),(2,1029),(2,1030),(2,1031),(2,1032),(2,1033),(2,1034),(2,1035),(2,1036),(2,1037),(2,1038),(2,1039),(2,1040),(2,1041),(2,1042),(2,1043),(2,1044),(2,1045),(2,1046),(2,1047),(2,1048),(2,1049),(2,1050),(2,1051),(2,1052),(2,1053),(2,1054),(2,1055),(2,1056),(2,1057),(2,1058),(2,1059),(2,1060),(2,2000),(2,2002),(2,2003),(2,2008),(2,2009),(2,2021),(2,2022),(2,2037),(2,2038);
/*!40000 ALTER TABLE `sys_role_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user`
--

DROP TABLE IF EXISTS `sys_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user` (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '手机号码',
  `sex` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '密码',
  `status` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime DEFAULT NULL COMMENT '最后登录时间',
  `pwd_update_date` datetime DEFAULT NULL COMMENT '密码最后更新时间',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user`
--

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;
INSERT INTO `sys_user` VALUES (1,204,'admin','YuKki','00','2517487412@qq.com','15729728627','0','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','127.0.0.1','2026-06-22 20:48:19','2026-06-07 22:27:01','admin','2026-06-07 22:27:01','','2026-06-08 01:12:06','管理员'),(2,205,'ry','若依','00','ry@qq.com','15666666666','1','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','127.0.0.1','2026-06-14 19:38:48','2026-06-07 22:27:01','admin','2026-06-07 22:27:01','','2026-06-14 19:03:28','测试员'),(3,205,'sk','sk','00','','15555555555','0','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','127.0.0.1','2026-06-15 21:44:31',NULL,'',NULL,'','2026-06-15 22:05:20',NULL),(102,100,'肝帝','肝帝','00','157166879@qq.com','','0','','$2a$10$WpYBlxbr4TQBcoulotmL5OgqHxio/qPoasfluTNovBN1rY2LHWoJO','0','0','192.168.2.80','2026-06-16 16:32:35','2026-06-14 19:40:58','','2026-06-14 19:40:57','admin','2026-06-14 19:46:34',NULL),(103,100,'happypuppy','happypuppy','00','2889506632@qq.com','','0','','$2a$10$BySbfgiBV/VUZHnBAGuoouYYFf7.wzOObPr2BYbe1UZAMCG1Z30Fu','0','0','192.168.2.115','2026-06-15 00:49:02','2026-06-15 00:08:36','','2026-06-15 00:08:35','',NULL,NULL);
/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_dept`
--

DROP TABLE IF EXISTS `sys_user_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_dept` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `dept_id` bigint NOT NULL,
  `website_code` varchar(50) NOT NULL,
  `is_primary` tinyint DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `joined_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_website` (`user_id`,`website_code`),
  KEY `idx_dept_id` (`dept_id`),
  KEY `idx_website_code` (`website_code`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_dept`
--

LOCK TABLES `sys_user_dept` WRITE;
/*!40000 ALTER TABLE `sys_user_dept` DISABLE KEYS */;
INSERT INTO `sys_user_dept` VALUES (1,1,100,'DEFAULT',1,'2026-06-09 03:43:29','2026-06-09 03:15:16','2026-06-09 03:15:16'),(2,2,100,'DEFAULT',1,'2026-06-09 03:43:29','2026-06-09 03:15:16','2026-06-09 03:15:16'),(4,1,204,'GAMECLUB',0,'2026-06-09 03:44:01','2026-06-09 03:44:01','2026-06-14 16:44:11'),(5,2,205,'GAMECLUB',0,'2026-06-14 16:43:58','2026-06-14 16:43:58','2026-06-14 19:03:28'),(6,3,205,'GAMECLUB',0,'2026-06-14 16:43:58','2026-06-14 16:43:58','2026-06-15 22:05:20'),(7,102,100,'DEFAULT',1,'2026-06-14 19:40:57','2026-06-14 19:40:58','2026-06-14 19:40:57'),(8,103,100,'DEFAULT',1,'2026-06-15 00:08:35','2026-06-15 00:08:36','2026-06-15 00:08:35');
/*!40000 ALTER TABLE `sys_user_dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_post`
--

DROP TABLE IF EXISTS `sys_user_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_post` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`,`post_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户与岗位关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_post`
--

LOCK TABLES `sys_user_post` WRITE;
/*!40000 ALTER TABLE `sys_user_post` DISABLE KEYS */;
INSERT INTO `sys_user_post` VALUES (1,1),(2,4),(3,4);
/*!40000 ALTER TABLE `sys_user_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_role`
--

DROP TABLE IF EXISTS `sys_user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_role` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户和角色关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_role`
--

LOCK TABLES `sys_user_role` WRITE;
/*!40000 ALTER TABLE `sys_user_role` DISABLE KEYS */;
INSERT INTO `sys_user_role` VALUES (1,1),(2,1),(3,2),(102,2),(103,2);
/*!40000 ALTER TABLE `sys_user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_website_config`
--

DROP TABLE IF EXISTS `sys_website_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_website_config` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `website_code` varchar(50) NOT NULL,
  `website_name` varchar(100) NOT NULL,
  `root_dept_id` bigint NOT NULL,
  `default_dept_id` bigint NOT NULL,
  `status` char(1) DEFAULT '0',
  `remark` varchar(500) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_website_code` (`website_code`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_website_config`
--

LOCK TABLES `sys_website_config` WRITE;
/*!40000 ALTER TABLE `sys_website_config` DISABLE KEYS */;
INSERT INTO `sys_website_config` VALUES (1,'DEFAULT','网站汇总主站点',100,100,'0','若依系统主站点，所有用户的默认归属','2026-06-09 03:15:02','2026-06-09 03:15:02'),(2,'GAMECLUB','GameClub游戏工会平台',201,205,'0','GameClub游戏工会系统，新用户默认进入无工会用户区','2026-06-09 03:15:02','2026-06-09 03:15:02');
/*!40000 ALTER TABLE `sys_website_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_participant`
--

DROP TABLE IF EXISTS `task_participant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_participant` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `task_id` bigint NOT NULL COMMENT '任务ID',
  `user_id` bigint NOT NULL COMMENT '参与用户ID',
  `status` tinyint DEFAULT '1' COMMENT '状态：1-已接单 2-已放弃 3-已完成',
  `join_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '接单时间',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_task_user` (`task_id`,`user_id`),
  KEY `idx_user` (`user_id`),
  CONSTRAINT `fk_participant_task` FOREIGN KEY (`task_id`) REFERENCES `guild_task` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='任务参与表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_participant`
--

LOCK TABLES `task_participant` WRITE;
/*!40000 ALTER TABLE `task_participant` DISABLE KEYS */;
INSERT INTO `task_participant` VALUES (5,5,1,1,'2026-06-15 01:37:59','2026-06-15 01:37:59'),(6,5,3,1,'2026-06-15 01:38:27','2026-06-15 01:38:27'),(7,6,1,1,'2026-06-16 16:35:47','2026-06-16 16:35:47'),(8,6,102,1,'2026-06-16 16:36:05','2026-06-16 16:36:05');
/*!40000 ALTER TABLE `task_participant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_notification`
--

DROP TABLE IF EXISTS `user_notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_notification` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '消息ID',
  `user_id` bigint NOT NULL COMMENT '接收用户ID',
  `game_partition_id` bigint DEFAULT NULL COMMENT '所属游戏分区ID',
  `guild_id` bigint DEFAULT NULL COMMENT '所属工会ID',
  `type` tinyint NOT NULL COMMENT '消息类型：1-入会申请结果 2-任务状态变更 3-身份任免 4-被踢通知 5-拉黑通知 6-系统通知',
  `title` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '消息标题',
  `content` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '消息内容',
  `is_read` tinyint DEFAULT '0' COMMENT '是否已读：0-未读 1-已读',
  `related_id` bigint DEFAULT NULL COMMENT '关联ID（如申请ID、任务ID等）',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_is_read` (`is_read`),
  KEY `idx_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户消息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_notification`
--

LOCK TABLES `user_notification` WRITE;
/*!40000 ALTER TABLE `user_notification` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_notification` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-22 23:12:04
