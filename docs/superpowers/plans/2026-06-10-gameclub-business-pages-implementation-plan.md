# GameClub 独立业务页面实现计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 为 GameClub 创建独立的业务前台门户和用户工作台，包含游戏分区展示、工会列表、申请加入等功能。

**Architecture:** 采用 Vue Router 子路由方式，在现有 `/gameclub/` 管理路由下新增 `/gameclub-portal/` 前台门户和 `/gameclub-workspace/` 用户工作台。前台门户面向普通用户，展示游戏分区、工会信息；用户工作台面向工会会长，提供工会管理功能。

**Tech Stack:** Vue 2.x + Element UI + Vue Router + Axios，复用现有 `/api/gameclub/` 接口

---

## 第一阶段：基础框架

### Task 1: 创建前台门户路由和基础布局

**Files:**
- Create: `ruoyi-ui/src/views/gameclub-portal/index.vue`
- Create: `ruoyi-ui/src/views/gameclub-portal/layout/Layout.vue`
- Create: `ruoyi-ui/src/views/gameclub-portal/layout/Header.vue`
- Modify: `ruoyi-ui/src/router/index.js`

- [ ] **Step 1: 创建前台门户主入口页面**

```vue
<!-- ruoyi-ui/src/views/gameclub-portal/index.vue -->
<template>
  <router-view />
</template>

<script>
export default {
  name: "GameClubPortal"
}
</script>
```

- [ ] **Step 2: 创建前台门户布局组件**

```vue
<!-- ruoyi-ui/src/views/gameclub-portal/layout/Layout.vue -->
<template>
  <div class="portal-layout">
    <Header />
    <main class="portal-main">
      <router-view />
    </main>
    <footer class="portal-footer">
      <p>© 2026 GameClub - 游戏工会平台</p>
    </footer>
  </div>
</template>

<script>
import Header from './Header.vue'

export default {
  name: "PortalLayout",
  components: { Header }
}
</script>

<style scoped>
.portal-layout {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}
.portal-main {
  flex: 1;
  padding: 20px;
}
.portal-footer {
  text-align: center;
  padding: 20px;
  background: #f5f5f5;
}
</style>
```

- [ ] **Step 3: 创建前台门户顶部导航**

```vue
<!-- ruoyi-ui/src/views/gameclub-portal/layout/Header.vue -->
<template>
  <header class="portal-header">
    <div class="header-container">
      <div class="logo" @click="$router.push('/gameclub-portal')">
        <span class="logo-icon">🎮</span>
        <span class="logo-text">GameClub</span>
      </div>
      <nav class="nav-menu">
        <router-link to="/gameclub-portal">首页</router-link>
        <router-link to="/gameclub-portal/partitions">游戏分区</router-link>
      </nav>
      <div class="header-actions">
        <template v-if="!hasToken">
          <el-button type="primary" @click="$router.push('/login')">登录</el-button>
        </template>
        <template v-else>
          <el-dropdown @command="handleCommand">
            <span class="user-info">
              <i class="el-icon-user"></i> {{ username }}
            </span>
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item command="workspace">我的工作台</el-dropdown-item>
              <el-dropdown-item command="logout">退出</el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
        </template>
      </div>
    </div>
  </header>
</template>

<script>
import { getToken } from '@/utils/auth'

export default {
  name: "PortalHeader",
  computed: {
    hasToken() {
      return !!getToken()
    },
    username() {
      return this.$store.state.user.name || '用户'
    }
  },
  methods: {
    handleCommand(command) {
      if (command === 'workspace') {
        this.$router.push('/gameclub-workspace')
      } else if (command === 'logout') {
        this.$store.dispatch('logout').then(() => {
          this.$router.push('/login')
        })
      }
    }
  }
}
</script>

<style scoped>
.portal-header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 0 20px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}
.header-container {
  max-width: 1200px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  height: 60px;
}
.logo {
  display: flex;
  align-items: center;
  cursor: pointer;
  font-size: 20px;
  font-weight: bold;
}
.logo-icon {
  margin-right: 8px;
  font-size: 28px;
}
.nav-menu {
  flex: 1;
  margin-left: 40px;
}
.nav-menu a {
  color: white;
  text-decoration: none;
  margin-right: 30px;
  font-size: 16px;
  opacity: 0.9;
}
.nav-menu a:hover,
.nav-menu a.router-link-active {
  opacity: 1;
  font-weight: bold;
}
.header-actions {
  display: flex;
  align-items: center;
}
.user-info {
  color: white;
  cursor: pointer;
}
</style>
```

- [ ] **Step 4: 修改路由配置添加前台门户路由**

在 `ruoyi-ui/src/router/index.js` 中添加：

```javascript
{
  path: '/gameclub-portal',
  component: () => import('@/views/gameclub-portal/index'),
  children: [
    {
      path: '',
      component: () => import('@/views/gameclub-portal/home/index'),
      name: 'GameClubPortalHome',
      meta: { title: 'GameClub首页' }
    },
    {
      path: 'partitions',
      component: () => import('@/views/gameclub-portal/partitions/index'),
      name: 'GameClubPortalPartitions',
      meta: { title: '游戏分区' }
    },
    {
      path: 'partition/:id',
      component: () => import('@/views/gameclub-portal/partition-detail/index'),
      name: 'GameClubPortalPartitionDetail',
      meta: { title: '分区详情' }
    },
    {
      path: 'guild/:id',
      component: () => import('@/views/gameclub-portal/guild-detail/index'),
      name: 'GameClubPortalGuildDetail',
      meta: { title: '工会详情' }
    },
    {
      path: 'apply/:guildId',
      component: () => import('@/views/gameclub-portal/apply/index'),
      name: 'GameClubPortalApply',
      meta: { title: '申请加入', requireAuth: true }
    }
  ]
}
```

### Task 2: 创建用户工作台路由和基础布局

**Files:**
- Create: `ruoyi-ui/src/views/gameclub-workspace/index.vue`
- Create: `ruoyi-ui/src/views/gameclub-workspace/layout/Layout.vue`
- Create: `ruoyi-ui/src/views/gameclub-workspace/layout/Sidebar.vue`
- Modify: `ruoyi-ui/src/router/index.js`

- [ ] **Step 1: 创建用户工作台主入口页面**

```vue
<!-- ruoyi-ui/src/views/gameclub-workspace/index.vue -->
<template>
  <router-view />
</template>

<script>
export default {
  name: "GameClubWorkspace"
}
</script>
```

- [ ] **Step 2: 创建用户工作台布局组件**

