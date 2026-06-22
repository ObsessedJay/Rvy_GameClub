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
            <p><span class="label">分区:</span> {{ guild.partitionName || '未知' }}</p>
            <p><span class="label">成员:</span> {{ guild.memberCount || 0 }}</p>
            <p><span class="label">状态:</span>
              <el-tag :type="guild.status === 1 ? 'success' : 'info'" size="small">
                {{ guild.status === 1 ? '招募中' : '暂停' }}
              </el-tag>
            </p>
          </div>
          <div class="guild-actions">
            <el-button type="primary" size="small" @click="manageGuild(guild.id)">管理</el-button>
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
import { getMyGuilds } from '@/api/gameclub/guild'

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
      getMyGuilds().then(res => {
        this.guilds = res.rows || []
      })
    },
    manageGuild(id) {
      this.$router.push(`/gameclub-workspace/guild/${id}`)
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
