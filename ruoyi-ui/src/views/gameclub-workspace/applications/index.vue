<template>
  <div class="applications-page">
    <div class="page-header">
      <h2>申请管理</h2>
    </div>

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
      <el-table-column prop="createdAt" label="申请时间" width="180">
        <template slot-scope="scope">
          {{ parseTime(scope.row.createdAt) }}
        </template>
      </el-table-column>
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
  name: "WorkspaceApplications",
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
      const params = {}
      if (this.status !== 'all') {
        params.status = parseInt(this.status)
      }
      listApplication(params).then(res => {
        this.applications = res.rows || []
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
.page-header {
  margin-bottom: 20px;
}
.page-header h2 {
  margin: 0;
}
</style>