```vue
<!-- ruoyi-ui/src/views/gameclub-workspace/layout/Layout.vue -->
<template>
  <div class="workspace-layout">
    <Sidebar />
    <main class="workspace-main">
      <router-view />
    </main>
  </div>
</template>

<script>
import Sidebar from './Sidebar.vue'

export default {
  name: "WorkspaceLayout",
  components: { Sidebar }
}
</script>

<style scoped>
.workspace-layout {
  display: flex;
  min-height: 100vh;
}
.workspace-main {
  flex: 1;
  padding: 20px;
  background: #f5f5f5;
}
</style>
```

- [ ] **Step 3: 创建用户工作台侧边栏**

```vue
<!-- ruoyi-ui/src/views/gameclub-workspace/layout/Sidebar.vue -->
<template>
  <aside class="workspace-sidebar">
    <div class="sidebar-header">
      <span class="logo-icon">🎮</span>
      <span>工作台</span>
    </div>
    <el-menu
      :default-active="activeMenu"
      router
      background-color="#304156"
      text-color="#bfcbd9"
      active-text-color="#409EFF"
    >
      <el-menu-item index="/gameclub-workspace">
        <i class="el-icon-s-home"></i>
        <span slot="title">工作台首页</span>
      </el-menu-item>
      <el-menu-item index="/gameclub-workspace/guilds">
        <i class="el-icon-s-flag"></i>
        <span slot="title">我的工会</span>
      </el-menu-item>
      <el-menu-item index="/gameclub-workspace/applications">
        <i class="el-icon-document"></i>
        <span slot="title">申请管理</span>
      </el-menu-item>
      <el-menu-item index="/gameclub-workspace/blacklist">
        <i class="el-icon-circle-close"></i>
        <span slot="title">黑名单管理</span>
      </el-menu-item>
    </el-menu>
  </aside>
</template>

<script>
export default {
  name: "WorkspaceSidebar",
  computed: {
    activeMenu() {
      return this.$route.path
    }
  }
}
</script>

<style scoped>
.workspace-sidebar {
  width: 200px;
  background: #304156;
  min-height: 100vh;
}
.sidebar-header {
  height: 60px;
  display: flex;
  align-items: center;
  padding: 0 20px;
  color: white;
  font-size: 18px;
  font-weight: bold;
  border-bottom: 1px solid #3d4a5a;
}
.logo-icon {
  margin-right: 10px;
  font-size: 24px;
}
</style>
```

- [ ] **Step 4: 修改路由配置添加用户工作台路由**

```javascript
{
  path: '/gameclub-workspace',
  component: () => import('@/views/gameclub-workspace/index'),
  children: [
    {
      path: '',
      component: () => import('@/views/gameclub-workspace/home/index'),
      name: 'GameClubWorkspaceHome',
      meta: { title: '工作台首页', requireAuth: true }
    },
    {
      path: 'guilds',
      component: () => import('@/views/gameclub-workspace/guilds/index'),
      name: 'GameClubWorkspaceGuilds',
      meta: { title: '我的工会', requireAuth: true }
    },
    {
      path: 'guild/:id',
      component: () => import('@/views/gameclub-workspace/guild-manage/index'),
      name: 'GameClubWorkspaceGuildManage',
      meta: { title: '工会管理', requireAuth: true }
    },
    {
      path: 'guild/:id/members',
      component: () => import('@/views/gameclub-workspace/guild-manage/members'),
      name: 'GameClubWorkspaceGuildMembers',
      meta: { title: '成员管理', requireAuth: true }
    },
    {
      path: 'guild/:id/announcements',
      component: () => import('@/views/gameclub-workspace/guild-manage/announcements'),
      name: 'GameClubWorkspaceGuildAnnouncements',
      meta: { title: '公告管理', requireAuth: true }
    },
    {
      path: 'guild/:id/applications',
      component: () => import('@/views/gameclub-workspace/guild-manage/applications'),
      name: 'GameClubWorkspaceGuildApplications',
      meta: { title: '申请审批', requireAuth: true }
    },
    {
      path: 'guild/:id/blacklist',
      component: () => import('@/views/gameclub-workspace/guild-manage/blacklist'),
      name: 'GameClubWorkspaceGuildBlacklist',
      meta: { title: '黑名单管理', requireAuth: true }
    },
    {
      path: 'applications',
      component: () => import('@/views/gameclub-workspace/applications/index'),
      name: 'GameClubWorkspaceApplications',
      meta: { title: '申请管理', requireAuth: true }
    },
    {
      path: 'blacklist',
      component: () => import('@/views/gameclub-workspace/blacklist/index'),
      name: 'GameClubWorkspaceBlacklist',
      meta: { title: '黑名单管理', requireAuth: true }
    }
  ]
}
```

---

## 第二阶段：前台门户页面

### Task 3: 创建前台门户首页

**Files:**
- Create: `ruoyi-ui/src/views/gameclub-portal/home/index.vue`

- [ ] **Step 1: 创建前台门户首页组件**

