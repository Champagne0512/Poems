<template>
  <div id="app">
    <header class="app-header">
      <h1>诗词赏析</h1>
      <nav class="main-nav">
        <router-link to="/">首页</router-link>
        <router-link to="/poems">诗词浏览</router-link>
        <router-link to="/search">搜索</router-link>
        <router-link to="/profile">个人中心</router-link>
      </nav>
    </header>
    
    <main class="app-main">
      <router-view />
    </main>
    
    <footer class="app-footer">
      <p>&copy; 2024 诗词赏析网站</p>
    </footer>
  </div>
</template>

<script setup>
// 应用主组件
</script>

<style scoped>
.app-header {
  background: #f8f5f0;
  color: #5d4037;
  padding: 1rem 2rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-bottom: 2px solid #e8e4da;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.app-header h1 {
  margin: 0;
  font-size: 1.8rem;
  font-weight: bold;
  color: #8b7355;
}

.main-nav {
  display: flex;
  gap: 1.5rem;
}

.main-nav a {
  color: #8b7355;
  text-decoration: none;
  padding: 0.75rem 1.5rem;
  border-radius: 6px;
  transition: all 0.3s;
  font-weight: 500;
  border: 1px solid transparent;
}

.main-nav a:hover,
.main-nav a.router-link-active {
  background: #8b7355;
  color: white;
  border-color: #8b7355;
}

.app-main {
  min-height: calc(100vh - 120px);
  padding: 0;
}

.app-footer {
  background: #f8f5f0;
  color: #8b7355;
  text-align: center;
  padding: 1.5rem;
  border-top: 2px solid #e8e4da;
  font-size: 0.9rem;
}
</style>