<template>
  <header class="portal-header">
    <div class="header-container">
      <div class="logo" @click="$router.push('/gameclub-portal')">
        <span class="logo-icon">🎮</span>
        <span class="logo-text">GameClub</span>
      </div>
      <nav class="nav-menu">
        <router-link to="/gameclub-portal" :class="{ active: $route.path === '/gameclub-portal' }">首页</router-link>
        <router-link to="/gameclub-portal/partitions" :class="{ active: $route.path.startsWith('/gameclub-portal/partitions') }">游戏分区</router-link>
      </nav>
      <div class="header-actions">
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
            <button class="logout-btn" @click="handleLogout">退出</button>
          </div>
        </div>
        <div class="nav-login" v-else>
          <a href="/login" class="login-link">前往登录</a>
        </div>
      </div>
    </div>
  </header>
</template>

<script>
import { getToken } from '@/utils/auth'
import { getMyGuilds } from '@/api/gameclub/member'

export default {
  name: "PortalHeader",
  data() {
    return {
      realUsername: '',
      realRole: null,
      realGuildIds: []
    }
  },
  computed: {
    hasToken() {
      return !!getToken()
    },
    username() {
      return this.realUsername || this.$store.state.user.name || this.$store.state.user.nickName || '用户'
    },
    roleName() {
      const roleMap = { 1: '会长', 2: '管理员', 3: '普通成员', 4: '无工会用户' }
      if (this.realRole != null) {
        return roleMap[this.realRole] || '无工会用户'
      }
      return this.$store.state.user.roleName || '普通会员'
    },
    guildCount() {
      return this.realGuildIds.length
    }
  },
  created() {
    this.fetchMyGuilds()
  },
  methods: {
    fetchMyGuilds() {
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
    handleLogout() {
      this.$store.dispatch('LogOut').then(() => {
        this.$router.push('/login')
      }).catch(() => {
        console.error('退出失败')
      })
    }
  }
}
</script>

<style scoped>
.portal-header {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 1000;
  background: rgba(10, 10, 15, 0.95);
  backdrop-filter: blur(20px);
  border-bottom: 1px solid rgba(255, 255, 255, 0.05);
}
.header-container {
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 30px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 70px;
}
.logo {
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
.nav-menu a {
  color: rgba(255, 255, 255, 0.8);
  text-decoration: none;
  font-size: 15px;
  transition: all 0.3s;
  position: relative;
}
.nav-menu a:hover,
.nav-menu a.active {
  color: #00ff88;
}
.nav-menu a.active::after {
  content: '';
  position: absolute;
  bottom: -8px;
  left: 0;
  width: 100%;
  height: 2px;
  background: linear-gradient(90deg, #00d4ff, #00ff88);
}
.header-actions {
  display: flex;
  align-items: center;
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
.user-actions {
  display: flex;
  gap: 8px;
  margin-left: 10px;
}
.workspace-btn {
  background: rgba(0, 212, 255, 0.15);
  border: 1px solid rgba(0, 212, 255, 0.3);
  color: #00d4ff;
  padding: 6px 12px;
  border-radius: 15px;
  font-size: 12px;
  cursor: pointer;
  transition: all 0.3s;
}
.workspace-btn:hover {
  background: rgba(0, 212, 255, 0.25);
  border-color: rgba(0, 212, 255, 0.5);
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
}
.myguild-btn:hover {
  background: rgba(0, 255, 136, 0.25);
  border-color: rgba(0, 255, 136, 0.5);
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

@media (max-width: 768px) {
  .nav-menu {
    display: none;
  }
  .user-info {
    display: none;
  }
  .user-actions {
    margin-left: 0;
  }
  .nav-user {
    flex-wrap: wrap;
    gap: 8px;
    padding: 8px 12px;
  }
}
</style>