```vue
<!-- ruoyi-ui/src/views/gameclub-portal/home/index.vue -->
<template>
  <div class="portal-home">
    <!-- Banner区域 -->
    <div class="banner">
      <el-carousel height="300px">
        <el-carousel-item v-for="(item, index) in banners" :key="index">
          <div class="banner-item" :style="{ background: item.bg }">
            <h2>{{ item.title }}</h2>
            <p>{{ item.subtitle }}</p>
          </div>
        </el-carousel-item>
      </el-carousel>
    </div>

    <div class="content-container">
      <!-- 游戏分区 -->
      <section class="section">
        <h2 class="section-title">游戏分区</h2>
        <el-row :gutter="20">
          <el-col :xs="24" :sm="12" :md="6" v-for="partition in partitionList" :key="partition.id">
            <div class="partition-card" @click="goToPartition(partition.id)">
              <div class="partition-icon">🎮</div>
              <h3>{{ partition.gameName }}</h3>
              <p>{{ partition.guildCount }} 个工会</p>
            </div>
          </el-col>
        </el-row>
      </section>

      <!-- 热门工会 -->
      <section class="section">
        <h2 class="section-title">热门工会</h2>
        <el-row :gutter="20">
          <el-col :xs="24" :sm="12" :md="8" v-for="guild in hotGuilds" :key="guild.id">
            <el-card class="guild-card" shadow="hover" @click.native="goToGuild(guild.id)">
              <div class="guild-info">
                <h3>{{ guild.name }}</h3>
                <p class="partition-tag">{{ guild.partitionName }}</p>
                <p class="member-count">👥 {{ guild.memberCount }} 成员</p>
              </div>
            </el-card>
          </el-col>
        </el-row>
      </section>

      <!-- 最新公告 -->
      <section class="section">
        <h2 class="section-title">最新公告</h2>
        <el-timeline>
          <el-timeline-item v-for="announcement in announcements" :key="announcement.id" :timestamp="announcement.publishedAt" placement="top">
            <el-card>
              <h4>{{ announcement.title }}</h4>
              <p>{{ announcement.guildName }}</p>
            </el-card>
          </el-timeline-item>
        </el-timeline>
      </section>
    </div>
  </div>
</template>

<script>
import { listPartition } from '@/api/gameclub/partition'
import { listGuild } from '@/api/gameclub/guild'
import { listAnnouncement } from '@/api/gameclub/announcement'

export default {
  name: "PortalHome",
  data() {
    return {
      banners: [
        { title: '欢迎来到GameClub', subtitle: '找到你的游戏工会', bg: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)' },
        { title: '热门游戏', subtitle: '英雄联盟、王者荣耀、DOTA2', bg: 'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)' },
        { title: '加入工会', subtitle: '与志同道合的玩家一起战斗', bg: 'linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)' }
      ],
      partitionList: [],
      hotGuilds: [],
      announcements: []
    }
  },
  created() {
    this.loadData()
  },
  methods: {
    loadData() {
      listPartition({ status: 1, pageNum: 1, pageSize: 8 }).then(res => {
        this.partitionList = res.rows
      })
      listGuild({ status: 1, pageNum: 1, pageSize: 6 }).then(res => {
        this.hotGuilds = res.rows
      })
      listAnnouncement({ status: 1, pageNum: 1, pageSize: 5 }).then(res => {
        this.announcements = res.rows
      })
    },
    goToPartition(id) {
      this.$router.push(`/gameclub-portal/partition/${id}`)
    },
    goToGuild(id) {
      this.$router.push(`/gameclub-portal/guild/${id}`)
    }
  }
}
</script>

<style scoped>
.portal-home {
  background: #f5f5f5;
}
.banner {
  margin-bottom: 30px;
}
.banner-item {
  height: 300px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  color: white;
  text-align: center;
}
.banner-item h2 {
  font-size: 36px;
  margin-bottom: 10px;
}
.banner-item p {
  font-size: 18px;
  opacity: 0.9;
}
.content-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}
.section {
  margin-bottom: 40px;
}
.section-title {
  font-size: 24px;
  margin-bottom: 20px;
  padding-left: 10px;
  border-left: 4px solid #667eea;
}
.partition-card {
  background: white;
  padding: 30px;
  border-radius: 8px;
  text-align: center;
  cursor: pointer;
  transition: all 0.3s;
  margin-bottom: 20px;
}
.partition-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 30px rgba(0,0,0,0.1);
}
.partition-icon {
  font-size: 48px;
  margin-bottom: 15px;
}
.partition-card h3 {
  margin-bottom: 8px;
  color: #333;
}
.partition-card p {
  color: #666;
  font-size: 14px;
}
.guild-card {
  margin-bottom: 20px;
  cursor: pointer;
}
.guild-card:hover {
  border-color: #667eea;
}
.guild-info h3 {
  margin-bottom: 8px;
}
.partition-tag {
  display: inline-block;
  background: #e6f7ff;
  color: #1890ff;
  padding: 2px 8px;
  border-radius: 4px;
  font-size: 12px;
  margin-bottom: 8px;
}
.member-count {
  color: #666;
  font-size: 14px;
}
</style>
```

### Task 4: 创建游戏分区详情页

**Files:**
- Create: `ruoyi-ui/src/views/gameclub-portal/partition-detail/index.vue`

- [ ] **Step 1: 创建游戏分区详情页组件**

```vue
<!-- ruoyi-ui/src/views/gameclub-portal/partition-detail/index.vue -->
<template>
  <div class="partition-detail">
    <div class="partition-header">
      <div class="header-content">
        <span class="partition-icon">🎮</span>
        <div class="partition-info">
          <h1>{{ partition.gameName }}</h1>
          <p>游戏编码: {{ partition.gameCode }}</p>
        </div>
      </div>
      <div class="partition-stats">
        <div class="stat-item">
          <span class="stat-num">{{ partition.guildCount || 0 }}</span>
          <span class="stat-label">工会数</span>
        </div>
        <div class="stat-item">
          <span class="stat-num">{{ partition.memberCount || 0 }}</span>
          <span class="stat-label">总成员</span>
        </div>
      </div>
    </div>

    <div class="guild-list-section">
      <div class="section-header">
        <h2>工会列表</h2>
        <el-input v-model="searchKeyword" placeholder="搜索工会名称" style="width: 200px;" clearable>
          <i slot="prefix" class="el-icon-search"></i>
        </el-input>
      </div>

      <el-row :gutter="20">
        <el-col :xs="24" :sm="12" :md="8" v-for="guild in filteredGuilds" :key="guild.id">
          <el-card class="guild-card" shadow="hover" @click.native="goToGuild(guild.id)">
            <div class="guild-info">
              <h3>{{ guild.name }}</h3>
              <p class="president">会长: {{ guild.presidentName }}</p>
              <div class="guild-footer">
                <span>👥 {{ guild.memberCount }} 成员</span>
                <el-tag v-if="guild.status === 1" type="success" size="small">招募中</el-tag>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>

      <el-pagination
        v-if="total > 0"
        :total="total"
        :page.sync="queryParams.pageNum"
        :limit.sync="queryParams.pageSize"
        @pagination="loadGuilds"
        layout="prev, pager, next"
        style="margin-top: 20px; text-align: center;"
      />
    </div>
  </div>
</template>

<script>
import { getPartition } from '@/api/gameclub/partition'
import { listGuild } from '@/api/gameclub/guild'

export default {
  name: "PartitionDetail",
  data() {
    return {
      partition: {},
      guilds: [],
      total: 0,
      searchKeyword: '',
      queryParams: {
        pageNum: 1,
        pageSize: 12
      }
    }
  },
  computed: {
    filteredGuilds() {
      if (!this.searchKeyword) return this.guilds
      return this.guilds.filter(g => g.name.includes(this.searchKeyword))
    }
  },
  created() {
    this.loadPartition()
    this.loadGuilds()
  },
  methods: {
    loadPartition() {
      getPartition(this.$route.params.id).then(res => {
        this.partition = res.data
      })
    },
    loadGuilds() {
      listGuild({
        ...this.queryParams,
        gamePartitionId: this.$route.params.id,
        status: 1
      }).then(res => {
        this.guilds = res.rows
        this.total = res.total
      })
    },
    goToGuild(id) {
      this.$router.push(`/gameclub-portal/guild/${id}`)
    }
  }
}
</script>

<style scoped>
.partition-detail {
  max-width: 1200px;
  margin: 0 auto;
}
.partition-header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 40px;
  border-radius: 12px;
  margin-bottom: 30px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.header-content {
  display: flex;
  align-items: center;
}
.partition-icon {
  font-size: 64px;
  margin-right: 20px;
}
.partition-info h1 {
  font-size: 32px;
  margin-bottom: 8px;
}
.partition-stats {
  display: flex;
  gap: 40px;
}
.stat-item {
  text-align: center;
}
.stat-num {
  display: block;
  font-size: 36px;
  font-weight: bold;
}
.stat-label {
  font-size: 14px;
  opacity: 0.9;
}
.guild-list-section {
  background: white;
  padding: 30px;
  border-radius: 12px;
}
.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}
.section-header h2 {
  margin: 0;
}
.guild-card {
  margin-bottom: 20px;
  cursor: pointer;
  transition: all 0.3s;
}
.guild-card:hover {
  transform: translateY(-3px);
  border-color: #667eea;
}
.guild-info h3 {
  margin-bottom: 10px;
}
.president {
  color: #666;
  font-size: 14px;
  margin-bottom: 10px;
}
.guild-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  color: #666;
}
</style>
```

