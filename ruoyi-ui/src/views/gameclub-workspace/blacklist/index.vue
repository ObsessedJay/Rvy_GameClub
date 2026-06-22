<template>
  <div class="blacklist-page">
    <div class="page-header">
      <h2>黑名单管理</h2>
    </div>

    <el-table :data="blacklist" v-loading="loading">
      <el-table-column prop="userName" label="用户名" />
      <el-table-column prop="reason" label="原因" :show-overflow-tooltip="true" />
      <el-table-column prop="createdAt" label="添加时间" width="180">
        <template slot-scope="scope">
          {{ parseTime(scope.row.createdAt) }}
        </template>
      </el-table-column>
      <el-table-column label="操作" width="150">
        <template slot-scope="scope">
          <el-button type="text" size="small" @click="handleRemove(scope.row)">移除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <div v-if="blacklist.length === 0 && !loading" class="empty-box">
      <p>暂无黑名单记录</p>
    </div>
  </div>
</template>

<script>
import { listBlacklist, removeBlacklist } from '@/api/gameclub/blacklist'

export default {
  name: "WorkspaceBlacklist",
  data() {
    return {
      blacklist: [],
      loading: false
    }
  },
  created() {
    this.loadData()
  },
  methods: {
    loadData() {
      this.loading = true
      listBlacklist({}).then(res => {
        this.blacklist = res.rows || []
      }).finally(() => {
        this.loading = false
      })
    },
    handleRemove(row) {
      this.$confirm('确认移除该用户出黑名单?').then(() => {
        removeBlacklist(row.id).then(() => {
          this.$message.success('移除成功')
          this.loadData()
        }).catch(() => {
          this.$message.error('移除失败')
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
.empty-box {
  text-align: center;
  padding: 60px 0;
  background: white;
  border-radius: 8px;
  color: #999;
}
</style>
