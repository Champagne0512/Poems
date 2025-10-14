<template>
  <div id="app">
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