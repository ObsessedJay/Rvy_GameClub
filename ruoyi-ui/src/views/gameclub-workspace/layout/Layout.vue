<template>
  <div class="workspace-layout">
    <Sidebar />
    <main class="workspace-main">
      <router-view />
    </main>
  </div>
</template>

<script>
import Sidebar from './Sidebar.vue'

export default {
  name: "WorkspaceLayout",
  components: { Sidebar }
}
</script>

<style scoped>
.workspace-layout {
  display: flex;
  min-height: 100vh;
}
.workspace-main {
  flex: 1;
  padding: 20px;
  background: #f5f5f5;
}
</style>
