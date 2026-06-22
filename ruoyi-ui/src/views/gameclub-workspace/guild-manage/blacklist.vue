<template>
  <div class="blacklist-management">
    <div class="toolbar">
      <el-button type="primary" @click="showAddDialog = true">添加黑名单</el-button>
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

    <el-dialog title="添加黑名单" :visible.sync="showAddDialog" width="500px">
      <el-form :model="addForm" label-width="80px">
        <el-form-item label="用户ID">
          <el-input v-model="addForm.userId" placeholder="请输入用户ID" />
        </el-form-item>
        <el-form-item label="原因">
          <el-input v-model="addForm.reason" type="textarea" :rows="3" placeholder="请输入原因" />
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="showAddDialog = false">取消</el-button>
        <el-button type="primary" @click="handleAdd">确定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listBlacklist, addBlacklist, removeBlacklist } from '@/api/gameclub/blacklist'

export default {
  name: "BlacklistManagement",
  props: {
    guildId: {
      type: Number,
      required: true
    }
  },
  data() {
    return {
      blacklist: [],
      loading: false,
      showAddDialog: false,
      addForm: {
        userId: null,
        reason: ''
      }
    }
  },
  created() {
    this.loadData()
  },
  methods: {
    loadData() {
      this.loading = true
      listBlacklist({ guildId: this.guildId }).then(res => {
        this.blacklist = res.rows || []
      }).finally(() => {
        this.loading = false
      })
    },
    handleAdd() {
      if (!this.addForm.userId) {
        this.$message.warning('请输入用户ID')
        return
      }
      addBlacklist({
        guildId: this.guildId,
        userId: this.addForm.userId,
        reason: this.addForm.reason
      }).then(() => {
        this.$message.success('添加成功')
        this.showAddDialog = false
        this.addForm = { userId: null, reason: '' }
        this.loadData()
      }).catch(() => {
        this.$message.error('添加失败')
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
.toolbar {
  margin-bottom: 15px;
}
</style>
