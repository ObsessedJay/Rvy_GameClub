<template>
  <div class="portal-home">
    <!-- 顶部导航 -->
    <nav class="nav-header">
      <div class="nav-container">
        <div class="nav-logo" @click="scrollToTop">
          <span class="logo-icon">🎮</span>
          <span class="logo-text">GameClub</span>
        </div>
        <div class="nav-menu">
          <a href="#home" class="nav-item" :class="{ active: activeSection === 'home' }" @click="setActiveSection('home')">首页</a>
          <a href="#partitions" class="nav-item" :class="{ active: activeSection === 'partitions' }" @click="setActiveSection('partitions')">游戏分区</a>
          <a href="#guilds" class="nav-item" :class="{ active: activeSection === 'guilds' }" @click="setActiveSection('guilds')">热门工会</a>
          <a href="#news" class="nav-item" :class="{ active: activeSection === 'news' }" @click="setActiveSection('news')">资讯动态</a>
        </div>
        <button class="mobile-menu-btn" @click="toggleMobileMenu">
          <span class="menu-icon">☰</span>
        </button>
        <div class="nav-user" v-if="hasToken">
          <div class="user-avatar">
            <span>👤</span>
          </div>
          <div class="user-info">
            <span class="user-name">{{ username }}</span>
            <span class="user-role">{{ roleName }}</span>
          </div>
          <div class="user-actions">
            <button class="myguild-btn" @click="goMyGuild">我的工会</button>
            <button v-if="canCreateGuild" class="create-btn" @click="showCreateGuild = true">创建工会</button>
            <button class="logout-btn" @click="handleLogout">退出</button>
          </div>
        </div>
        <div class="nav-login" v-else>
          <a href="/login" class="login-link">前往登录</a>
        </div>
      </div>
    </nav>

    <!-- Hero区域 -->
    <section class="hero-section" id="home">
      <div class="hero-bg">
        <div class="bg-gradient"></div>
        <div class="bg-pattern"></div>
        <div class="bg-overlay"></div>
      </div>
      <div class="hero-container">
        <div class="hero-content">
          <div class="hero-tag">游戏工会平台</div>
          <h1 class="hero-title">
            <span class="title-main">征战电竞</span>
            <span class="title-sub">共创辉煌</span>
          </h1>
          <p class="hero-desc">汇聚顶尖玩家，打造最强工会，征战各大电竞赛场</p>
          <div class="hero-stats">
            <div class="stat-item">
              <span class="stat-value">{{ partitionList.length || 0 }}</span>
              <span class="stat-label">游戏分区</span>
            </div>
            <div class="stat-divider"></div>
            <div class="stat-item">
              <span class="stat-value">{{ guildCount }}</span>
              <span class="stat-label">活跃工会</span>
            </div>
            <div class="stat-divider"></div>
            <div class="stat-item">
              <span class="stat-value">{{ memberCount }}</span>
              <span class="stat-label">玩家数</span>
            </div>
          </div>
          <div class="hero-action">
            <button class="btn-primary" @click="scrollToPartitions">
              <span>探索分区</span>
              <span class="btn-arrow">→</span>
            </button>
          </div>
        </div>
        <div class="hero-visual">
          <div class="hero-card card-1">
            <span class="card-emoji">🎯</span>
            <span class="card-text">英雄联盟</span>
          </div>
          <div class="hero-card card-2">
            <span class="card-emoji">⚔️</span>
            <span class="card-text">魔兽世界</span>
          </div>
          <div class="hero-card card-3">
            <span class="card-emoji">🏆</span>
            <span class="card-text">DOTA2</span>
          </div>
          <div class="hero-card card-4">
            <span class="card-emoji">🔫</span>
            <span class="card-text">CSGO</span>
          </div>
        </div>
      </div>
      <div class="hero-wave"></div>
    </section>

    <!-- 游戏分区 -->
    <section class="partitions-section" id="partitions">
      <div class="section-container">
        <div class="section-header">
          <span class="section-tag">GAME ZONE</span>
          <h2 class="section-title">热门游戏分区</h2>
          <p class="section-desc">选择你热爱的游戏，加入志同道合的工会</p>
        </div>
        <div class="partitions-grid">
          <div 
            class="partition-card" 
            v-for="(partition, index) in displayPartitions" 
            :key="partition.id || 'all'"
            :style="{ animationDelay: index * 0.15 + 's' }"
            @click="partition.id ? goToPartition(partition.id) : goToAllPartitions()"
          >
            <div class="card-bg"></div>
            <div class="card-content">
              <div class="card-icon">{{ getPartitionIcon(partition) }}</div>
              <h3 class="card-title">{{ partition.title || partition.gameName }}</h3>
              <p class="card-desc">{{ partition.desc || partition.description || '热门游戏分区' }}</p>
              <div class="card-stats">
                <span class="stat">{{ getPartitionGuildCount(partition) }} 工会</span>
                <span class="stat">{{ partition.id ? (partition.memberCount || 0) + ' 成员' : '全部' }}</span>
              </div>
              <div class="card-border"></div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 热门工会 -->
    <section class="guilds-section" id="guilds">
      <div class="section-container">
        <div class="section-header">
          <span class="section-tag">TOP GUILDS</span>
          <h2 class="section-title">顶尖工会排行</h2>
          <p class="section-desc">实力与荣耀并存的顶级工会</p>
        </div>
        <div class="guilds-grid">
          <div 
            class="guild-card" 
            v-for="(guild, index) in hotGuilds.slice(0, 6)" 
            :key="guild.id"
            @click="goToGuild(guild.id)"
          >
            <div class="guild-rank" :class="'rank-' + (index + 1)">{{ index + 1 }}</div>
            <div class="guild-header">
              <div class="guild-avatar">
                <span>{{ getGuildAvatar(guild.name) }}</span>
              </div>
              <div class="guild-info">
                <h3 class="guild-name">{{ guild.name }}</h3>
                <span class="guild-game">{{ guild.partitionName }}</span>
              </div>
            </div>
            <div class="guild-stats">
              <div class="stat-box">
                <span class="stat-num">{{ guild.memberCount || 0 }}</span>
                <span class="stat-name">成员</span>
              </div>
              <div class="stat-box">
                <span class="stat-label-text">{{ guild.gamePartitionName || guild.partitionName || '-' }}</span>
                <span class="stat-name">分区</span>
              </div>
              <div class="stat-box">
                <span class="stat-label-text recruit">{{ guild.recruitRequirement ? '招募中' : '自由加入' }}</span>
                <span class="stat-name">状态</span>
              </div>
            </div>
            <div class="guild-desc">{{ guild.description || '欢迎加入我们的工会！' }}</div>
            <button class="join-btn" v-if="hasToken">申请加入</button>
            <button class="join-btn disabled" v-else>请先登录</button>
          </div>
          <div v-if="hotGuilds.length === 0" class="empty-card">
            <span class="empty-icon">🏰</span>
            <p>暂无热门工会</p>
          </div>
        </div>
      </div>
    </section>

    <!-- 资讯动态 -->
    <section class="news-section" id="news">
      <div class="section-container">
        <div class="section-header">
          <span class="section-tag">NEWS</span>
          <h2 class="section-title">最新资讯</h2>
          <p class="section-desc">工会动态与电竞赛事资讯</p>
        </div>
        <div class="news-container">
          <div class="news-main">
            <div class="main-card">
              <div class="card-img">
                <span class="img-icon">📰</span>
              </div>
              <div class="card-content">
                <span class="news-tag">赛事资讯</span>
                <h3 class="news-title">2024年度电竞联赛即将开赛</h3>
                <p class="news-desc">各大工会备战年度总决赛，谁将问鼎冠军宝座？</p>
                <span class="news-time">2024-01-15</span>
              </div>
            </div>
          </div>
          <div class="news-list">
            <div 
              class="news-item" 
              v-for="announcement in announcements.slice(0, 5)" 
              :key="announcement.id"
            >
              <div class="item-dot"></div>
              <div class="item-content">
                <h4>{{ announcement.title }}</h4>
                <span class="item-time">{{ parseTime(announcement.publishedAt) }}</span>
              </div>
            </div>
            <div v-if="announcements.length === 0" class="empty-news">
              <span>暂无资讯</span>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 页脚 -->
    <footer class="footer">
      <div class="footer-container">
        <div class="footer-content">
          <div class="footer-brand">
            <span class="brand-icon">🎮</span>
            <span class="brand-name">GameClub</span>
            <p class="brand-desc">游戏工会平台</p>
          </div>
          <div class="footer-links">
            <div class="link-group">
              <h4>关于我们</h4>
              <a href="#">平台介绍</a>
              <a href="#">联系我们</a>
              <a href="#">加入我们</a>
            </div>
            <div class="link-group">
              <h4>帮助支持</h4>
              <a href="#">常见问题</a>
              <a href="#">用户协议</a>
              <a href="#">隐私政策</a>
            </div>
            <div class="link-group">
              <h4>关注我们</h4>
              <a href="#">官方微博</a>
              <a href="#">官方微信</a>
              <a href="#">抖音账号</a>
            </div>
          </div>
        </div>
        <div class="footer-bottom">
          <p>© 2024 GameClub. All rights reserved.</p>
        </div>
      </div>
    </footer>

    <!-- 创建工会弹窗 -->
    <el-dialog title="创建工会" :visible.sync="showCreateGuild" width="480px" :close-on-click-modal="false">
      <el-form ref="createFormRef" :model="createForm" :rules="createFormRules" label-width="90px">
        <el-form-item label="游戏分区" prop="gamePartitionId">
          <el-select v-model="createForm.gamePartitionId" placeholder="请选择游戏分区" style="width:100%">
            <el-option v-for="p in partitionList" :key="p.id" :label="p.gameName" :value="p.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="工会名称" prop="guildName">
          <el-input v-model="createForm.guildName" placeholder="请输入工会名称（本分区唯一）" />
        </el-form-item>
        <el-form-item label="工会简介">
          <el-input v-model="createForm.description" type="textarea" :rows="3" placeholder="描述你的工会" />
        </el-form-item>
        <el-form-item label="招募要求">
          <el-input v-model="createForm.recruitRequirement" type="textarea" :rows="2" placeholder="招募成员的要求" />
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="showCreateGuild = false">取消</el-button>
        <el-button type="primary" @click="submitCreateGuild">提交申请</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getToken } from '@/utils/auth'
