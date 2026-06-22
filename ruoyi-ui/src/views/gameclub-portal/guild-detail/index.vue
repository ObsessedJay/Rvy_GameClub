<template>
  <div class="guild-detail">
    <div class="guild-header" v-if="guild.id">
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

    <div class="guild-content" v-if="guild.id">
      <el-row :gutter="20">
        <el-col :xs="24" :md="16">
          <!-- 基本信息 -->
          <el-card class="info-card">
            <h2 slot="header">工会信息</h2>
            <el-descriptions :column="2" border>
              <el-descriptions-item label="会长">{{ guild.presidentName || '未知' }}</el-descriptions-item>
              <el-descriptions-item label="成员数">{{ guild.memberCount || 0 }}</el-descriptions-item>
              <el-descriptions-item label="创建时间">{{ guild.createdAt || '未知' }}</el-descriptions-item>
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
              <el-timeline-item v-for="item in announcements" :key="item.id" :timestamp="parseTime(item.publishedAt)">
                <h4>{{ item.title }}</h4>
                <p>{{ item.content || '' }}</p>
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
                <span class="member-name">{{ member.nickName || member.userName || '未知' }}</span>
                <el-tag v-if="member.role === 1" type="danger" size="small">会长</el-tag>
                <el-tag v-else-if="member.role === 2" type="warning" size="small">管理员</el-tag>
                <el-tag v-else type="info" size="small">成员</el-tag>
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
import { listGuildMember } from '@/api/gameclub/member'
import { addApplication } from '@/api/gameclub/application'
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
      return !!getToken() && !this.hasApplied && !this.isMember
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
        this.guild = res.data || {}
      }).catch(() => {
        this.guild = {}
      })
      listAnnouncement({ guildId, status: 1 }).then(res => {
        this.announcements = res.rows || []
      })
      listGuildMember({ guildId }).then(res => {
        this.members = res.rows || []
      })
    },
    handleApply() {
      this.applyDialogVisible = true
    },
    submitApply() {
      addApplication({
        guildId: this.$route.params.id,
        gamePartitionId: this.guild.gamePartitionId,
        message: this.applyForm.reason
      }).then(() => {
        this.$message.success('申请已提交，请等待审批')
        this.applyDialogVisible = false
        this.applyForm.reason = ''
      }).catch(() => {
        this.$message.error('提交失败，请重试')
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
.guild-detail {
  max-width: 1200px;
  margin: 0 auto;
  color: #fff;
}
.guild-header {
  background: #000;
  border: 1px solid rgba(0, 212, 255, 0.2);
  color: #fff;
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
.guild-avatar {
  font-size: 80px;
  margin-right: 20px;
}
.guild-info h1 {
  font-size: 32px;
  margin-bottom: 8px;
  color: #fff;
}
.partition-name {
  color: rgba(255, 255, 255, 0.6);
}
.info-card {
  margin-bottom: 20px;
  background: #000 !important;
  border-color: rgba(0, 212, 255, 0.15) !important;
}
.info-card h2 {
  margin: 0;
  font-size: 18px;
  color: #fff;
}
.empty-text {
  text-align: center;
  color: rgba(255, 255, 255, 0.4);
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
  border-bottom: 1px solid rgba(0, 212, 255, 0.1);
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
  color: #fff;
}
.guild-detail >>> .el-card {
  background: #000 !important;
  border-color: rgba(0, 212, 255, 0.15) !important;
}
.guild-detail >>> .el-card__body {
  color: #fff !important;
  background: #000 !important;
}
.guild-detail >>> .el-card__header {
  background: #000 !important;
  border-bottom-color: rgba(0, 212, 255, 0.15) !important;
}

/* 工会信息表格用荧光蓝字体 */
.guild-detail >>> .el-descriptions__header {
  background: #0a0a0f !important;
}
.guild-detail >>> .el-descriptions-item__label.is-bordered-label {
  background: #111 !important;
  color: #00d4ff !important;
}
.guild-detail >>> .el-descriptions-item__content {
  color: #00d4ff !important;
  background: #000 !important;
}
.guild-detail >>> .el-descriptions-item {
  background: #000 !important;
}
.guild-detail >>> .el-descriptions__body .el-descriptions__table {
  background: #000 !important;
}
.guild-detail >>> .el-descriptions__body .el-descriptions__table td,
.guild-detail >>> .el-descriptions__body .el-descriptions__table th {
  background: #000 !important;
  border-color: rgba(0, 212, 255, 0.12) !important;
}

.guild-detail >>> .el-timeline-item__wrapper {
  color: rgba(255, 255, 255, 0.8);
}
.guild-detail >>> .el-timeline-item__timestamp {
  color: rgba(255, 255, 255, 0.5);
}
.guild-detail >>> .el-timeline-item__tail {
  border-color: rgba(0, 212, 255, 0.2);
}
.guild-detail >>> .el-dialog {
  background: #000;
}
</style>
