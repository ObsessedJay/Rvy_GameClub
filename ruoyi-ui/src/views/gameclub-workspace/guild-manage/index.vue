<template>
  <div class="guild-manage">
    <div class="page-header">
      <el-button icon="el-icon-back" @click="$router.push('/gameclub-workspace/guilds')">返回</el-button>
      <h2>{{ guild.name || '工会' }} - 管理</h2>
    </div>

    <el-tabs v-model="activeTab" type="border-card">
      <el-tab-pane label="概览" name="overview">
        <el-card v-if="guild.id">
          <el-descriptions :column="2" border>
            <el-descriptions-item label="工会名称">{{ guild.name }}</el-descriptions-item>
            <el-descriptions-item label="所属分区">{{ guild.partitionName || '未知' }}</el-descriptions-item>
            <el-descriptions-item label="会长">{{ guild.presidentName || '未知' }}</el-descriptions-item>
            <el-descriptions-item label="成员数">{{ guild.memberCount || 0 }}</el-descriptions-item>
            <el-descriptions-item label="创建时间">{{ guild.createdAt || '未知' }}</el-descriptions-item>
            <el-descriptions-item label="状态">
              <el-tag :type="guild.status === 1 ? 'success' : 'info'">
                {{ guild.status === 1 ? '招募中' : '暂停' }}
              </el-tag>
            </el-descriptions-item>
            <el-descriptions-item label="简介" :span="2">{{ guild.description || '暂无' }}</el-descriptions-item>
          </el-descriptions>
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
import { getGuild } from '@/api/gameclub/guild'
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
      activeTab: 'overview'
    }
  },
  created() {
    this.guildId = parseInt(this.$route.params.id)
    this.loadGuild()
  },
  methods: {
    loadGuild() {
      getGuild(this.guildId).then(res => {
        this.guild = res.data || {}
      }).catch(() => {
        this.guild = {}
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