import { publicListGamePartition } from '@/api/gameclub/partition'
import { listPublicGuilds, createGuildApply } from '@/api/gameclub/guild'
import { listAnnouncement } from '@/api/gameclub/announcement'
import { getMyGuilds } from '@/api/gameclub/member'

export default {
  name: "PortalHome",
  data() {
    return {
      partitionList: [],
      hotGuilds: [],
      announcements: [],
      guildCount: 0,
      memberCount: 0,
      activeSection: 'home',
      mobileMenuOpen: false,
      isScrolling: false,
      sections: ['home', 'partitions', 'guilds', 'news'],
      realUsername: '',
      realRole: null,
      realGuildIds: [],
      // 创建工会
      showCreateGuild: false,
      createForm: { gamePartitionId: null, guildName: '', description: '', recruitRequirement: '' },
      createFormRules: {
        gamePartitionId: [{ required: true, message: '请选择游戏分区', trigger: 'change' }],
        guildName: [{ required: true, message: '请输入工会名称', trigger: 'blur' }]
      }
    }
  },
  computed: {
    hasToken() {
      return !!getToken()
    },
    username() {
      return this.realUsername || this.$store.state.user.nickName || this.$store.state.user.name || '用户'
    },
    roleName() {
      const roleMap = { 1: '会长', 2: '管理员', 3: '普通成员', 4: '无工会用户' }
      if (this.realRole != null) return roleMap[this.realRole] || '无工会用户'
      return '普通会员'
    },
    canCreateGuild() {
      return this.hasToken
    },
    displayPartitions() {
      const randomPartitions = this.partitionList.length > 0 
        ? this.shuffleArray(this.partitionList).slice(0, 3) 
        : []
      
      const allPartitionCard = {
        id: null,
        icon: '🎮',
        title: '所有分区',
        desc: '探索更多游戏分区'
      }
      
      return [...randomPartitions, allPartitionCard]
    }
  },
  created() {
    this.fetchMyRole()
    this.loadData()
    this.setupScrollListener()
    this.setupWheelListener()
  },
  beforeUnmount() {
    window.removeEventListener('scroll', this.handleScroll)
    window.removeEventListener('wheel', this.handleWheel, { passive: false })
  },
  methods: {
    loadData() {
      publicListGamePartition().then(res => {
        this.partitionList = res.data || []
      }).catch(() => {
        this.partitionList = []
      })
      listPublicGuilds().then(res => {
        const list = res.data || []
        this.hotGuilds = list
        this.guildCount = this.hotGuilds.length
        this.memberCount = this.hotGuilds.reduce((sum, g) => sum + (g.memberCount || 0), 0)
      }).catch(() => {
        this.hotGuilds = []
      })
      listAnnouncement().then(res => {
        this.announcements = res.rows || []
      }).catch(() => {
        this.announcements = []
      })
    },
    handleLogout() {
      this.$store.dispatch('LogOut').then(() => {
        this.$router.push('/login')
      }).catch(() => {
        console.error('退出失败')
      })
    },
    toggleMobileMenu() {
      this.mobileMenuOpen = !this.mobileMenuOpen
    },
    setupScrollListener() {
      window.addEventListener('scroll', this.handleScroll)
    },
    setupWheelListener() {
      window.addEventListener('wheel', this.handleWheel, { passive: false })
    },
    handleWheel(e) {
      if (this.isScrolling) {
        e.preventDefault()
        return
      }

      const currentIndex = this.sections.indexOf(this.activeSection)
      let nextIndex = currentIndex

      if (e.deltaY > 0 && currentIndex < this.sections.length - 1) {
        nextIndex = currentIndex + 1
      } else if (e.deltaY < 0 && currentIndex > 0) {
        nextIndex = currentIndex - 1
      }

      if (nextIndex !== currentIndex) {
        e.preventDefault()
        this.scrollToSection(this.sections[nextIndex])
      }
    },
    handleScroll() {
      if (this.isScrolling) return
      
      const scrollPosition = window.scrollY + window.innerHeight / 2
      
      for (const section of this.sections) {
        const element = document.getElementById(section)
        if (element) {
          const offsetTop = element.offsetTop
          const offsetHeight = element.offsetHeight
          if (scrollPosition >= offsetTop && scrollPosition < offsetTop + offsetHeight) {
            this.activeSection = section
            break
          }
        }
      }
    },
    setActiveSection(section) {
      this.scrollToSection(section)
    },
    scrollToSection(section) {
      const element = document.getElementById(section)
      if (element) {
        this.isScrolling = true
        this.activeSection = section
        
        element.scrollIntoView({ 
          behavior: 'smooth',
          block: 'start'
        })
        
        setTimeout(() => {
          this.isScrolling = false
        }, 800)
      }
    },
    scrollToTop() {
      window.scrollTo({ top: 0, behavior: 'smooth' })
    },
    goToPartition(id) {
      this.$router.push(`/gameclub-portal/partition/${id}`)
    },
    goToAllPartitions() {
      this.$router.push('/gameclub-portal/partitions')
    },
    goToGuild(id) {
      this.$router.push(`/gameclub-portal/guild/${id}`)
    },
    shuffleArray(array) {
      const shuffled = [...array]
      for (let i = shuffled.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1))
        const temp = shuffled[i]
        shuffled[i] = shuffled[j]
        shuffled[j] = temp
      }
      return shuffled
    },
    goToLogin() {
      window.location.href = '/login'
    },
    parseTime(time) {
      if (!time) return ''
      const date = new Date(time)
      return date.toLocaleDateString('zh-CN')
    },
    getGameIcon(gameName) {
      const icons = {
        '英雄联盟': '🎮',
        '魔兽世界': '⚔️',
        'DOTA2': '🏆',
        'CSGO': '🎯',
        '王者荣耀': '⚡',
        '原神': '✨'
      }
      return icons[gameName] || '🎮'
    },
    getGuildAvatar(name) {
      const avatars = ['🏰', '⚔️', '🛡️', '⭐', '🔥', '💎']
      let hash = 0
      for (let i = 0; i < name.length; i++) {
        hash = name.charCodeAt(i) + ((hash << 5) - hash)
      }
      return avatars[Math.abs(hash) % avatars.length]
    },
    getOnlineCount(partitionId) {
      return Math.floor(Math.random() * 500) + 100
    },
    getPartitionIcon(partition) {
      if (partition.icon && !partition.icon.includes('/')) {
        return partition.icon
      }
      return this.getGameIcon(partition.gameName)
    },
    getPartitionGuildCount(partition) {
      if (partition.guildCount !== undefined && partition.guildCount !== null) {
        return partition.guildCount
      }
      if (!partition.id) {
        return this.partitionList.reduce((sum, p) => sum + (p.guildCount || 0), 0)
      }
      return 0
    },
    scrollToPartitions() {
      document.getElementById('partitions').scrollIntoView({ behavior: 'smooth' })
    },
    fetchMyRole() {
      if (!this.hasToken) return
      getMyGuilds().then(response => {
        const guilds = response.data || []
        if (guilds.length > 0) {
          const first = guilds[0]
          this.realUsername = first.nickName
          this.realRole = first.role
          this.realGuildIds = guilds.map(g => g.guildId)
        } else {
          this.realRole = 4
          this.realGuildIds = []
          this.realUsername = this.$store.state.user.nickName || this.$store.state.user.name || '用户'
        }
      }).catch(() => {})
    },
    goMyGuild() {
      if (this.realGuildIds.length === 0) {
        this.$message.warning('您暂未加入任何工会')
        return
      }
      if (this.realGuildIds.length === 1) {
        this.$router.push(`/gameclub-portal/myguild?guildId=${this.realGuildIds[0]}`)
      } else {
        this.$router.push('/gameclub-portal/myguild/select')
      }
    },
    submitCreateGuild() {
      this.$refs.createFormRef.validate(valid => {
        if (!valid) return
        createGuildApply(this.createForm).then(() => {
          this.$message.success('创建申请已提交，请等待管理员审核')
          this.showCreateGuild = false
          this.createForm = { gamePartitionId: null, guildName: '', description: '', recruitRequirement: '' }
        }).catch(() => {})
      })
    }
  }
}
</script>

