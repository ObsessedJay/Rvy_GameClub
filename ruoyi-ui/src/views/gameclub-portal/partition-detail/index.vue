<template>
  <div class="partition-detail">
    <div class="partition-header" v-if="partition.id">
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
              <p class="president">会长: {{ guild.presidentName || '未知' }}</p>
              <div class="guild-footer">
                <span>👥 {{ guild.memberCount || 0 }} 成员</span>
                <el-tag v-if="guild.status === 1" type="success" size="small">招募中</el-tag>
                <el-tag v-else type="info" size="small">暂停</el-tag>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>

      <div v-if="filteredGuilds.length === 0" class="empty-box">
        <p>该分区暂无工会</p>
      </div>

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
import { getGamePartition } from '@/api/gameclub/partition'
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
      return this.guilds.filter(g => g.name && g.name.includes(this.searchKeyword))
    }
  },
  created() {
    this.loadPartition()
    this.loadGuilds()
  },
  methods: {
    loadPartition() {
      getGamePartition(this.$route.params.id).then(res => {
        this.partition = res.data || {}
      }).catch(() => {
        this.partition = {}
      })
    },
    loadGuilds() {
      listGuild({
        gamePartitionId: this.$route.params.id
      }).then(res => {
        this.guilds = res.data || res.rows || []
        this.total = this.guilds.length
      }).catch(() => {
        this.guilds = []
        this.total = 0
      })
    },
    goToGuild(id) {
      this.$router.push(`/gameclub-portal/guild/${id}`)
    }
  }
}
</script>

<style>
/* Element UI 深色主题覆盖 */
.partition-detail .el-input__inner {
  background: rgba(255, 255, 255, 0.05) !important;
  border-color: rgba(255, 255, 255, 0.15) !important;
  color: #fff !important;
}
.partition-detail .el-input__inner::placeholder {
  color: rgba(255, 255, 255, 0.4) !important;
}
.partition-detail .el-input__inner:focus {
  border-color: #00d4ff !important;
}
.partition-detail .el-input__prefix {
  color: rgba(255, 255, 255, 0.5);
}
</style>

<style scoped>
.partition-detail {
  max-width: 1200px;
  margin: 0 auto;
  color: #fff;
}
.partition-header {
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.08);
  color: white;
  padding: 40px;
  border-radius: 16px;
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
  color: #00ff88;
}
.stat-label {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.7);
}
.guild-list-section {
  background: rgba(255, 255, 255, 0.03);
  border: 1px solid rgba(255, 255, 255, 0.08);
  padding: 30px;
  border-radius: 16px;
}
.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}
.section-header h2 {
  margin: 0;
  color: #fff;
}
.guild-card {
  margin-bottom: 20px;
  cursor: pointer;
  transition: all 0.3s;
  background: rgba(255, 255, 255, 0.05) !important;
  border-color: rgba(255, 255, 255, 0.08) !important;
  color: #fff;
}
.guild-card:hover {
  transform: translateY(-3px);
  border-color: rgba(0, 212, 255, 0.3) !important;
}
.guild-info h3 {
  margin-bottom: 10px;
  color: #fff;
}
.president {
  color: rgba(255, 255, 255, 0.6);
  font-size: 14px;
  margin-bottom: 10px;
}
.guild-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  color: rgba(255, 255, 255, 0.6);
}
.empty-box {
  text-align: center;
  padding: 40px 0;
  color: rgba(255, 255, 255, 0.4);
}
</style>
