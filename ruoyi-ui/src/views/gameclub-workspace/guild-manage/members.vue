<template>
  <div class="member-management">
    <div class="toolbar">
      <el-button type="primary" @click="showAddDialog = true">添加成员</el-button>
    </div>

    <el-table :data="members" v-loading="loading">
      <el-table-column prop="userName" label="用户名" />
      <el-table-column prop="nickName" label="昵称" />
      <el-table-column label="角色" width="100">
        <template slot-scope="scope">
          <el-tag :type="getRoleTag(scope.row.role)" size="small">
            {{ getRoleText(scope.row.role) }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="joinTime" label="加入时间" width="180">
        <template slot-scope="scope">
          {{ parseTime(scope.row.joinTime) }}
        </template>
      </el-table-column>
      <el-table-column label="操作" width="200">
        <template slot-scope="scope" v-if="scope.row.role !== 1">
          <el-button v-if="scope.row.role === 3" type="text" size="small" @click="handlePromote(scope.row)">设为管理员</el-button>
          <el-button v-if="scope.row.role === 2" type="text" size="small" @click="handleDemote(scope.row)">取消管理员</el-button>
          <el-button type="text" size="small" style="color: #F56C6C" @click="handleRemove(scope.row)">移除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog title="添加成员" :visible.sync="showAddDialog" width="400px">
      <el-form :model="addForm" label-width="80px">
        <el-form-item label="用户ID">
          <el-input v-model="addForm.userId" placeholder="请输入用户ID" />
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
import { listGuildMember, addGuildMember, delGuildMember, changeMemberRole } from '@/api/gameclub/member'

export default {
  name: "MemberManagement",
  props: {
    guildId: {
      type: Number,
      required: true
    }
  },
  data() {
    return {
      members: [],
      loading: false,
      showAddDialog: false,
      addForm: {
        userId: null
      }
    }
  },
  created() {
    this.loadData()
  },
  methods: {
    loadData() {
      this.loading = true
      listGuildMember({ guildId: this.guildId }).then(res => {
        this.members = res.rows || []
      }).finally(() => {
        this.loading = false
      })
    },
    handleAdd() {
      if (!this.addForm.userId) {
        this.$message.warning('请输入用户ID')
        return
      }
      addGuildMember({
        guildId: this.guildId,
        userId: this.addForm.userId
      }).then(() => {
        this.$message.success('添加成功')
        this.showAddDialog = false
        this.addForm.userId = null
        this.loadData()
      }).catch(() => {
        this.$message.error('添加失败')
      })
    },
    getRoleTag(role) {
      const map = { 1: 'warning', 2: 'success', 3: 'info' }
      return map[role] || 'info'
    },
    getRoleText(role) {
      const map = { 1: '会长', 2: '管理员', 3: '普通成员' }
      return map[role] || '未知'
    },
    handlePromote(row) {
      this.$confirm(`确认将 ${row.nickName || row.userName} 设为管理员?`).then(() => {
        changeMemberRole(row.id, 2).then(() => {
          this.$message.success('已设为管理员')
          this.loadData()
        }).catch(() => {
          this.$message.error('操作失败')
        })
      }).catch(() => {})
    },
    handleDemote(row) {
      this.$confirm(`确认取消 ${row.nickName || row.userName} 的管理员资格?`).then(() => {
        changeMemberRole(row.id, 3).then(() => {
          this.$message.success('已取消管理员资格')
          this.loadData()
        }).catch(() => {
          this.$message.error('操作失败')
        })
      }).catch(() => {})
    },
    handleRemove(row) {
      this.$confirm('确认移除该成员?').then(() => {
        delGuildMember(row.id).then(() => {
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
