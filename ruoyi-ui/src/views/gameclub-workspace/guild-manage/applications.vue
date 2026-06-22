<template>
  <div class="application-management">
    <div class="toolbar">
      <el-select v-model="status" placeholder="筛选状态" style="width: 120px;" clearable @change="loadData">
        <el-option label="全部" value="" />
        <el-option label="待审批" value="0" />
        <el-option label="已通过" value="1" />
        <el-option label="已拒绝" value="2" />
      </el-select>
    </div>

    <el-table :data="applications" v-loading="loading">
      <el-table-column prop="applicantName" label="申请人" />
      <el-table-column prop="reason" label="申请理由" :show-overflow-tooltip="true" />
      <el-table-column prop="createdAt" label="申请时间" width="180">
        <template slot-scope="scope">
          {{ parseTime(scope.row.createdAt) }}
        </template>
      </el-table-column>
      <el-table-column prop="status" label="状态" width="100">
        <template slot-scope="scope">
          <el-tag :type="getStatusTag(scope.row.status)">
            {{ getStatusText(scope.row.status) }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="150" v-if="status !== '1' && status !== '2'">
        <template slot-scope="scope" v-if="scope.row.status === 0">
          <el-button type="text" size="small" @click="handleApprove(scope.row, 1)">通过</el-button>
          <el-button type="text" size="small" @click="handleApprove(scope.row, 2)">拒绝</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-pagination
      v-if="total > 0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="loadData"
      layout="prev, pager, next"
      style="margin-top: 15px; text-align: center;"
    />
  </div>
</template>

<script>
import { listApplication, approveApplication } from '@/api/gameclub/application'

export default {
  name: "ApplicationManagement",
  props: {
    guildId: {
      type: Number,
      required: true
    }
  },
  data() {
    return {
      applications: [],
      loading: false,
      total: 0,
      status: '',
      queryParams: {
        pageNum: 1,
        pageSize: 10
      }
    }
  },
  created() {
    this.loadData()
  },
  methods: {
    loadData() {
      this.loading = true
      const params = {
        ...this.queryParams,
        guildId: this.guildId
      }
      if (this.status !== '') {
        params.status = parseInt(this.status)
      }
      listApplication(params).then(res => {
        this.applications = res.rows || []
        this.total = res.total || 0
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
.toolbar {
  margin-bottom: 15px;
}
</style>
