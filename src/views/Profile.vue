<template>
  <div class="profile">
    <div class="page-header">
      <div class="header-content">
        <h1>个人中心</h1>
        <p>管理您的诗词收藏和偏好设置</p>
      </div>
    </div>
    
    <div class="profile-content">
      <div class="profile-sidebar">
        <div class="user-info">
          <div class="avatar">
            <img src="./OIP.jpg" alt="用户头像" class="avatar-img">
          </div>
          <h3 class="username">诗词爱好者</h3>
          <p class="user-bio">热爱古典诗词，传承中华文化</p>
        </div>
        
        <nav class="profile-nav">
          <button 
            v-for="tab in tabs" 
            :key="tab.id"
            @click="activeTab = tab.id"
            :class="['nav-item', { active: activeTab === tab.id }]"
          >
            {{ tab.label }}
          </button>
        </nav>
      </div>
      
      <div class="profile-main">
        <div v-if="activeTab === 'favorites'" class="tab-content">
          <h2>我的收藏</h2>
          <div v-if="favorites.length === 0" class="empty-state">
            <p>暂无收藏的诗词</p>
          </div>
          <div v-else class="favorites-list">
            <div v-for="poem in favorites" :key="poem.id" class="favorite-item">
              <div class="poem-info">
                <h4>{{ poem.title }}</h4>
                <p>{{ poem.author }} · {{ poem.dynasty }}</p>
              </div>
              <button @click="removeFavorite(poem.id)" class="remove-btn">移除</button>
            </div>
          </div>
        </div>
        
        <div v-if="activeTab === 'settings'" class="tab-content">
          <h2>偏好设置</h2>
          <div class="setting-item">
            <label>
              <input type="checkbox" v-model="settings.darkMode" />
              深色模式
            </label>
          </div>
          <div class="setting-item">
            <label>
              <input type="checkbox" v-model="settings.autoPlay" />
              自动播放音频
            </label>
          </div>
        </div>
        
        <div v-if="activeTab === 'history'" class="tab-content">
          <h2>浏览历史</h2>
          <div v-if="history.length === 0" class="empty-state">
            <p>暂无浏览历史</p>
          </div>
          <div v-else class="history-list">
            <div v-for="item in history" :key="item.id" class="history-item">
              <span>{{ item.title }}</span>
              <small>{{ formatDate(item.timestamp) }}</small>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useSupabaseStore } from '../stores/supabase'

const supabaseStore = useSupabaseStore()

const activeTab = ref('favorites')
const favorites = ref([])
const history = ref([])
const settings = ref({
  darkMode: false,
  autoPlay: true
})

const tabs = [
  { id: 'favorites', label: '我的收藏' },
  { id: 'history', label: '浏览历史' },
  { id: 'settings', label: '偏好设置' }
]

onMounted(async () => {
  await loadFavorites()
  await loadHistory()
})

const loadFavorites = async () => {
  try {
    favorites.value = await supabaseStore.getFavorites()
  } catch (error) {
    console.error('加载收藏失败:', error)
  }
}

const loadHistory = async () => {
  try {
    history.value = await supabaseStore.getHistory()
  } catch (error) {
    console.error('加载历史失败:', error)
  }
}

const removeFavorite = async (poemId) => {
  try {
    await supabaseStore.removeFavorite(poemId)
    favorites.value = favorites.value.filter(p => p.id !== poemId)
  } catch (error) {
    console.error('移除收藏失败:', error)
  }
}

const formatDate = (timestamp) => {
  return new Date(timestamp).toLocaleString('zh-CN')
}
</script>

<style scoped>
.profile {
  font-family: 'STKaiti', 'KaiTi', 'SimSun', serif;
  background: linear-gradient(135deg, #8B7355 0%, #A1887F 50%, #BCAAA4 100%);
  min-height: 100vh;
  padding: 0;
  position: relative;
  overflow: hidden;
}

.profile::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: 
    radial-gradient(circle at 20% 80%, rgba(139, 115, 85, 0.1) 0%, transparent 50%),
    radial-gradient(circle at 80% 20%, rgba(161, 136, 127, 0.1) 0%, transparent 50%),
    url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="50" cy="50" r="1" fill="%23ffffff" opacity="0.05"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
  pointer-events: none;
}

