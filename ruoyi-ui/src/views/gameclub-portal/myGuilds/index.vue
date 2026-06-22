<template>
  <div class="my-guilds-page">
    <nav class="top-nav">
      <div class="nav-left" @click="$router.push('/gameclub-portal')">
        <span class="logo">🎮</span>
        <span class="title">GameClub</span>
      </div>
    </nav>
    <div class="container">
      <h1 class="page-title">我的工会</h1>
      <p class="page-subtitle">选择一个工会进入</p>

      <div class="guild-grid" v-if="guilds.length > 0">
        <div class="guild-card" v-for="(g, index) in guilds" :key="g.guildId"
          @click="enterGuild(g)"
          :style="{ animationDelay: index * 0.1 + 's' }">
          <div class="card-icon">{{ getIcon(g.guildName) }}</div>
          <div class="card-info">
            <h3>{{ g.guildName }}</h3>
            <el-tag size="small" :type="roleTag(g.role)">{{ roleText(g.role) }}</el-tag>
          </div>
          <div class="card-arrow">→</div>
        </div>
      </div>

      <div class="empty" v-else-if="!loading">
        <span class="empty-icon">🏰</span>
        <p>您暂未加入任何工会</p>
        <el-button type="primary" @click="$router.push('/gameclub-portal')">去探索</el-button>
      </div>
    </div>
  </div>
</template>

<script>
import { getMyGuilds } from '@/api/gameclub/member'

export default {
  name: "MyGuilds",
  data() {
    return { guilds: [], loading: true }
  },
  created() {
    getMyGuilds().then(res => {
      this.guilds = res.data || []
    }).finally(() => { this.loading = false })
  },
  methods: {
    enterGuild(g) {
      this.$router.push(`/gameclub-portal/myguild?guildId=${g.guildId}`)
    },
    roleTag(role) {
      return { 1: 'danger', 2: 'warning', 3: '' }[role] || ''
    },
    roleText(role) {
      return { 1: '会长', 2: '管理员', 3: '普通成员' }[role] || '成员'
    },
    getIcon(name) {
      const icons = ['🏰', '⚔️', '🛡️', '⭐', '🔥', '💎']
      let hash = 0; for (let i = 0; i < (name||'').length; i++) hash = name.charCodeAt(i) + ((hash << 5) - hash)
      return icons[Math.abs(hash) % icons.length]
    }
  }
}
</script>

<style scoped>
.my-guilds-page { min-height: 100vh; background: #0a0a0f; color: #fff; }
.top-nav { position: fixed; top: 0; left: 0; right: 0; height: 70px; background: rgba(10,10,15,0.95); backdrop-filter: blur(20px); border-bottom: 1px solid rgba(255,255,255,0.05); display: flex; align-items: center; padding: 0 30px; z-index: 100; }
.nav-left { display: flex; align-items: center; gap: 10px; cursor: pointer; }
.logo { font-size: 28px; }
.title { font-size: 22px; font-weight: bold; background: linear-gradient(135deg, #00d4ff, #00ff88); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
.container { padding: 110px 40px 40px; max-width: 800px; margin: 0 auto; }
.page-title { font-size: 32px; margin: 0 0 8px; }
.page-subtitle { color: rgba(255,255,255,0.4); margin: 0 0 32px; }
.guild-grid { display: flex; flex-direction: column; gap: 12px; }
.guild-card { display: flex; align-items: center; gap: 16px; padding: 20px 24px; background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.08); border-radius: 14px; cursor: pointer; transition: all 0.3s; animation: fadeInUp 0.5s both; }
.guild-card:hover { background: rgba(0,255,136,0.06); border-color: rgba(0,255,136,0.2); transform: translateY(-2px); }
.card-icon { font-size: 36px; }
.card-info { flex: 1; }
.card-info h3 { margin: 0 0 4px; font-size: 18px; }
.card-arrow { font-size: 22px; color: rgba(255,255,255,0.2); transition: 0.3s; }
.guild-card:hover .card-arrow { color: #00ff88; transform: translateX(4px); }
.empty { text-align: center; padding: 60px 0; color: rgba(255,255,255,0.3); }
.empty-icon { font-size: 64px; display: block; margin-bottom: 16px; }
@keyframes fadeInUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
</style>