### Task 5: 创建工会详情页

**Files:**
- Create: `ruoyi-ui/src/views/gameclub-portal/guild-detail/index.vue`

- [ ] **Step 1: 创建工会详情页组件**

```vue
<!-- ruoyi-ui/src/views/gameclub-portal/guild-detail/index.vue -->
<template>
  <div class="guild-detail">
    <div class="guild-header">
      <div class="header-content">
        <div class="guild-avatar">🎮</div>
        <div class="guild-info">
          <h1>{{ guild.name }}</h1>
          <p class="partition-name">{{ guild.partitionName }}</p>
        </div>
      </div>
      <div class="guild-actions">
        <el-button v-if="canApply" type="primary" size="large" @click="handleApply">
          申请加入
        </el-button>
        <el-tag v-else-if="hasApplied" type="warning">已申请</el-tag>
        <el-tag v-else-if="isMember" type="success">已加入</el-tag>
      </div>
    </div>

    <div class="guild-content">
      <el-row :gutter="20">
        <el-col :xs="24" :md="16">
          <!-- 基本信息 -->
          <el-card class="info-card">
            <h2 slot="header">工会信息</h2>
            <el-descriptions :column="2" border>
              <el-descriptions-item label="会长">{{ guild.presidentName }}</el-descriptions-item>
              <el-descriptions-item label="成员数">{{ guild.memberCount }}</el-descriptions-item>
              <el-descriptions-item label="创建时间">{{ guild.createdAt }}</el-descriptions-item>
              <el-descriptions-item label="状态">
                <el-tag :type="guild.status === 1 ? 'success' : 'info'">
                  {{ guild.status === 1 ? '招募中' : '暂停招募' }}
                </el-tag>
              </el-descriptions-item>
              <el-descriptions-item label="简介" :span="2">{{ guild.description || '暂无简介' }}</el-descriptions-item>
            </el-descriptions>
          </el-card>

          <!-- 公告列表 -->
          <el-card class="info-card">
            <h2 slot="header">工会公告</h2>
            <div v-if="announcements.length === 0" class="empty-text">暂无公告</div>
            <el-timeline v-else>
              <el-timeline-item v-for="item in announcements" :key="item.id" :timestamp="item.publishedAt">
                <h4>{{ item.title }}</h4>
                <p>{{ item.content }}</p>
              </el-timeline-item>
            </el-timeline>
          </el-card>
        </el-col>

        <el-col :xs="24" :md="8">
          <!-- 成员列表 -->
          <el-card class="info-card">
            <h2 slot="header">成员列表 ({{ members.length }})</h2>
            <div v-if="members.length === 0" class="empty-text">暂无成员</div>
            <div v-else class="member-list">
              <div v-for="member in members" :key="member.id" class="member-item">
                <span class="member-avatar">👤</span>
                <span class="member-name">{{ member.nickName }}</span>
                <el-tag v-if="member.role === 1" type="warning" size="small">会长</el-tag>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>

    <!-- 申请对话框 -->
    <el-dialog title="申请加入工会" :visible.sync="applyDialogVisible" width="500px">
      <el-form :model="applyForm" ref="applyFormRef" label-width="100px">
        <el-form-item label="申请理由" prop="reason">
          <el-input v-model="applyForm.reason" type="textarea" :rows="4" placeholder="请输入申请理由" />
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="applyDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitApply">提交</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getGuild } from '@/api/gameclub/guild'
import { listAnnouncement } from '@/api/gameclub/announcement'
import { listMember } from '@/api/gameclub/member'
import { apply } from '@/api/gameclub/application'
import { getToken } from '@/utils/auth'

export default {
  name: "GuildDetail",
  data() {
    return {
      guild: {},
      announcements: [],
      members: [],
      applyDialogVisible: false,
      applyForm: {
        reason: ''
      },
      userId: null
    }
  },
  computed: {
    canApply() {
      return getToken() && !this.hasApplied && !this.isMember
    },
    hasApplied() {
      return false // TODO: 检查是否已申请
    },
    isMember() {
      return false // TODO: 检查是否已加入
    }
  },
  created() {
    this.loadData()
  },
  methods: {
    loadData() {
      const guildId = this.$route.params.id
      getGuild(guildId).then(res => {
        this.guild = res.data
      })
      listAnnouncement({ guildId, status: 1 }).then(res => {
        this.announcements = res.rows
      })
      listMember({ guildId }).then(res => {
        this.members = res.rows
      })
    },
    handleApply() {
      this.applyDialogVisible = true
    },
    submitApply() {
      apply({
        guildId: this.$route.params.id,
        reason: this.applyForm.reason
      }).then(() => {
        this.$message.success('申请已提交')
        this.applyDialogVisible = false
      })
    }
  }
}
</script>

<style scoped>
.guild-detail {
  max-width: 1200px;
  margin: 0 auto;
}
.guild-header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 40px;
  border-radius: 12px;
  margin-bottom: 30px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.header-content {
  display: flex;
  align-items: center;
}
.guild-avatar {
  font-size: 80px;
  margin-right: 20px;
}
.guild-info h1 {
  font-size: 32px;
  margin-bottom: 8px;
}
.partition-name {
  opacity: 0.9;
}
.info-card {
  margin-bottom: 20px;
}
.info-card h2 {
  margin: 0;
  font-size: 18px;
}
.empty-text {
  text-align: center;
  color: #999;
  padding: 40px 0;
}
.member-list {
  max-height: 400px;
  overflow-y: auto;
}
.member-item {
  display: flex;
  align-items: center;
  padding: 10px 0;
  border-bottom: 1px solid #f0f0f0;
}
.member-item:last-child {
  border-bottom: none;
}
.member-avatar {
  font-size: 24px;
  margin-right: 10px;
}
.member-name {
  flex: 1;
}
</style>
```

### Task 6: 创建申请加入页面

**Files:**
- Create: `ruoyi-ui/src/views/gameclub-portal/apply/index.vue`