.page-header {
  background: rgba(255, 255, 255, 0.98);
  backdrop-filter: blur(20px);
  padding: 3rem 0;
  margin-bottom: 0;
  border-bottom: 1px solid rgba(139, 115, 85, 0.2);
  box-shadow: 0 4px 20px rgba(139, 115, 85, 0.1);
  position: relative;
  z-index: 1;
}

.header-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
  text-align: center;
}

.page-header h1 {
  color: #5D4037;
  margin: 0 0 1rem 0;
  font-size: 3rem;
  font-weight: 700;
  text-shadow: 2px 2px 4px rgba(139, 115, 85, 0.3);
  letter-spacing: 2px;
}

.page-header p {
  color: #8B7355;
  font-size: 1.2rem;
  margin: 0;
  font-style: italic;
}

.profile-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 3rem 2rem;
  display: grid;
  grid-template-columns: 300px 1fr;
  gap: 2rem;
  position: relative;
  z-index: 1;
}

.profile-sidebar {
  background: rgba(255, 255, 255, 0.98);
  backdrop-filter: blur(20px);
  border-radius: 15px;
  padding: 2rem;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  border: 1px solid rgba(139, 115, 85, 0.1);
}

.user-info {
  text-align: center;
  margin-bottom: 2rem;
}

.avatar {
  width: 100px;
  height: 100px;
  margin: 0 auto 1rem;
  border-radius: 50%;
  overflow: hidden;
  border: 4px solid #8B7355;
}

.avatar-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.username {
  color: #5D4037;
  margin: 0 0 0.5rem 0;
  font-size: 1.4rem;
  font-weight: 700;
}

.user-bio {
  color: #8B7355;
  margin: 0;
  font-style: italic;
}

.profile-nav {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.nav-item {
  padding: 1rem;
  border: none;
  background: transparent;
  color: #5D4037;
  text-align: left;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s;
  font-size: 1.1rem;
  font-weight: 600;
}

.nav-item:hover {
  background: rgba(139, 115, 85, 0.1);
}

.nav-item.active {
  background: linear-gradient(135deg, #8B7355, #A1887F);
  color: white;
}

.profile-main {
  background: rgba(255, 255, 255, 0.98);
  backdrop-filter: blur(20px);
  border-radius: 15px;
  padding: 2rem;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  border: 1px solid rgba(139, 115, 85, 0.1);
}

.tab-content h2 {
  color: #5D4037;
  margin: 0 0 2rem 0;
  font-size: 2rem;
  font-weight: 700;
}

.empty-state {
  text-align: center;
  padding: 3rem;
  color: #8B7355;
  font-style: italic;
}

.favorites-list, .history-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.favorite-item, .history-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem;
  background: rgba(139, 115, 85, 0.05);
  border-radius: 8px;
  border: 1px solid rgba(139, 115, 85, 0.1);
}

.poem-info h4 {
  margin: 0 0 0.5rem 0;
  color: #5D4037;
  font-size: 1.2rem;
}

.poem-info p {
  margin: 0;
  color: #8B7355;
  font-size: 0.9rem;
}

.remove-btn {
  padding: 0.5rem 1rem;
  background: #e74c3c;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 0.9rem;
}

.setting-item {
  margin-bottom: 1.5rem;
}

.setting-item label {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: #5D4037;
  font-size: 1.1rem;
  cursor: pointer;
}

.setting-item input {
  width: 18px;
  height: 18px;
}

.history-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.history-item small {
  color: #8B7355;
  font-size: 0.8rem;
}

@media (max-width: 768px) {
  .profile-content {
    grid-template-columns: 1fr;
    padding: 0 1rem;
  }
  
  .profile-sidebar {
    margin-bottom: 2rem;
  }
}
</style>