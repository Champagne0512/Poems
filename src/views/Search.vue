<template>
  <div class="search">
    <div class="page-header">
      <div class="header-content">
        <h1>诗词搜索</h1>
        <div class="search-box">
          <input 
            v-model="searchQuery" 
            @input="handleSearch" 
            placeholder="输入诗词标题、作者或内容..." 
            class="search-input"
          />
          <button @click="performSearch" class="search-btn">搜索</button>
        </div>
      </div>
    </div>
    
    <div v-if="loading" class="loading">
      <p>搜索中...</p>
    </div>
    
    <div v-else-if="searchResults.length === 0 && searchQuery" class="no-results">
      <p>没有找到相关诗词</p>
    </div>
    
    <div v-else class="search-results">
      <div v-for="poem in searchResults" :key="poem.id" class="poem-item" @click="viewPoem(poem.id)">
        <div class="poem-image">
          <img :src="poem.image || './OIP.jpg'" :alt="poem.title" class="poem-img">
        </div>
        <h3 class="poem-title">{{ poem.title }}</h3>
        <p class="poem-meta">{{ poem.author }} · {{ poem.dynasty }}</p>
        <div class="poem-content">
          {{ poem.content }}
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useSupabaseStore } from '../stores/supabase'

const router = useRouter()
const supabaseStore = useSupabaseStore()

const searchQuery = ref('')
const searchResults = ref([])
const loading = ref(false)
let searchTimeout = null

const handleSearch = () => {
  if (searchTimeout) {
    clearTimeout(searchTimeout)
  }
  
  if (!searchQuery.value.trim()) {
    searchResults.value = []
    return
  }
  
  loading.value = true
  searchTimeout = setTimeout(async () => {
    await performSearch()
  }, 500)
}

const performSearch = async () => {
  if (!searchQuery.value.trim()) {
    searchResults.value = []
    loading.value = false
    return
  }
  
  try {
    const results = await supabaseStore.searchPoems(searchQuery.value)
    searchResults.value = results
  } catch (error) {
    console.error('搜索失败:', error)
    searchResults.value = []
  } finally {
    loading.value = false
  }
}

const viewPoem = (poemId) => {
  router.push(`/poem/${poemId}`)
}
</script>

<style scoped>
.search {
  font-family: 'STKaiti', 'KaiTi', 'SimSun', serif;
  background: linear-gradient(135deg, #8B7355 0%, #A1887F 50%, #BCAAA4 100%);
  min-height: 100vh;
  padding: 0;
  position: relative;
  overflow: hidden;
}

.search::before {
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
  display: flex;
  flex-direction: column;
  gap: 2rem;
  align-items: center;
}

.page-header h1 {
  color: #5D4037;
  margin: 0;
  font-size: 3rem;
  font-weight: 700;
  text-shadow: 2px 2px 4px rgba(139, 115, 85, 0.3);
  letter-spacing: 2px;
}

.search-box {
  display: flex;
  gap: 1rem;
  width: 100%;
  max-width: 600px;
}

.search-input {
  flex: 1;
  padding: 1rem 1.5rem;
  border: 2px solid rgba(139, 115, 85, 0.3);
  border-radius: 50px;
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(10px);
  font-size: 1.1rem;
  color: #5D4037;
  transition: all 0.3s;
  outline: none;
}

.search-input:focus {
  border-color: #8B7355;
  box-shadow: 0 0 20px rgba(139, 115, 85, 0.3);
  background: rgba(255, 255, 255, 1);
}

.search-btn {
  padding: 1rem 2rem;
  background: linear-gradient(135deg, #8B7355, #A1887F);
  border: none;
  border-radius: 50px;
  color: white;
  font-size: 1.1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
  box-shadow: 0 4px 15px rgba(139, 115, 85, 0.3);
}

.search-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(139, 115, 85, 0.4);
}

.loading, .no-results {
  text-align: center;
  padding: 4rem 2rem;
  color: #4a5568;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  border-radius: 20px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  margin: 3rem auto;
  max-width: 1200px;
}

.search-results {
  max-width: 1200px;
  margin: 0 auto;
  padding: 3rem 2rem;
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
  gap: 2rem;
  position: relative;
  z-index: 1;
}

.poem-item {
  background: rgba(255, 255, 255, 0.98);
  backdrop-filter: blur(20px);
  padding: 2.5rem;
  border-radius: 15px;
  box-shadow: 
    0 4px 20px rgba(139, 115, 85, 0.15),
    inset 0 1px 0 rgba(255, 255, 255, 0.8);
  cursor: pointer;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  border: 1px solid rgba(139, 115, 85, 0.1);
  position: relative;
  overflow: hidden;
}

.poem-item::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.4), transparent);
  transition: left 0.6s;
}

.poem-item:hover {
  transform: translateY(-8px) scale(1.02);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
  border-color: rgba(102, 126, 234, 0.3);
}

.poem-item:hover::before {
  left: 100%;
}

.poem-image {
  height: 180px;
  background: linear-gradient(135deg, #8B7355 0%, #A1887F 100%);
  margin: -2.5rem -2.5rem 2rem -2.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  border-radius: 12px 12px 0 0;
  position: relative;
}

.poem-image::after {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.1);
}

.poem-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.poem-title {
  color: #5D4037;
  margin-bottom: 1rem;
  font-size: 1.6rem;
  font-weight: 700;
  line-height: 1.4;
  text-align: center;
}

.poem-meta {
  color: #8B7355;
  font-size: 1.1rem;
  margin-bottom: 1.5rem;
  font-weight: 600;
  text-align: center;
  font-style: italic;
}

.poem-content {
  white-space: pre-line;
  line-height: 2;
  color: #5D4037;
  font-family: 'STKaiti', 'KaiTi', serif;
  font-size: 1.1rem;
  max-height: 132px;
  overflow: hidden;
  display: -webkit-box;
  -webkit-line-clamp: 4;
  -webkit-box-orient: vertical;
  text-align: center;
  letter-spacing: 1px;
}

@media (max-width: 768px) {
  .page-header {
    padding: 0 1rem;
  }
  
  .search-box {
    flex-direction: column;
  }
  
  .search-results {
    grid-template-columns: 1fr;
    padding: 0 1rem;
  }
}
</style>