- [ ] **Step 1: 创建申请加入页面组件**

```vue
<!-- ruoyi-ui/src/views/gameclub-portal/apply/index.vue -->
<template>
  <div class="apply-page">
    <el-card class="apply-card">
      <h1 slot="header">申请加入 {{ guildName }}</h1>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="申请理由" prop="reason">
          <el-input v-model="form.reason" type="textarea" :rows="6" placeholder="请简要说明您想加入工会的原因和您的游戏经历" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="submitForm" :loading="loading">提交申请</el-button>
          <el-button @click="goBack">返回</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script>
import { apply } from '@/api/gameclub/application'

export default {
  name: "ApplyPage",
  data() {
    return {
      form: {
        reason: ''
      },
      rules: {
        reason: [{ required: true, message: '请输入申请理由', trigger: 'blur' }]
      },
      loading: false
    }
  },
  computed: {
    guildName() {
      return this.$route.params.guildName || '工会'
    }
  },
  methods: {
    submitForm() {
      this.$refs.formRef.validate(valid => {
        if (valid) {
          this.loading = true
          apply({
            guildId: this.$route.params.guildId,
            reason: this.form.reason
          }).then(() => {
            this.$message.success('申请已提交，请等待审批')
            this.$router.push('/gameclub-portal')
          }).finally(() => {
            this.loading = false
          })
        }
      })
    },
    goBack() {
      this.$router.back()
    }
  }
}
</script>

<style scoped>
.apply-page {
  max-width: 600px;
  margin: 40px auto;
}
.apply-card h1 {
  text-align: center;
  margin: 0;
}
</style>
```

---

## 第三阶段：用户工作台页面

### Task 7: 创建工作台首页

**Files:**
- Create: `ruoyi-ui/src/views/gameclub-workspace/home/index.vue`

- [ ] **Step 1: 创建工作台首页组件**

```vue
<!-- ruoyi-ui/src/views/gameclub-workspace/home/index.vue -->
<template>
  <div class="workspace-home">
    <h1>欢迎回来，{{ userName }}</h1>

    <el-row :gutter="20" class="stats-row">
      <el-col :xs="24" :sm="8">
        <div class="stat-card">
          <div class="stat-icon" style="background: #409EFF;">🎮</div>
          <div class="stat-info">
            <span class="stat-num">{{ myGuilds.length }}</span>
            <span class="stat-label">我的工会</span>
          </div>
        </div>
      </el-col>
      <el-col :xs="24" :sm="8">
        <div class="stat-card">
          <div class="stat-icon" style="background: #67C23A;">📋</div>
          <div class="stat-info">
            <span class="stat-num">{{ pendingApplications }}</span>
            <span class="stat-label">待审批</span>
          </div>
        </div>
      </el-col>
      <el-col :xs="24" :sm="8">
        <div class="stat-card">
          <div class="stat-icon" style="background: #E6A23C;">👥</div>
          <div class="stat-info">
            <span class="stat-num">{{ totalMembers }}</span>
            <span class="stat-label">总成员</span>
          </div>
        </div>
      </el-col>
    </el-row>

    <el-row :gutter="20">
      <el-col :xs="24" :lg="12">
        <el-card>
          <div slot="header">
            <span>我的工会</span>
            <el-button style="float: right;" type="text" @click="$router.push('/gameclub-workspace/guilds')">管理</el-button>
          </div>
          <div v-if="myGuilds.length === 0" class="empty-text">暂无工会</div>
          <div v-else class="guild-list">
            <div v-for="guild in myGuilds" :key="guild.id" class="guild-item" @click="goToGuild(guild.id)">
              <span class="guild-name">{{ guild.name }}</span>
              <span class="guild-members">{{ guild.memberCount }} 成员</span>
            </div>
          </div>
        </el-card>
      </el-col>

      <el-col :xs="24" :lg="12">
        <el-card>
          <div slot="header">
            <span>待审批申请</span>
            <el-button style="float: right;" type="text" @click="$router.push('/gameclub-workspace/applications')">查看全部</el-button>
          </div>
          <div v-if="recentApplications.length === 0" class="empty-text">暂无待审批申请</div>
          <el-table v-else :data="recentApplications" size="small">
            <el-table-column prop="applicantName" label="申请人" />
            <el-table-column prop="guildName" label="工会" />
            <el-table-column prop="createdAt" label="申请时间" />
            <el-table-column label="操作" width="100">
              <template slot-scope="scope">
                <el-button type="text" size="small" @click="handleApprove(scope.row, 1)">通过</el-button>
                <el-button type="text" size="small" @click="handleApprove(scope.row, 2)">拒绝</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import { listMyGuilds } from '@/api/gameclub/guild'
import { listApplication, approveApplication } from '@/api/gameclub/application'

export default {
  name: "WorkspaceHome",
  data() {
    return {
      myGuilds: [],
      recentApplications: [],
      pendingApplications: 0,
      totalMembers: 0
    }
  },
  computed: {
    userName() {
      return this.$store.state.user.name || '用户'
    }
  },
  created() {
    this.loadData()
  },
  methods: {
    loadData() {
      listMyGuilds().then(res => {
        this.myGuilds = res.rows
        this.totalMembers = res.rows.reduce((sum, g) => sum + (g.memberCount || 0), 0)
      })
      listApplication({ status: 0 }).then(res => {
        this.pendingApplications = res.total
        this.recentApplications = res.rows.slice(0, 5)
      })
    },
    goToGuild(id) {
      this.$router.push(`/gameclub-workspace/guild/${id}`)
    },
    handleApprove(row, status) {
      this.$confirm(`确认${status === 1 ? '通过' : '拒绝'}该申请?`).then(() => {
        approveApplication(row.id, status).then(() => {
          this.$message.success('操作成功')
          this.loadData()
        })
      })
    }
  }
}
</script>

<style scoped>
.workspace-home h1 {
  margin-bottom: 30px;
}
.stats-row {
  margin-bottom: 30px;
}
.stat-card {
  background: white;
  padding: 20px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  box-shadow: 0 2px 12px rgba(0,0,0,0.05);
}
.stat-icon {
  width: 60px;
  height: 60px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 28px;
  margin-right: 15px;
}
.stat-info {
  display: flex;
  flex-direction: column;
}
.stat-num {
  font-size: 28px;
  font-weight: bold;
  color: #333;
}
.stat-label {
  font-size: 14px;
  color: #666;
}
.empty-text {
  text-align: center;
  color: #999;
  padding: 40px 0;
}
.guild-list {
  max-height: 300px;
  overflow-y: auto;
}
.guild-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 0;
  border-bottom: 1px solid #f0f0f0;
  cursor: pointer;
}
.guild-item:hover .guild-name {
  color: #409EFF;
}
.guild-item:last-child {
  border-bottom: none;
}
.guild-name {
  font-weight: 500;
}
.guild-members {
  color: #666;
  font-size: 14px;
}
</style>
```

