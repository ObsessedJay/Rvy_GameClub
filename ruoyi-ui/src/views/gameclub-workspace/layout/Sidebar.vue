<template>
  <aside class="workspace-sidebar">
    <div class="sidebar-header">
      <span class="logo-icon">🎮</span>
      <span class="logo-text">工作台</span>
    </div>
    <el-menu
      :default-active="activeMenu"
      router
      background-color="#304156"
      text-color="#bfcbd9"
      active-text-color="#409EFF"
    >
      <el-menu-item index="/gameclub-workspace">
        <i class="el-icon-s-home"></i>
        <span slot="title">工作台首页</span>
      </el-menu-item>
      <el-menu-item index="/gameclub-workspace/guilds">
        <i class="el-icon-s-flag"></i>
        <span slot="title">我的工会</span>
      </el-menu-item>
      <el-menu-item index="/gameclub-workspace/applications">
        <i class="el-icon-document"></i>
        <span slot="title">申请管理</span>
      </el-menu-item>
      <el-menu-item index="/gameclub-workspace/blacklist">
        <i class="el-icon-circle-close"></i>
        <span slot="title">黑名单管理</span>
      </el-menu-item>
    </el-menu>
  </aside>
</template>

<script>
export default {
  name: "WorkspaceSidebar",
  computed: {
    activeMenu() {
      return this.$route.path
    }
  }
}
</script>

<style scoped>
.workspace-sidebar {
  width: 200px;
  background: #304156;
  min-height: 100vh;
}
.sidebar-header {
  height: 60px;
  display: flex;
  align-items: center;
  padding: 0 20px;
  color: white;
  font-size: 18px;
  font-weight: bold;
  border-bottom: 1px solid #3d4a5a;
}
.logo-icon {
  margin-right: 10px;
  font-size: 24px;
}
.logo-text {
  flex: 1;
}
</style>
