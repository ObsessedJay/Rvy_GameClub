<template>
  <div class="portal-layout">
    <Header />
    <main class="portal-main">
      <router-view />
    </main>
    <footer class="portal-footer">
      <div class="footer-container">
        <div class="footer-content">
          <div class="footer-brand">
            <span class="brand-icon">🎮</span>
            <span class="brand-name">GameClub</span>
            <p class="brand-desc">游戏工会平台</p>
          </div>
          <div class="footer-links">
            <div class="link-group">
              <h4>关于我们</h4>
              <a href="#">平台介绍</a>
              <a href="#">联系我们</a>
              <a href="#">加入我们</a>
            </div>
            <div class="link-group">
              <h4>帮助支持</h4>
              <a href="#">常见问题</a>
              <a href="#">用户协议</a>
              <a href="#">隐私政策</a>
            </div>
            <div class="link-group">
              <h4>关注我们</h4>
              <a href="#">官方微博</a>
              <a href="#">官方微信</a>
              <a href="#">抖音账号</a>
            </div>
          </div>
        </div>
        <div class="footer-bottom">
          <p>© 2024 GameClub. All rights reserved.</p>
        </div>
      </div>
    </footer>
  </div>
</template>

<script>
import Header from './Header.vue'

export default {
  name: "PortalLayout",
  components: { Header }
}
</script>

<style scoped>
.portal-layout {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background: #0a0a0f;
  color: #fff;
}
.portal-main {
  flex: 1;
  padding: 20px 30px;
  max-width: 1400px;
  margin: 0 auto;
  width: 100%;
  box-sizing: border-box;
  padding-top: 80px;
}
.portal-footer {
  background: rgba(0, 0, 0, 0.5);
  padding: 60px 30px 30px;
  margin-top: auto;
}
.footer-container {
  max-width: 1400px;
  margin: 0 auto;
}
.footer-content {
  display: flex;
  justify-content: space-between;
  padding-bottom: 40px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.08);
}
.footer-brand {
  display: flex;
  flex-direction: column;
  gap: 10px;
}
.brand-icon {
  font-size: 48px;
}
.brand-name {
  font-size: 24px;
  font-weight: bold;
  background: linear-gradient(135deg, #00d4ff, #00ff88);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}
.brand-desc {
  color: rgba(255, 255, 255, 0.5);
  font-size: 14px;
}
.footer-links {
  display: flex;
  gap: 60px;
}
.link-group {
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.link-group h4 {
  margin: 0 0 10px 0;
  font-size: 15px;
  font-weight: bold;
}
.link-group a {
  color: rgba(255, 255, 255, 0.5);
  text-decoration: none;
  font-size: 14px;
  transition: color 0.3s;
}
.link-group a:hover {
  color: #00ff88;
}
.footer-bottom {
  padding-top: 30px;
  text-align: center;
}
.footer-bottom p {
  color: rgba(255, 255, 255, 0.4);
  font-size: 13px;
  margin: 0;
}

@media (max-width: 768px) {
  .footer-content {
    flex-direction: column;
    gap: 40px;
    align-items: center;
    text-align: center;
  }
  .footer-links {
    gap: 40px;
    justify-content: center;
  }
  .footer-brand {
    align-items: center;
  }
}
</style>