### Task 8: 创建工会管理页面

**Files:**
- Create: `ruoyi-ui/src/views/gameclub-workspace/guilds/index.vue`
- Create: `ruoyi-ui/src/views/gameclub-workspace/guild-manage/index.vue`

- [ ] **Step 1: 创建我的工会列表页**

```vue
<!-- ruoyi-ui/src/views/gameclub-workspace/guilds/index.vue -->
<template>
  <div class="guilds-page">
    <div class="page-header">
      <h2>我的工会</h2>
    </div>

    <el-row :gutter="20">
      <el-col :xs="24" :sm="12" :md="8" v-for="guild in guilds" :key="guild.id">
        <el-card class="guild-card" shadow="hover">
          <div class="guild-header">
            <span class="guild-icon">🎮</span>
            <h3>{{ guild.name }}</h3>
          </div>
          <div class="guild-info">
            <p><span class="label">分区:</span> {{ guild.partitionName }}</p>
            <p><span class="label">成员:</span> {{ guild.memberCount }}</p>
            <p><span class="label">状态:</span>
              <el-tag :type="guild.status === 1 ? 'success' : 'info'" size="small">
                {{ guild.status === 1 ? '招募中' : '暂停' }}
              </el-tag>
            </p>
          </div>
          <div class="guild-actions">
            <el-button type="primary" size="small" @click="manageGuild(guild.id)">管理</el-button>
            <el-button size="small" @click="editGuild(guild)">编辑</el-button>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <div v-if="guilds.length === 0" class="empty-box">
      <p>您还没有创建工会</p>
    </div>
  </div>
</template>

<script>
import { listMyGuilds } from '@/api/gameclub/guild'

export default {
  name: "GuildsPage",
  data() {
    return {
      guilds: []
    }
  },
  created() {
    this.loadData()
  },
  methods: {
    loadData() {
      listMyGuilds().then(res => {
        this.guilds = res.rows
      })
    },
    manageGuild(id) {
      this.$router.push(`/gameclub-workspace/guild/${id}`)
    },
    editGuild(guild) {
      this.$prompt('请输入工会名称', '编辑工会', {
        inputValue: guild.name
      }).then(({ value }) => {
        // TODO: 调用更新接口
        this.$message.success('更新成功')
      })
    }
  }
}
</script>

<style scoped>
.page-header {
  margin-bottom: 20px;
}
.page-header h2 {
  margin: 0;
}
.guild-card {
  margin-bottom: 20px;
}
.guild-header {
  display: flex;
  align-items: center;
  margin-bottom: 15px;
}
.guild-icon {
  font-size: 40px;
  margin-right: 15px;
}
.guild-header h3 {
  margin: 0;
}
.guild-info p {
  margin: 8px 0;
  color: #666;
}
.guild-info .label {
  color: #999;
}
.guild-actions {
  margin-top: 15px;
  display: flex;
  gap: 10px;
}
.empty-box {
  text-align: center;
  padding: 60px 0;
  background: white;
  border-radius: 8px;
  color: #999;
}
</style>
```

- [ ] **Step 2: 创建工会管理详情页**

```vue
<!-- ruoyi-ui/src/views/gameclub-workspace/guild-manage/index.vue -->
<template>
  <div class="guild-manage">
    <div class="page-header">
      <el-button icon="el-icon-back" @click="$router.push('/gameclub-workspace/guilds')">返回</el-button>
      <h2>{{ guild.name }} - 管理</h2>
    </div>

    <el-tabs v-model="activeTab" type="border-card">
      <el-tab-pane label="概览" name="overview">
        <el-card>
          <el-descriptions :column="2" border>
            <el-descriptions-item label="工会名称">{{ guild.name }}</el-descriptions-item>
            <el-descriptions-item label="所属分区">{{ guild.partitionName }}</el-descriptions-item>
            <el-descriptions-item label="会长">{{ guild.presidentName }}</el-descriptions-item>
            <el-descriptions-item label="成员数">{{ guild.memberCount }}</el-descriptions-item>
            <el-descriptions-item label="创建时间">{{ guild.createdAt }}</el-descriptions-item>
            <el-descriptions-item label="状态">
              <el-switch v-model="guildStatus" @change="handleStatusChange" />
            </el-descriptions-item>
            <el-descriptions-item label="简介" :span="2">{{ guild.description || '暂无' }}</el-descriptions-item>
          </el-descriptions>
          <div style="margin-top: 20px;">
            <el-button type="primary" @click="showEditDialog = true">编辑信息</el-button>
          </div>
        </el-card>
      </el-tab-pane>

      <el-tab-pane label="成员管理" name="members">
        <member-management :guild-id="guildId" />
      </el-tab-pane>

      <el-tab-pane label="公告管理" name="announcements">
        <announcement-management :guild-id="guildId" />
      </el-tab-pane>

      <el-tab-pane label="申请审批" name="applications">
        <application-management :guild-id="guildId" />
      </el-tab-pane>

      <el-tab-pane label="黑名单" name="blacklist">
        <blacklist-management :guild-id="guildId" />
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
import { getGuild, updateGuild } from '@/api/gameclub/guild'
import MemberManagement from './members.vue'
import AnnouncementManagement from './announcements.vue'
import ApplicationManagement from './applications.vue'
import BlacklistManagement from './blacklist.vue'

export default {
  name: "GuildManage",
  components: {
    MemberManagement,
    AnnouncementManagement,
    ApplicationManagement,
    BlacklistManagement
  },
  data() {
    return {
      guildId: null,
      guild: {},
      activeTab: 'overview',
      showEditDialog: false
    }
  },
  computed: {
    guildStatus: {
      get() {
        return this.guild.status === 1
      },
      set(val) {
        this.guild.status = val ? 1 : 0
      }
    }
  },
  created() {
    this.guildId = parseInt(this.$route.params.id)
    this.loadGuild()
  },
  methods: {
    loadGuild() {
      getGuild(this.guildId).then(res => {
        this.guild = res.data
      })
    },
    handleStatusChange(val) {
      updateGuild({ id: this.guildId, status: val ? 1 : 0 }).then(() => {
        this.$message.success('状态更新成功')
      })
    }
  }
}
</script>

<style scoped>
.page-header {
  display: flex;
  align-items: center;
  margin-bottom: 20px;
}
.page-header h2 {
  margin: 0 0 0 20px;
}
</style>
```

### Task 9: 创建成员管理组件

**Files:**
- Create: `ruoyi-ui/src/views/gameclub-workspace/guild-manage/members.vue`

- [ ] **Step 1: 创建成员管理组件**

