<template>
  <div class="search">
    <div class="search-header">
      <h1>诗词搜索</h1>
      <div class="search-box">
        <input 
          v-model="searchQuery" 
          @input="handleSearch" 
          placeholder="输入诗词标题、作者或内容..."
          type="text"
          class="search-input"
        />
        <button @click="performSearch" class="search-btn">搜索</button>
      </div>
    </div>
    
    <div class="search-results" v-if="searchResults.length > 0">
      <h2>搜索结果 ({{ searchResults.length }})</h2>
      <div class="results-list">
        <div v-for="poem in searchResults" :key="poem.id" class="result-item" @click="viewPoem(poem.id)">
          <h3 class="poem-title">{{ poem.title }}</h3>
          <p class="poem-meta">{{ poem.author }} · {{ poem.dynasty }}</p>
          <p class="poem-excerpt">{{ poem.excerpt }}</p>
        </div>
      </div>
    </div>
    
    <div class="no-results" v-else-if="searchQuery && !isLoading">
      <p>未找到相关诗词</p>
    </div>
    
    <div class="popular-searches" v-if="!searchQuery">
      <h2>热门搜索</h2>
      <div class="tags">
        <span v-for="tag in popularTags" :key="tag" class="tag" @click="searchByTag(tag)">
          {{ tag }}
        </span>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const searchQuery = ref('')
const searchResults = ref([])
const isLoading = ref(false)

// 模拟诗词数据
const poems = ref([
  {
    id: 1,
    title: '静夜思',
    author: '李白',
    dynasty: '唐代',
    excerpt: '床前明月光，疑是地上霜。举头望明月，低头思故乡。',
    content: '床前明月光，疑是地上霜。\n举头望明月，低头思故乡。'
  },
  {
    id: 2,
    title: '春晓',
    author: '孟浩然',
    dynasty: '唐代',
    excerpt: '春眠不觉晓，处处闻啼鸟。夜来风雨声，花落知多少。',
    content: '春眠不觉晓，处处闻啼鸟。\n夜来风雨声，花落知多少。'
  },
  {
    id: 3,
    title: '登鹳雀楼',
    author: '王之涣',
    dynasty: '唐代',
    excerpt: '白日依山尽，黄河入海流。欲穷千里目，更上一层楼。',
    content: '白日依山尽，黄河入海流。\n欲穷千里目，更上一层楼。'
  }
])

const popularTags = ref(['李白', '唐诗', '宋词', '杜甫', '苏轼', '爱情诗', '山水诗'])

const handleSearch = () => {
  if (searchQuery.value.trim()) {
    performSearch()
  } else {
    searchResults.value = []
  }
}

const performSearch = () => {
  if (!searchQuery.value.trim()) return
  
  isLoading.value = true
  
  // 模拟搜索延迟
  setTimeout(() => {
    const query = searchQuery.value.toLowerCase()
    searchResults.value = poems.value.filter(poem => 
      poem.title.toLowerCase().includes(query) ||
      poem.author.toLowerCase().includes(query) ||
      poem.content.toLowerCase().includes(query) ||
      poem.excerpt.toLowerCase().includes(query)
    )
    isLoading.value = false
  }, 300)
}

const searchByTag = (tag) => {
  searchQuery.value = tag
  performSearch()
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
  background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="50" cy="50" r="1" fill="%23ffffff" opacity="0.1"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
  pointer-events: none;
}

.search-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
  position: relative;
  z-index: 1;
}

.search-header {
  text-align: center;
  margin-bottom: 0;
  padding: 4rem 2rem;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  border-radius: 0 0 30px 30px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-top: none;
}

.search-header h1 {
  color: #5D4037;
  margin-bottom: 2rem;
  font-size: 3rem;
  font-weight: 700;
  text-shadow: 2px 2px 4px rgba(139, 115, 85, 0.3);
  letter-spacing: 2px;
}

.search-box {
  display: flex;
  gap: 1rem;
  max-width: 600px;
  margin: 0 auto;
}

.search-input {
  flex: 1;
  padding: 1rem 2rem;
  border: 2px solid rgba(139, 115, 85, 0.3);
  border-radius: 50px;
  font-size: 1.1rem;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20px);
  transition: all 0.3s;
  outline: none;
  font-family: 'STKaiti', 'KaiTi', serif;
}

.search-input:focus {
  border-color: #8B7355;
  box-shadow: 0 0 20px rgba(139, 115, 85, 0.3);
  background: rgba(255, 255, 255, 1);
}

.search-btn {
  padding: 1rem 2.5rem;
  background: linear-gradient(135deg, #8B7355, #A1887F);
  color: white;
  border: none;
  border-radius: 50px;
  cursor: pointer;
  font-size: 1.1rem;
  font-weight: 600;
  transition: all 0.3s;
  box-shadow: 0 4px 15px rgba(139, 115, 85, 0.3);
  font-family: 'STKaiti', 'KaiTi', serif;
}

.search-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(240, 147, 251, 0.4);
}

.search-results,
.popular-searches,
.no-results {
  max-width: 1200px;
  margin: 0 auto;
  padding: 3rem 2rem;
}

.search-results h2,
.popular-searches h2 {
  color: #2d3748;
  margin-bottom: 2rem;
  font-size: 2rem;
  font-weight: 700;
  border-bottom: 3px solid #f093fb;
  padding-bottom: 1rem;
}

.results-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.result-item {
  background: rgba(255, 255, 255, 0.98);
  backdrop-filter: blur(20px);
  padding: 2rem;
  border-radius: 15px;
  box-shadow: 
    0 4px 20px rgba(139, 115, 85, 0.15),
    inset 0 1px 0 rgba(255, 255, 255, 0.8);
  cursor: pointer;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  border: 1px solid rgba(139, 115, 85, 0.1);
  margin-bottom: 1.5rem;
}

.result-item:hover {
  transform: translateY(-8px) scale(1.02);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
}

.poem-title {
  color: #5D4037;
  margin-bottom: 0.5rem;
  font-size: 1.4rem;
  font-weight: 700;
  font-family: 'STKaiti', 'KaiTi', serif;
}

.poem-meta {
  color: #8B7355;
  font-size: 1.1rem;
  margin-bottom: 1rem;
  font-weight: 600;
  font-style: italic;
}

.poem-excerpt {
  color: #5D4037;
  line-height: 2;
  font-family: 'STKaiti', 'KaiTi', serif;
  font-size: 1.1rem;
  letter-spacing: 1px;
}

.no-results {
  text-align: center;
  padding: 4rem 2rem;
  color: #4a5568;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  border-radius: 20px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.popular-searches {
  margin-top: 2rem;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  padding: 2rem;
  border-radius: 20px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.tags {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.tag {
  background: rgba(255, 255, 255, 0.9);
  color: #f093fb;
  padding: 0.75rem 1.5rem;
  border-radius: 25px;
  cursor: pointer;
  transition: all 0.3s;
  font-size: 1rem;
  font-weight: 500;
  border: 2px solid rgba(240, 147, 251, 0.3);
  backdrop-filter: blur(10px);
}

.tag:hover {
  background: linear-gradient(135deg, #f093fb, #f5576c);
  color: white;
  transform: translateY(-2px);
  box-shadow: 0 4px 15px rgba(240, 147, 251, 0.3);
}
</style>