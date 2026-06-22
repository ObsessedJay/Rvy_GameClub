# GameClub 独立业务页面设计方案

**日期：** 2026-06-10  
**状态：** 已批准

## 1. 项目概述

为 GameClub 游戏工会平台设计独立的业务前台门户和用户工作台，与现有的管理系统分离，提供更好的用户体验。

## 2. 系统架构

### 2.1 路由结构

```
/gameclub-portal          # 前台门户（游客和普通用户）
├── /                     # 首页
├── /partition/:id        # 游戏分区详情
├── /guild/:id            # 工会详情
└── /apply/:guildId       # 申请加入工会

/gameclub-workspace       # 用户工作台（工会会长和管理员）
├── /                     # 工作台首页
├── /guild/:id            # 工会管理
├── /guild/:id/members    # 成员管理
├── /guild/:id/announcements  # 公告管理
├── /guild/:id/applications   # 申请审批
└── /guild/:id/blacklist      # 黑名单管理
```

### 2.2 技术栈

- 前端框架：Vue 2.x + Element UI
- 路由管理：Vue Router
- HTTP 请求：Axios
- 状态管理：Vuex（如需要）
- API 复用：现有 `/api/gameclub/*.js` 接口

## 3. 前台门户（/gameclub-portal）

### 3.1 首页

**布局：**
- 顶部导航栏
- Banner 轮播区
- 游戏分区卡片展示
- 热门工会列表
- 最新公告列表

**组件：**
- `Header.vue` - 顶部导航
- `Banner.vue` - 轮播组件
- `PartitionCard.vue` - 游戏分区卡片
- `GuildCard.vue` - 工会卡片
- `AnnouncementList.vue` - 公告列表

### 3.2 游戏分区详情页

**路由：** `/partition/:id`

**布局：**
- 分区信息头部（名称、游戏数量、成员总数）
- 工会列表（支持筛选、搜索）
- 分页组件

### 3.3 工会详情页

**路由：** `/guild/:id`

**布局：**
- 工会基本信息（名称、会长、成员数、创建时间、简介）
- 工会公告列表
- 工会成员列表
- 申请加入按钮

### 3.4 申请加入页面

**路由：** `/apply/:guildId`

**功能：**
- 登录验证（未登录跳转登录页）
- 申请表单（申请理由）
- 提交申请

## 4. 用户工作台（/gameclub-workspace）

### 4.1 工作台首页

**路由：** `/`

**布局：**
- 左侧菜单栏
- 右侧内容区
  - 我管理的工会卡片
  - 待审批申请数量
  - 最新申请列表

**菜单：**
- 我的工会
- 申请管理
- 黑名单管理

### 4.2 工会管理页

**路由：** `/guild/:id`

**功能：**
- 工会基本信息编辑
- 工会公告管理
- 成员管理入口
- 申请管理入口

### 4.3 成员管理页

**路由：** `/guild/:id/members`

**功能：**
- 成员列表（昵称、职位、加入时间）
- 搜索成员
- 添加成员
- 移除成员
- 设置成员职位

### 4.4 公告管理页

**路由：** `/guild/:id/announcements`

**功能：**
- 公告列表
- 发布新公告
- 编辑公告
- 删除公告
- 设置公告类型（普通/重要/紧急）

### 4.5 申请审批页

**路由：** `/guild/:id/applications`

**功能：**
- 待审批申请列表
- 通过申请
- 拒绝申请
- 查看申请详情

### 4.6 黑名单管理页

**路由：** `/guild/:id/blacklist`

**功能：**
- 黑名单列表
- 添加到黑名单
- 移除黑名单
- 查看原因

## 5. API 接口

### 5.1 游戏分区

- `GET /gameclub/partition/list` - 获取分区列表
- `GET /gameclub/partition/{id}` - 获取分区详情

### 5.2 工会

- `GET /gameclub/guild/list` - 获取工会列表
- `GET /gameclub/guild/{id}` - 获取工会详情
- `GET /gameclub/guild/partitions/{partitionId}/guilds` - 获取分区下的工会

### 5.3 工会成员

- `GET /gameclub/member/list` - 获取成员列表
- `POST /gameclub/member` - 添加成员
- `PUT /gameclub/member/{id}` - 更新成员
- `DELETE /gameclub/member/{id}` - 删除成员

### 5.4 工会公告

- `GET /gameclub/announcement/list` - 获取公告列表
- `POST /gameclub/announcement` - 发布公告
- `PUT /gameclub/announcement/{id}` - 更新公告
- `DELETE /gameclub/announcement/{id}` - 删除公告

### 5.5 工会申请

- `GET /gameclub/application/list` - 获取申请列表
- `POST /gameclub/application` - 提交申请
- `PUT /gameclub/application/{id}/approve` - 审批申请

### 5.6 黑名单

- `GET /gameclub/blacklist/list` - 获取黑名单列表
- `POST /gameclub/blacklist` - 添加到黑名单
- `DELETE /gameclub/blacklist/{id}` - 移除黑名单

## 6. 实现优先级

### 第一阶段：基础框架
1. 创建路由配置
2. 创建页面目录结构
3. 创建布局组件（Header、Sidebar）

### 第二阶段：前台门户
1. 首页开发
2. 游戏分区详情页
3. 工会详情页
4. 申请加入页

### 第三阶段：用户工作台
1. 工作台首页
2. 工会管理页
3. 成员管理页
4. 公告管理页
5. 申请审批页
6. 黑名单管理页

## 7. 注意事项

1. **权限控制**：工作台页面需要登录且为工会会长或管理员
2. **数据隔离**：用户只能管理自己创建的工会
3. **响应式设计**：支持移动端访问（特别是前台门户）
4. **复用原则**：尽量复用现有 API 和组件
