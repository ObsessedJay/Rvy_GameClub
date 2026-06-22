<template>
  <div class="announcement-management">
    <div class="toolbar">
      <el-button type="primary" @click="showAddDialog = true">发布公告</el-button>
    </div>

    <el-table :data="announcements" v-loading="loading">
      <el-table-column prop="title" label="标题" />
      <el-table-column prop="content" label="内容" :show-overflow-tooltip="true" />
      <el-table-column prop="publishedAt" label="发布时间" width="180">
        <template slot-scope="scope">
          {{ parseTime(scope.row.publishedAt) }}
        </template>
      </el-table-column>
      <el-table-column label="操作" width="150">
        <template slot-scope="scope">
          <el-button type="text" size="small" @click="handleEdit(scope.row)">编辑</el-button>
          <el-button type="text" size="small" @click="handleDelete(scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog :title="isEdit ? '编辑公告' : '发布公告'" :visible.sync="showAddDialog" width="600px">
      <el-form :model="form" :rules="rules" ref="formRef" label-width="80px">
        <el-form-item label="标题" prop="title">
          <el-input v-model="form.title" placeholder="请输入公告标题" />
        </el-form-item>
        <el-form-item label="内容" prop="content">
          <el-input v-model="form.content" type="textarea" :rows="4" placeholder="请输入公告内容" />
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="showAddDialog = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit">确定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listAnnouncement, addAnnouncement, updateAnnouncement, delAnnouncement } from '@/api/gameclub/announcement'

export default {
  name: "AnnouncementManagement",
  props: {
    guildId: {
      type: Number,
      required: true
    }
  },
  data() {
    return {
      announcements: [],
      loading: false,
      showAddDialog: false,
      isEdit: false,
      form: {
        id: null,
        title: '',
        content: ''
      },
      rules: {
        title: [{ required: true, message: '请输入标题', trigger: 'blur' }],
        content: [{ required: true, message: '请输入内容', trigger: 'blur' }]
      }
    }
  },
  created() {
    this.loadData()
  },
  methods: {
    loadData() {
      this.loading = true
      listAnnouncement({ guildId: this.guildId }).then(res => {
        this.announcements = res.rows || []
      }).finally(() => {
        this.loading = false
      })
    },
    handleEdit(row) {
      this.isEdit = true
      this.form = {
        id: row.id,
        title: row.title,
        content: row.content
      }
      this.showAddDialog = true
    },
    handleSubmit() {
      this.$refs.formRef.validate(valid => {
        if (valid) {
          const action = this.isEdit ? updateAnnouncement : addAnnouncement
          const data = {
            ...this.form,
            guildId: this.guildId
          }
          if (this.isEdit) {
            data.id = this.form.id
          }
          action(data).then(() => {
            this.$message.success(this.isEdit ? '更新成功' : '发布成功')
            this.showAddDialog = false
            this.resetForm()
            this.loadData()
          }).catch(() => {
            this.$message.error('操作失败')
          })
        }
      })
    },
    handleDelete(row) {
      this.$confirm('确认删除该公告?').then(() => {
        delAnnouncement(row.id).then(() => {
          this.$message.success('删除成功')
          this.loadData()
        }).catch(() => {
          this.$message.error('删除失败')
        })
      })
    },
    resetForm() {
      this.form = { id: null, title: '', content: '' }
      this.isEdit = false
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