```vue
<!-- ruoyi-ui/src/views/gameclub-workspace/guild-manage/members.vue -->
<template>
  <div class="member-management">
    <div class="toolbar">
      <el-input v-model="searchKeyword" placeholder="搜索成员" style="width: 200px;" clearable>
        <i slot="prefix" class="el-icon-search"></i>
      </el-input>
      <el-button type="primary" @click="showAddDialog = true">添加成员</el-button>
    </div>

    <el-table :data="filteredMembers" v-loading="loading">
      <el-table-column prop="nickName" label="昵称" />
      <el-table-column prop="roleName" label="职位">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.role === 1" type="warning">会长</el-tag>
          <el-tag v-else-if="scope.row.role === 2" type="primary">管理员</el-tag>
          <el-tag v-else type="info">成员</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="joinTime" label="加入时间" />
      <el-table-column label="操作" width="200">
        <template slot-scope="scope">
          <el-button type="text" size="small" @click="handleSetRole(scope.row)">设置职位</el-button>
          <el-button type="text" size="small" @click="handleRemove(scope.row)">移除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog title="添加成员" :visible.sync="showAddDialog" width="500px">
      <el-form :model="addForm" label-width="100px">
        <el-form-item label="用户ID">
          <el-input v-model="addForm.userId" placeholder="请输入用户ID" />
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="showAddDialog = false">取消</el-button>
        <el-button type="primary" @click="submitAdd">确定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listMember, addMember, removeMember, setMemberRole } from '@/api/gameclub/member'

export default {
  name: "MemberManagement",
  props: {
    guildId: {
      type: Number,
      required: true
    }
  },
  data() {
    return {
      members: [],
      loading: false,
      searchKeyword: '',
      showAddDialog: false,
      addForm: {
        userId: ''
      }
    }
  },
  computed: {
    filteredMembers() {
      if (!this.searchKeyword) return this.members
      return this.members.filter(m => m.nickName.includes(this.searchKeyword))
    }
  },
  created() {
    this.loadData()
  },
  methods: {
    loadData() {
      this.loading = true
      listMember({ guildId: this.guildId }).then(res => {
        this.members = res.rows
      }).finally(() => {
        this.loading = false
      })
    },
    handleSetRole(row) {
      this.$prompt('请输入职位 (1-会长, 2-管理员, 3-成员)', '设置职位', {
        inputValue: String(row.role)
      }).then(({ value }) => {
        setMemberRole(row.id, parseInt(value)).then(() => {
          this.$message.success('设置成功')
          this.loadData()
        })
      })
    },
    handleRemove(row) {
      this.$confirm('确认移除该成员?').then(() => {
        removeMember(row.id).then(() => {
          this.$message.success('移除成功')
          this.loadData()
        })
      })
    },
    submitAdd() {
      addMember({
        guildId: this.guildId,
        userId: this.addForm.userId
      }).then(() => {
        this.$message.success('添加成功')
        this.showAddDialog = false
        this.loadData()
      })
    }
  }
}
</script>

<style scoped>
.toolbar {
  display: flex;
  justify-content: space-between;
  margin-bottom: 20px;
}
</style>
```

### Task 10: 创建公告管理组件

**Files:**
- Create: `ruoyi-ui/src/views/gameclub-workspace/guild-manage/announcements.vue`

- [ ] **Step 1: 创建公告管理组件**

```vue
<!-- ruoyi-ui/src/views/gameclub-workspace/guild-manage/announcements.vue -->
<template>
  <div class="announcement-management">
    <div class="toolbar">
      <el-button type="primary" @click="showAddDialog = true">发布公告</el-button>
    </div>

    <el-table :data="announcements" v-loading="loading">
      <el-table-column prop="title" label="标题" />
      <el-table-column prop="type" label="类型" width="100">
        <template slot-scope="scope">
          <el-tag :type="getTypeTag(scope.row.type)">{{ getTypeText(scope.row.type) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="publishedAt" label="发布时间" width="180" />
      <el-table-column prop="status" label="状态" width="100">
        <template slot-scope="scope">
          <el-tag :type="scope.row.status === 1 ? 'success' : 'info'">
            {{ scope.row.status === 1 ? '已发布' : '草稿' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="200">
        <template slot-scope="scope">
          <el-button type="text" size="small" @click="handleEdit(scope.row)">编辑</el-button>
          <el-button type="text" size="small" @click="handleDelete(scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog :title="isEdit ? '编辑公告' : '发布公告'" :visible.sync="showAddDialog" width="600px">
      <el-form :model="form" :rules="rules" ref="formRef" label-width="100px">
        <el-form-item label="标题" prop="title">
          <el-input v-model="form.title" placeholder="请输入公告标题" />
        </el-form-item>
        <el-form-item label="类型" prop="type">
          <el-select v-model="form.type" placeholder="请选择类型">
            <el-option label="普通" :value="1" />
            <el-option label="重要" :value="2" />
            <el-option label="紧急" :value="3" />
          </el-select>
        </el-form-item>
        <el-form-item label="内容" prop="content">
          <el-input v-model="form.content" type="textarea" :rows="6" placeholder="请输入公告内容" />
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="showAddDialog = false">取消</el-button>
        <el-button type="primary" @click="submitForm">发布</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listAnnouncement, addAnnouncement, updateAnnouncement, deleteAnnouncement } from '@/api/gameclub/announcement'

export default {
  name: "AnnouncementManagement",
  props: {
    guildId: {
      type: Number,
      required: true
    }
  },
  data() {
    return {
      announcements: [],
      loading: false,
      showAddDialog: false,
      isEdit: false,
      form: {
        id: null,
        title: '',
        type: 1,
        content: ''
      },
      rules: {
        title: [{ required: true, message: '请输入标题', trigger: 'blur' }],
        content: [{ required: true, message: '请输入内容', trigger: 'blur' }]
      }
    }
  },
  created() {
    this.loadData()
  },
  methods: {
    loadData() {
      this.loading = true
      listAnnouncement({ guildId: this.guildId }).then(res => {
        this.announcements = res.rows
      }).finally(() => {
        this.loading = false
      })
    },
    getTypeTag(type) {
      const map = { 1: '', 2: 'warning', 3: 'danger' }
      return map[type] || ''
    },
    getTypeText(type) {
      const map = { 1: '普通', 2: '重要', 3: '紧急' }
      return map[type] || '未知'
    },
    handleEdit(row) {
      this.isEdit = true
      this.form = { ...row }
      this.showAddDialog = true
    },
    handleDelete(row) {
      this.$confirm('确认删除该公告?').then(() => {
        deleteAnnouncement(row.id).then(() => {
          this.$message.success('删除成功')
          this.loadData()
        })
      })
    },
    submitForm() {
      this.$refs.formRef.validate(valid => {
        if (valid) {
          const data = { ...this.form, guildId: this.guildId, status: 1 }
          const action = this.isEdit ? updateAnnouncement(data) : addAnnouncement(data)
          action.then(() => {
            this.$message.success(this.isEdit ? '更新成功' : '发布成功')
            this.showAddDialog = false
            this.loadData()
          })
        }
      })
    }
  }
}
</script>

<style scoped>
.toolbar {
  margin-bottom: 20px;
}
</style>
```

