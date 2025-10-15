<template>
  <div class="poems">
    <div class="page-header">
      <div class="header-content">
        <h1>诗词浏览</h1>
        <div class="filter-controls">
          <select v-model="selectedDynasty" @change="filterPoems">
            <option value="">全部朝代</option>
            <option v-for="dynasty in dynasties" :key="dynasty" :value="dynasty">{{ dynasty }}</option>
          </select>
          <select v-model="selectedAuthor" @change="filterPoems">
            <option value="">全部作者</option>
            <option v-for="author in authors" :key="author" :value="author">{{ author }}</option>
          </select>
        </div>
      </div>
    </div>
    
    <div v-if="loading" class="loading">
      <p>加载中...</p>
    </div>
    
    <div v-else class="poem-grid">
      <div v-for="poem in filteredPoems" :key="poem.id" class="poem-item" @click="viewPoem(poem.id)">
        <div class="poem-image">
          <img :src="poem.image_url || '/images/OIP.jpg'" :alt="poem.title" class="poem-img">
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
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useSupabaseStore } from '../stores/supabase'

const router = useRouter()
const supabaseStore = useSupabaseStore()

const poems = ref([])
const selectedDynasty = ref('')
const selectedAuthor = ref('')
const loading = ref(true)

// 从Supabase加载诗词数据
onMounted(async () => {
  loading.value = true
  try {
    await supabaseStore.fetchPoems()
    poems.value = supabaseStore.poems
  } catch (error) {
    console.error('加载诗词数据失败:', error)
  } finally {
    loading.value = false
  }
})

// 获取所有朝代和作者
const dynasties = computed(() => [...new Set(poems.value.map(p => p.dynasty))])
const authors = computed(() => [...new Set(poems.value.map(p => p.author))])

// 过滤诗词
const filteredPoems = computed(() => {
  return poems.value.filter(poem => {
    const matchDynasty = !selectedDynasty.value || poem.dynasty === selectedDynasty.value
    const matchAuthor = !selectedAuthor.value || poem.author === selectedAuthor.value
    return matchDynasty && matchAuthor
  })
})

const filterPoems = () => {
  // 过滤逻辑已在computed属性中实现
}

const viewPoem = (poemId) => {
  router.push(`/poem/${poemId}`)
}
</script>

<style scoped>
.poems {
  font-family: 'STKaiti', 'KaiTi', 'SimSun', serif;
  background: linear-gradient(135deg, #8B7355 0%, #A1887F 50%, #BCAAA4 100%);
  min-height: 100vh;
  padding: 0;
  position: relative;
  overflow: hidden;
}

.poems::before {
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
  justify-content: space-between;
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

.filter-controls {
  display: flex;
  gap: 1rem;
}

.filter-controls select {
  padding: 0.5rem 1rem;
  border: 1px solid #e8e4da;
  border-radius: 4px;
  background: white;
  font-size: 0.9rem;
  color: #5d4037;
  transition: border-color 0.3s;
}

.filter-controls select:focus {
  outline: none;
  border-color: #8b7355;
}

.loading {
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

.poem-grid {
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
    flex-direction: column;
    gap: 1rem;
    align-items: flex-start;
    padding: 0 1rem;
  }
  
  .filter-controls {
    width: 100%;
    justify-content: space-between;
  }
  
  .poem-grid {
    grid-template-columns: 1fr;
    padding: 0 1rem;
  }
}
</style>