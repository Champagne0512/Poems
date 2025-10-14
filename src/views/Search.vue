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
  font-family: 'Microsoft YaHei', sans-serif;
  background: #f8f5f0;
  min-height: calc(100vh - 120px);
  padding: 2rem 0;
}

.search-container {
  max-width: 800px;
  margin: 0 auto;
  padding: 0 2rem;
}

.search-header {
  text-align: center;
  margin-bottom: 2rem;
  padding: 2rem;
  background: white;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  border: 1px solid #e8e4da;
}

.search-header h1 {
  color: #5d4037;
  margin-bottom: 1rem;
}

.search-box {
  display: flex;
  gap: 0.5rem;
  max-width: 500px;
  margin: 0 auto;
}

.search-input {
  flex: 1;
  padding: 0.75rem;
  border: 1px solid #e8e4da;
  border-radius: 4px;
  font-size: 1rem;
  background: #faf9f7;
}

.search-btn {
  padding: 0.75rem 1.5rem;
  background: #8b7355;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 1rem;
  transition: background 0.3s;
}

.search-btn:hover {
  background: #6d5c47;
}

.search-results h2,
.popular-searches h2 {
  color: #5d4037;
  margin-bottom: 1rem;
  border-bottom: 2px solid #8b7355;
  padding-bottom: 0.5rem;
}

.results-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.result-item {
  background: white;
  padding: 1.5rem;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: all 0.3s;
  border: 1px solid #e8e4da;
}

.result-item:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 24px rgba(0, 0, 0, 0.15);
}

.poem-title {
  color: #8b7355;
  margin-bottom: 0.5rem;
  font-weight: bold;
}

.poem-meta {
  color: #a1887f;
  font-size: 0.9rem;
  margin-bottom: 0.5rem;
}

.poem-excerpt {
  color: #5d4037;
  line-height: 1.6;
  font-family: 'SimSun', serif;
}

.no-results {
  text-align: center;
  padding: 2rem;
  color: #a1887f;
  background: white;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  border: 1px solid #e8e4da;
}

.popular-searches {
  margin-top: 2rem;
  background: white;
  padding: 1.5rem;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  border: 1px solid #e8e4da;
}

.tags {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.tag {
  background: #f8f5f0;
  color: #8b7355;
  padding: 0.5rem 1rem;
  border-radius: 20px;
  cursor: pointer;
  transition: all 0.3s;
  font-size: 0.9rem;
  border: 1px solid #e8e4da;
}

.tag:hover {
  background: #8b7355;
  color: white;
}
</style>