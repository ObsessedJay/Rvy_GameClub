<template>
  <div class="partitions-page">
    <div class="page-header">
      <h1 class="page-title">游戏分区</h1>
      <p class="page-subtitle">探索热门游戏分区，找到你的游戏家园</p>
    </div>
    
    <div class="partitions-grid">
      <div class="grid-container">
        <div 
          class="partition-card" 
          v-for="partition in partitionList" 
          :key="partition.id"
          @click="goToPartition(partition.id)"
        >
          <div class="partition-icon">{{ getGameIcon(partition.gameName) }}</div>
          <h3 class="partition-name">{{ partition.gameName }}</h3>
          <p class="game-code">{{ partition.gameCode }}</p>
          <div class="partition-stats">
            <span class="stat-item">
              <span class="stat-icon">🏰</span>
              <span>{{ partition.guildCount || 0 }} 工会</span>
            </span>
            <span class="stat-item">
              <span class="stat-icon">👥</span>
              <span>{{ partition.memberCount || 0 }} 成员</span>
            </span>
          </div>
          <div class="status-badge" :class="{ active: partition.status === 1 }">
            {{ partition.status === 1 ? '活跃' : '维护中' }}
          </div>
        </div>
      </div>
    </div>
    
    <div v-if="partitionList.length === 0" class="empty-box">
      <span class="empty-icon">🎮</span>
      <p>暂无游戏分区</p>
    </div>
  </div>
</template>

<script>
import { publicListGamePartition } from '@/api/gameclub/partition'

export default {
  name: "PortalPartitions",
  data() {
    return {
      partitionList: []
    }
  },
  created() {
    this.loadData()
  },
  methods: {
    loadData() {
      publicListGamePartition().then(res => {
        this.partitionList = res.data || res.rows || []
      }).catch(err => {
        console.error('加载分区失败:', err)
        this.partitionList = []
      })
    },
    goToPartition(id) {
      this.$router.push(`/gameclub-portal/partition/${id}`)
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
    getOnlineCount(partitionId) {
      return Math.floor(Math.random() * 500) + 100
    }
  }
}
</script>

<style scoped>
.partitions-page {
  padding: 80px 0 40px;
}
.page-header {
  text-align: center;
  margin-bottom: 50px;
}
.page-title {
  font-size: 42px;
  font-weight: bold;
  background: linear-gradient(135deg, #00d4ff, #00ff88);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  margin: 0 0 15px 0;
}
.page-subtitle {
  color: rgba(255, 255, 255, 0.6);
  font-size: 16px;
  margin: 0;
}
.partitions-grid {
  width: 100%;
}
.grid-container {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 25px;
}
.partition-card {
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 16px;
  padding: 30px;
  cursor: pointer;
  transition: all 0.3s ease;
  text-align: center;
  position: relative;
  overflow: hidden;
}
.partition-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 3px;
  background: linear-gradient(90deg, #00d4ff, #00ff88);
  transform: scaleX(0);
  transition: transform 0.3s ease;
}
.partition-card:hover {
  background: rgba(255, 255, 255, 0.08);
  border-color: rgba(0, 255, 136, 0.3);
  transform: translateY(-5px);
}
.partition-card:hover::before {
  transform: scaleX(1);
}
.partition-icon {
  font-size: 56px;
  margin-bottom: 20px;
}
.partition-name {
  font-size: 20px;
  font-weight: bold;
  margin: 0 0 8px 0;
}
.game-code {
  color: rgba(255, 255, 255, 0.5);
  font-size: 14px;
  margin: 0 0 20px 0;
}
.partition-stats {
  display: flex;
  justify-content: center;
  gap: 25px;
  padding-top: 15px;
  border-top: 1px solid rgba(255, 255, 255, 0.08);
}
.stat-item {
  display: flex;
  align-items: center;
  gap: 6px;
  color: rgba(255, 255, 255, 0.7);
  font-size: 14px;
}
.stat-icon {
  font-size: 16px;
}
.status-badge {
  position: absolute;
  top: 15px;
  right: 15px;
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 12px;
  background: rgba(255, 255, 255, 0.1);
  color: rgba(255, 255, 255, 0.6);
}
.status-badge.active {
  background: rgba(0, 255, 136, 0.15);
  color: #00ff88;
}
.empty-box {
  text-align: center;
  padding: 80px 0;
  background: rgba(255, 255, 255, 0.03);
  border-radius: 16px;
  border: 1px solid rgba(255, 255, 255, 0.05);
}
.empty-icon {
  font-size: 64px;
  display: block;
  margin-bottom: 20px;
}
.empty-box p {
  color: rgba(255, 255, 255, 0.5);
  margin: 0;
}

@media (max-width: 768px) {
  .page-title {
    font-size: 28px;
  }
  .grid-container {
    grid-template-columns: 1fr;
  }
  .partition-card {
    padding: 20px;
  }
}
</style>
