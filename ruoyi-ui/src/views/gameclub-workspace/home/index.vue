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
              <span class="guild-members">{{ guild.memberCount || 0 }} 成员</span>
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
            <el-table-column prop="createdAt" label="申请时间" width="110">
              <template slot-scope="scope">
                {{ parseTime(scope.row.createdAt) }}
              </template>
            </el-table-column>
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
import { getMyGuilds } from '@/api/gameclub/guild'
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
      getMyGuilds().then(res => {
        this.myGuilds = res.rows || []
        this.totalMembers = res.rows.reduce((sum, g) => sum + (g.memberCount || 0), 0)
      })
      listApplication({ status: 0 }).then(res => {
        this.pendingApplications = res.total || 0
        this.recentApplications = (res.rows || []).slice(0, 5)
      })
    },
    goToGuild(id) {
      this.$router.push(`/gameclub-workspace/guild/${id}`)
    },
    handleApprove(row, status) {
      this.$confirm(`确认${status === 1 ? '通过' : '拒绝'}该申请?`).then(() => {
        approveApplication(row.id, status, '').then(() => {
          this.$message.success('操作成功')
          this.loadData()
        }).catch(() => {
          this.$message.error('操作失败')
        })
      })
    },
    parseTime(time) {
      if (!time) return ''
      const date = new Date(time)
      return date.toLocaleDateString()
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