<style scoped>
.portal-home {
  min-height: 100vh;
  background: #0a0a0f;
  color: #fff;
  overflow-x: hidden;
  scroll-behavior: smooth;
}

/* 全屏section样式 */
.portal-home > section {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 80px 30px 40px;
  box-sizing: border-box;
}

.portal-home > section:first-of-type {
  padding: 0;
}

.portal-home > .hero-section {
  justify-content: center;
  padding-top: 70px;
}

/* 导航栏 */
.nav-header {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 1000;
  background: rgba(10, 10, 15, 0.95);
  backdrop-filter: blur(20px);
  border-bottom: 1px solid rgba(255, 255, 255, 0.05);
  transition: all 0.3s;
}

.nav-container {
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 30px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 70px;
}

.nav-logo {
  display: flex;
  align-items: center;
  gap: 12px;
  cursor: pointer;
}

.logo-icon {
  font-size: 32px;
}

.logo-text {
  font-size: 24px;
  font-weight: bold;
  background: linear-gradient(135deg, #00d4ff, #00ff88);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.nav-menu {
  display: flex;
  gap: 40px;
}

.nav-item {
  color: rgba(255, 255, 255, 0.8);
  text-decoration: none;
  font-size: 15px;
  transition: all 0.3s;
  position: relative;
}

.nav-item:hover,
.nav-item.active {
  color: #00ff88;
}

.nav-item.active::after {
  content: '';
  position: absolute;
  bottom: -8px;
  left: 0;
  width: 100%;
  height: 2px;
  background: linear-gradient(90deg, #00d4ff, #00ff88);
}

/* 用户信息 */
.nav-user {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 8px 15px;
  background: rgba(0, 255, 136, 0.1);
  border: 1px solid rgba(0, 255, 136, 0.2);
  border-radius: 30px;
  transition: all 0.3s;
}

.nav-user:hover {
  background: rgba(0, 255, 136, 0.15);
  border-color: rgba(0, 255, 136, 0.4);
}

.user-actions {
  margin-left: 10px;
}

.logout-btn {
  background: rgba(255, 87, 87, 0.15);
  border: 1px solid rgba(255, 87, 87, 0.3);
  color: #ff5757;
  padding: 6px 12px;
  border-radius: 15px;
  font-size: 12px;
  cursor: pointer;
  transition: all 0.3s;
}

.logout-btn:hover {
  background: rgba(255, 87, 87, 0.25);
  border-color: rgba(255, 87, 87, 0.5);
}

.myguild-btn {
  background: rgba(0, 255, 136, 0.15);
  border: 1px solid rgba(0, 255, 136, 0.3);
  color: #00ff88;
  padding: 6px 12px;
  border-radius: 15px;
  font-size: 12px;
  cursor: pointer;
  transition: all 0.3s;
  margin-right: 8px;
}
.myguild-btn:hover {
  background: rgba(0, 255, 136, 0.25);
  border-color: rgba(0, 255, 136, 0.5);
}

.create-btn {
  background: rgba(0, 212, 255, 0.15);
  border: 1px solid rgba(0, 212, 255, 0.3);
  color: #00d4ff;
  padding: 6px 12px;
  border-radius: 15px;
  font-size: 12px;
  cursor: pointer;
  transition: all 0.3s;
  margin-right: 8px;
}
.create-btn:hover {
  background: rgba(0, 212, 255, 0.25);
  border-color: rgba(0, 212, 255, 0.5);
}

.stat-label-text { font-size: 13px; font-weight: 600; display: block; }
.stat-label-text.recruit { font-size: 11px; color: #00ff88; }

.user-avatar {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  background: linear-gradient(135deg, rgba(0, 212, 255, 0.3), rgba(0, 255, 136, 0.3));
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 18px;
}

.user-info {
  display: flex;
  flex-direction: column;
}

.user-name {
  font-size: 14px;
  font-weight: bold;
}

.user-role {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.6);
}

/* 未登录状态 */
.nav-login {
  padding: 8px 20px;
}

.login-link {
  color: #00ff88;
  text-decoration: none;
  font-size: 14px;
  font-weight: bold;
  border: 1px solid rgba(0, 255, 136, 0.3);
  padding: 10px 20px;
  border-radius: 25px;
  transition: all 0.3s;
}

.login-link:hover {
  background: rgba(0, 255, 136, 0.1);
}

/* Hero区域 */
.hero-section {
  min-height: 100vh;
  position: relative;
  display: flex;
  align-items: center;
  padding-top: 70px;
}

.hero-bg {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  overflow: hidden;
}

.bg-gradient {
  position: absolute;
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, #0a0a0f 0%, #1a1a2e 50%, #0f0f23 100%);
}

.bg-pattern {
  position: absolute;
  width: 100%;
  height: 100%;
  background-image: 
    radial-gradient(circle at 20% 30%, rgba(0, 212, 255, 0.1) 0%, transparent 50%),
    radial-gradient(circle at 80% 70%, rgba(0, 255, 136, 0.08) 0%, transparent 50%),
    radial-gradient(circle at 50% 50%, rgba(79, 172, 254, 0.05) 0%, transparent 70%);
}

.bg-overlay {
  position: absolute;
  width: 100%;
  height: 100%;
  background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.02'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
}

.hero-container {
  position: relative;
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 30px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  width: 100%;
}

.hero-content {
  flex: 1;
  max-width: 600px;
}

.hero-tag {
  display: inline-block;
  background: rgba(0, 212, 255, 0.15);
  border: 1px solid rgba(0, 212, 255, 0.3);
  color: #00d4ff;
  padding: 8px 20px;
  border-radius: 20px;
  font-size: 14px;
  margin-bottom: 25px;
}

.hero-title {
  font-size: 64px;
  font-weight: bold;
  line-height: 1.1;
  margin-bottom: 20px;
}

.title-main {
  display: block;
  background: linear-gradient(135deg, #fff, rgba(255, 255, 255, 0.7));
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.title-sub {
  display: block;
  background: linear-gradient(135deg, #00d4ff, #00ff88);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  margin-top: 10px;
}

.hero-desc {
  font-size: 18px;
  color: rgba(255, 255, 255, 0.7);
  margin-bottom: 35px;
  line-height: 1.6;
}

.hero-stats {
  display: flex;
  align-items: center;
  gap: 30px;
  margin-bottom: 40px;
}

.stat-item {
  text-align: center;
}

.stat-value {
  display: block;
  font-size: 36px;
  font-weight: bold;
  background: linear-gradient(135deg, #00d4ff, #00ff88);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.stat-label {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.6);
}

.stat-divider {
  width: 1px;
  height: 50px;
  background: rgba(255, 255, 255, 0.1);
}

.hero-action {
  display: flex;
  justify-content: flex-start;
}

.btn-primary {
  background: linear-gradient(135deg, #00d4ff, #00ff88);
  border: none;
  color: #0a0a0f;
  padding: 15px 40px;
  border-radius: 30px;
  font-size: 16px;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.3s;
  display: flex;
  align-items: center;
  gap: 10px;
}

.btn-primary:hover {
  transform: translateY(-3px);
  box-shadow: 0 10px 30px rgba(0, 255, 136, 0.3);
}

.btn-arrow {
  transition: transform 0.3s;
}

.btn-primary:hover .btn-arrow {
  transform: translateX(5px);
}

.hero-visual {
  flex: 1;
  position: relative;
  height: 400px;
}

.hero-card {
  position: absolute;
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 15px;
  padding: 25px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
  backdrop-filter: blur(10px);
  animation: float 6s ease-in-out infinite;
}

.card-emoji {
  font-size: 36px;
}

.card-text {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.8);
}

.card-1 {
  top: 20%;
  left: 10%;
  animation-delay: 0s;
}

.card-2 {
  top: 50%;
  right: 20%;
  animation-delay: 1.5s;
}

.card-3 {
  bottom: 20%;
  left: 30%;
  animation-delay: 3s;
}

.card-4 {
  top: 30%;
  right: 5%;
  animation-delay: 4.5s;
}

@keyframes float {
  0%, 100% { transform: translateY(0) rotate(0deg); }
  50% { transform: translateY(-15px) rotate(2deg); }
}

.hero-wave {
  position: absolute;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 100px;
  background: url("data:image/svg+xml,%3Csvg viewBox='0 0 1440 120' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M0,64L48,69.3C96,75,192,85,288,80C384,75,480,53,576,48C672,43,768,53,864,64C960,75,1056,85,1152,80C1248,75,1344,53,1392,42.7L1440,32L1440,120L1392,120C1344,120,1248,120,1152,120C1056,120,960,120,864,120C768,120,672,120,576,120C480,120,384,120,288,120C192,120,96,120,48,120L0,120Z' fill='%230a0a0f' fill-opacity='1'/%3E%3C/svg%3E");
  background-size: cover;
  background-position: bottom;
}

/* 通用区块样式 */
.section-container {
  max-width: 1400px;
  margin: 0 auto;
  width: 100%;
}

.section-header {
  text-align: center;
  margin-bottom: 60px;
}

.section-tag {
  display: inline-block;
  background: rgba(0, 255, 136, 0.1);
  border: 1px solid rgba(0, 255, 136, 0.2);
  color: #00ff88;
  padding: 6px 18px;
  border-radius: 15px;
  font-size: 12px;
  font-weight: bold;
  letter-spacing: 2px;
  margin-bottom: 15px;
}

.section-title {
  font-size: 36px;
  font-weight: bold;
  margin-bottom: 15px;
}

.section-desc {
  color: rgba(255, 255, 255, 0.6);
  font-size: 16px;
}

/* 游戏分区 */
.partitions-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 25px;
}

.partition-card {
  position: relative;
  border-radius: 20px;
  overflow: hidden;
  opacity: 0;
  animation: fadeInUp 0.6s ease-out forwards;
}

.card-bg {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, rgba(0, 212, 255, 0.1) 0%, rgba(0, 255, 136, 0.05) 100%);
  transition: all 0.3s;
}

.partition-card:hover .card-bg {
  background: linear-gradient(135deg, rgba(0, 212, 255, 0.2) 0%, rgba(0, 255, 136, 0.1) 100%);
}

.card-content {
  position: relative;
  padding: 35px;
  background: rgba(255, 255, 255, 0.03);
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 20px;
  transition: all 0.3s;
}

.partition-card:hover .card-content {
  border-color: rgba(0, 255, 136, 0.3);
  transform: translateY(-5px);
}

.card-border {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  border-radius: 20px;
  border: 1px solid transparent;
  background: linear-gradient(135deg, #00d4ff, #00ff88) border-box;
  -webkit-mask: linear-gradient(#fff 0 0) padding-box, linear-gradient(#fff 0 0);
  -webkit-mask-composite: xor;
  mask-composite: exclude;
  opacity: 0;
  transition: opacity 0.3s;
}

.partition-card:hover .card-border {
  opacity: 1;
}

.card-icon {
  font-size: 48px;
  margin-bottom: 20px;
}

.card-title {
  font-size: 22px;
  font-weight: bold;
  margin-bottom: 10px;
}

.card-desc {
  color: rgba(255, 255, 255, 0.6);
  font-size: 14px;
  margin-bottom: 20px;
}

.card-stats {
  display: flex;
  gap: 20px;
}

.card-stats .stat {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.7);
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* 热门工会 */
.guilds-section {
  background: rgba(0, 0, 0, 0.3);
}

.guilds-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 25px;
}

.guild-card {
  background: rgba(255, 255, 255, 0.03);
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 20px;
  padding: 30px;
  position: relative;
  transition: all 0.3s;
}

.guild-card:hover {
  border-color: rgba(0, 212, 255, 0.3);
  transform: translateY(-5px);
}

.guild-rank {
  position: absolute;
  top: -10px;
  right: 20px;
  width: 35px;
  height: 35px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  font-weight: bold;
}

.rank-1 {
  background: linear-gradient(135deg, #ffd93d, #ff6b6b);
  color: #0a0a0f;
}

.rank-2 {
  background: linear-gradient(135deg, #c0c0c0, #a0a0a0);
  color: #0a0a0f;
}

.rank-3 {
  background: linear-gradient(135deg, #cd7f32, #b87333);
  color: #0a0a0f;
}

.rank-4,
.rank-5,
.rank-6 {
  background: rgba(255, 255, 255, 0.1);
  color: rgba(255, 255, 255, 0.6);
}

.guild-header {
  display: flex;
  align-items: center;
  gap: 20px;
  margin-bottom: 20px;
}

.guild-avatar {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  background: linear-gradient(135deg, rgba(0, 212, 255, 0.2), rgba(0, 255, 136, 0.2));
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 28px;
}

.guild-info {
  flex: 1;
}

.guild-name {
  font-size: 18px;
  font-weight: bold;
  margin-bottom: 5px;
}

.guild-game {
  font-size: 13px;
  color: #00d4ff;
}

.guild-stats {
  display: flex;
  gap: 20px;
  margin-bottom: 20px;
}

.stat-box {
  flex: 1;
  text-align: center;
  padding: 10px;
  background: rgba(255, 255, 255, 0.03);
  border-radius: 10px;
}

.stat-num {
  display: block;
  font-size: 20px;
  font-weight: bold;
  color: #00ff88;
}

.stat-name {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.5);
}

.guild-desc {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.6);
  margin-bottom: 20px;
  line-height: 1.5;
}

.join-btn {
  width: 100%;
  background: rgba(0, 255, 136, 0.1);
  border: 1px solid rgba(0, 255, 136, 0.3);
  color: #00ff88;
  padding: 12px;
  border-radius: 10px;
  font-size: 14px;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.3s;
}

.join-btn:hover {
  background: rgba(0, 255, 136, 0.2);
  border-color: rgba(0, 255, 136, 0.5);
}

.join-btn.disabled {
  background: rgba(255, 255, 255, 0.05);
  border-color: rgba(255, 255, 255, 0.1);
  color: rgba(255, 255, 255, 0.4);
  cursor: not-allowed;
}

.empty-card {
  grid-column: 1 / -1;
  text-align: center;
  padding: 60px;
  background: rgba(255, 255, 255, 0.03);
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 20px;
}

.empty-icon {
  font-size: 48px;
  display: block;
  margin-bottom: 15px;
}

.empty-card p {
  color: rgba(255, 255, 255, 0.5);
}

/* 资讯动态 */
.news-container {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 30px;
  align-items: start;
}

.news-main {
  grid-column: 1;
}

.main-card {
  background: rgba(255, 255, 255, 0.03);
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 20px;
  overflow: hidden;
  display: flex;
}

.card-img {
  width: 40%;
  background: linear-gradient(135deg, rgba(0, 212, 255, 0.2), rgba(0, 255, 136, 0.1));
  display: flex;
  align-items: center;
  justify-content: center;
}

.img-icon {
  font-size: 64px;
}

.card-content {
  flex: 1;
  padding: 30px;
}

.news-tag {
  display: inline-block;
  background: rgba(0, 212, 255, 0.15);
  color: #00d4ff;
  padding: 5px 12px;
  border-radius: 10px;
  font-size: 12px;
  margin-bottom: 15px;
}

.news-title {
  font-size: 22px;
  font-weight: bold;
  margin-bottom: 10px;
}

.news-desc {
  color: rgba(255, 255, 255, 0.6);
  font-size: 14px;
  margin-bottom: 15px;
}

.news-time {
  font-size: 13px;
  color: rgba(255, 255, 255, 0.4);
}

.news-list {
  grid-column: 2;
}

.news-item {
  display: flex;
  align-items: center;
  gap: 15px;
  padding: 20px;
  background: rgba(255, 255, 255, 0.03);
  border-radius: 12px;
  margin-bottom: 15px;
  cursor: pointer;
  transition: all 0.3s;
}

.news-item:hover {
  background: rgba(255, 255, 255, 0.06);
  transform: translateX(5px);
}

.item-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: linear-gradient(135deg, #00d4ff, #00ff88);
  flex-shrink: 0;
}

.item-content {
  flex: 1;
}

.item-content h4 {
  margin: 0 0 8px 0;
  font-size: 15px;
  color: rgba(255, 255, 255, 0.9);
}

.item-time {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.4);
}

.empty-news {
  padding: 40px;
  text-align: center;
  color: rgba(255, 255, 255, 0.4);
}

/* 页脚 */
.footer {
  background: rgba(0, 0, 0, 0.5);
  padding: 60px 30px 30px;
}

.footer-container {
  max-width: 1400px;
  margin: 0 auto;
}

.footer-content {
  display: flex;
  justify-content: space-between;
  padding-bottom: 40px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.08);
}

.footer-brand {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.brand-icon {
  font-size: 48px;
}

.brand-name {
  font-size: 24px;
  font-weight: bold;
  background: linear-gradient(135deg, #00d4ff, #00ff88);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.brand-desc {
  color: rgba(255, 255, 255, 0.5);
  font-size: 14px;
}

.footer-links {
  display: flex;
  gap: 60px;
}

.link-group {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.link-group h4 {
  margin: 0 0 10px 0;
  font-size: 15px;
  font-weight: bold;
}

.link-group a {
  color: rgba(255, 255, 255, 0.5);
  text-decoration: none;
  font-size: 14px;
  transition: color 0.3s;
}

.link-group a:hover {
  color: #00ff88;
}

.footer-bottom {
  padding-top: 30px;
  text-align: center;
}

.footer-bottom p {
  color: rgba(255, 255, 255, 0.4);
  font-size: 13px;
}

/* 移动端菜单按钮 */
.mobile-menu-btn {
  display: none;
  background: none;
  border: none;
  color: #fff;
  font-size: 24px;
  cursor: pointer;
  padding: 5px 10px;
}

.mobile-menu-btn:hover {
  color: #00ff88;
}

/* 响应式 */
@media (max-width: 1024px) {
  .hero-container {
    flex-direction: column;
    text-align: center;
    gap: 60px;
  }
  
  .hero-title {
    font-size: 48px;
  }
  
  .hero-stats {
    justify-content: center;
  }
  
  .partitions-grid {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .guilds-grid {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .news-container {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 768px) {
  .nav-menu {
    display: none;
  }
  
  .mobile-menu-btn {
    display: block;
  }
  
  .nav-user {
    flex-wrap: wrap;
    gap: 8px;
    padding: 8px 12px;
  }
  
  .user-info {
    display: none;
  }
  
  .user-actions {
    margin-left: 0;
  }
  
  .hero-title {
    font-size: 36px;
  }
  
  .section-title {
    font-size: 28px;
  }
  
  .hero-card {
    padding: 15px;
    transform: scale(0.9);
  }
  
  .card-emoji {
    font-size: 28px;
  }
  
  .hero-visual {
    height: 300px;
  }
  
  .footer-content {
    flex-direction: column;
    gap: 40px;
    align-items: center;
    text-align: center;
  }
  
  .footer-links {
    gap: 40px;
    justify-content: center;
  }
  
  .footer-brand {
    align-items: center;
  }
  
  .partitions-grid {
    grid-template-columns: 1fr;
  }
  
  .guilds-grid {
    grid-template-columns: 1fr;
  }
  
  .news-container {
    grid-template-columns: 1fr;
  }
  
  .main-card {
    flex-direction: column;
  }
  
  .card-img {
    width: 100%;
    height: 150px;
  }
}
</style>
