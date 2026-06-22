<template>
  <div class="apply-page">
    <el-card class="apply-card">
      <h1 slot="header">申请加入 {{ guildName }}</h1>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="申请理由" prop="reason">
          <el-input v-model="form.reason" type="textarea" :rows="6" placeholder="请简要说明您想加入工会的原因和您的游戏经历" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="submitForm" :loading="loading">提交申请</el-button>
          <el-button @click="goBack">返回</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script>
import { apply } from '@/api/gameclub/application'

export default {
  name: "ApplyPage",
  data() {
    return {
      form: {
        reason: ''
      },
      rules: {
        reason: [{ required: true, message: '请输入申请理由', trigger: 'blur' }]
      },
      loading: false
    }
  },
  computed: {
    guildName() {
      return this.$route.params.guildName || '工会'
    }
  },
  methods: {
    submitForm() {
      this.$refs.formRef.validate(valid => {
        if (valid) {
          this.loading = true
          apply({
            guildId: this.$route.params.guildId,
            reason: this.form.reason
          }).then(() => {
            this.$message.success('申请已提交，请等待审批')
            this.$router.push('/gameclub-portal')
          }).catch(() => {
            this.$message.error('提交失败，请重试')
          }).finally(() => {
            this.loading = false
          })
        }
      })
    },
    goBack() {
      this.$router.back()
    }
  }
}
</script>

<style scoped>
.apply-page {
  max-width: 600px;
  margin: 40px auto;
  color: #fff;
}
.apply-card {
  background: rgba(255, 255, 255, 0.03) !important;
  border-color: rgba(255, 255, 255, 0.08) !important;
  color: #fff;
}
.apply-card h1 {
  text-align: center;
  margin: 0;
  color: #fff;
}
</style>