### Task 11: 创建申请审批组件

**Files:**
- Create: `ruoyi-ui/src/views/gameclub-workspace/guild-manage/applications.vue`

- [ ] **Step 1: 创建申请审批组件**

```vue
<!-- ruoyi-ui/src/views/gameclub-workspace/guild-manage/applications.vue -->
<template>
  <div class="application-management">
    <el-tabs v-model="status" @tab-change="loadData">
      <el-tab-pane label="全部" name="all"></el-tab-pane>
      <el-tab-pane label="待审批" name="0"></el-tab-pane>
      <el-tab-pane label="已通过" name="1"></el-tab-pane>
      <el-tab-pane label="已拒绝" name="2"></el-tab-pane>
    </el-tabs>

    <el-table :data="applications" v-loading="loading">
      <el-table-column prop="applicantName" label="申请人" />
      <el-table-column prop="guildName" label="工会" />
      <el-table-column prop="reason" label="申请理由" :show-overflow-tooltip="true" />
      <el-table-column prop="createdAt" label="申请时间" width="180" />
      <el-table-column prop="status" label="状态" width="100">
        <template slot-scope="scope">
          <el-tag :type="getStatusTag(scope.row.status)">{{ getStatusText(scope.row.status) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="150" v-if="status === '0' || status === 'all'">
        <template slot-scope="scope" v-if="scope.row.status === 0">
          <el-button type="text" size="small" @click="handleApprove(scope.row, 1)">通过</el-button>
          <el-button type="text" size="small" @click="handleApprove(scope.row, 2)">拒绝</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
import { listApplication, approveApplication } from '@/api/gameclub/application'

export default {
  name: "ApplicationManagement",
  props: {
    guildId: {
      type: Number,
      required: true
    }
  },
  data() {
    return {
      applications: [],
      loading: false,
      status: 'all'
    }
  },
  created() {
    this.loadData()
  },
  methods: {
    loadData() {
      this.loading = true
      const params = { guildId: this.guildId }
      if (this.status !== 'all') {
        params.status = parseInt(this.status)
      }
      listApplication(params).then(res => {
        this.applications = res.rows
      }).finally(() => {
        this.loading = false
      })
    },
    getStatusTag(status) {
      const map = { 0: 'warning', 1: 'success', 2: 'danger' }
      return map[status] || 'info'
    },
    getStatusText(status) {
      const map = { 0: '待审批', 1: '已通过', 2: '已拒绝' }
      return map[status] || '未知'
    },
    handleApprove(row, status) {
      this.$confirm(`确认${status === 1 ? '通过' : '拒绝'}该申请?`).then(() => {
        approveApplication(row.id, status).then(() => {
          this.$message.success('操作成功')
          this.loadData()
        })
      })
    }
  }
}
</script>
```

### Task 12: 创建黑名单管理组件

**Files:**
- Create: `ruoyi-ui/src/views/gameclub-workspace/guild-manage/blacklist.vue`

- [ ] **Step 1: 创建黑名单管理组件**

```vue
<!-- ruoyi-ui/src/views/gameclub-workspace/guild-manage/blacklist.vue -->
<template>
  <div class="blacklist-management">
    <div class="toolbar">
      <el-button type="primary" @click="showAddDialog = true">添加黑名单</el-button>
    </div>

    <el-table :data="blacklist" v-loading="loading">
      <el-table-column prop="userName" label="用户名" />
      <el-table-column prop="reason" label="原因" :show-overflow-tooltip="true" />
      <el-table-column prop="createdAt" label="添加时间" width="180" />
      <el-table-column label="操作" width="150">
        <template slot-scope="scope">
          <el-button type="text" size="small" @click="handleRemove(scope.row)">移除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog title="添加黑名单" :visible.sync="showAddDialog" width="500px">
      <el-form :model="addForm" :rules="rules" ref="addFormRef" label-width="100px">
        <el-form-item label="用户ID" prop="userId">
          <el-input v-model="addForm.userId" placeholder="请输入用户ID" />
        </el-form-item>
        <el-form-item label="原因" prop="reason">
          <el-input v-model="addForm.reason" type="textarea" :rows="3" placeholder="请输入加入黑名单的原因" />
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="showAddDialog = false">取消</el-button>
        <el-button type="primary" @click="submitAdd">确定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listBlacklist, addBlacklist, removeBlacklist } from '@/api/gameclub/blacklist'

export default {
  name: "BlacklistManagement",
  props: {
    guildId: {
      type: Number,
      required: true
    }
  },
  data() {
    return {
      blacklist: [],
      loading: false,
      showAddDialog: false,
      addForm: {
        userId: '',
        reason: ''
      },
      rules: {
        userId: [{ required: true, message: '请输入用户ID', trigger: 'blur' }],
        reason: [{ required: true, message: '请输入原因', trigger: 'blur' }]
      }
    }
  },
  created() {
    this.loadData()
  },
  methods: {
    loadData() {
      this.loading = true
      listBlacklist({ guildId: this.guildId }).then(res => {
        this.blacklist = res.rows
      }).finally(() => {
        this.loading = false
      })
    },
    handleRemove(row) {
      this.$confirm('确认移除该用户出黑名单?').then(() => {
        removeBlacklist(row.id).then(() => {
          this.$message.success('移除成功')
          this.loadData()
        })
      })
    },
    submitAdd() {
      this.$refs.addFormRef.validate(valid => {
        if (valid) {
          addBlacklist({
            guildId: this.guildId,
            userId: this.addForm.userId,
            reason: this.addForm.reason
          }).then(() => {
            this.$message.success('添加成功')
            this.showAddDialog = false
            this.loadData()
          })
        }
      })
    }
  }
}
</script>

<style scoped>
.toolbar {
  margin-bottom: 20px;
}
</style>
```

---

## 实现检查清单

在完成所有任务后，请确认以下内容：

- [ ] 前台门户首页正常显示
- [ ] 游戏分区详情页正常显示
- [ ] 工会详情页正常显示
- [ ] 申请加入功能正常工作
- [ ] 用户工作台首页正常显示
- [ ] 工会管理功能正常
- [ ] 成员管理功能正常
- [ ] 公告管理功能正常
- [ ] 申请审批功能正常
- [ ] 黑名单管理功能正常
- [ ] 路由跳转正常
- [ ] 权限控制正常
