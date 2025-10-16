<template>
  <div class="poem-detail" v-if="poem">
    <div class="poem-header">
      <h1 class="poem-title">{{ poem.title }}</h1>
      <div class="poem-meta">
        <span class="author">{{ poem.author }}</span>
        <span class="dynasty">{{ poem.dynasty }}</span>
      </div>
    </div>
    
    <div class="poem-content">
      <div class="poem-text">{{ formatPoemContent(poem.content) }}</div>
    </div>
    
    <div class="poem-actions">
      <button class="btn btn-primary" @click="toggleFavorite">
        {{ isFavorite ? '取消收藏' : '收藏' }}
      </button>
      <button class="btn btn-secondary" @click="sharePoem">分享</button>
    </div>
    
    <div class="poem-analysis">
      <h3>诗词赏析</h3>
      <p>{{ poem.analysis }}</p>
    </div>
    
    <div class="comments-section">
      <h3>评论</h3>
      <div class="comment-form">
        <textarea v-model="newComment" placeholder="写下您的评论..."></textarea>
        <button class="btn btn-primary" @click="addComment">发表评论</button>
      </div>
      
      <div class="comments-list">
        <div v-for="comment in comments" :key="comment.id" class="comment">
          <div class="comment-header">
            <span class="user-name">{{ comment.user }}</span>
            <span class="comment-time">{{ comment.time }}</span>
          </div>
          <p class="comment-content">{{ comment.content }}</p>
        </div>
      </div>
    </div>
  </div>
  <div v-else-if="isLoading" class="loading">
    <div class="loading-spinner"></div>
    <p>正在加载诗词详情...</p>
  </div>
  <div v-else class="error">
    <p>诗词详情加载失败</p>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { supabase } from '@/utils/supabase'

const route = useRoute()
const poemId = route.params.id

const poem = ref(null)
const isFavorite = ref(false)
const newComment = ref('')
const comments = ref([])
const isLoading = ref(true)

onMounted(async () => {
  try {
    console.log('开始加载诗词详情，ID:', poemId)
    const { data, error } = await supabase
      .from('poems')
      .select('*')
      .eq('id', poemId)
      .single()
    
    if (error) throw error
    
    console.log('从Supabase获取到的诗词详情:', data)
    poem.value = data
    
    // 模拟评论数据
    comments.value = [
      { id: 1, user: '诗词爱好者', time: '2024-01-15', content: '这首诗意境优美，读来令人回味无穷。' },
      { id: 2, user: '文学研究者', time: '2024-01-14', content: '李白的诗作总是充满浪漫主义色彩。' }
    ]
    isLoading.value = false
  } catch (error) {
    console.error('加载诗词详情失败:', error)
    poem.value = null
    isLoading.value = false
  }
})

const toggleFavorite = () => {
  isFavorite.value = !isFavorite.value
}

const sharePoem = () => {
  // 模拟分享功能
  alert('分享功能开发中...')
}

const addComment = () => {
  if (newComment.value.trim()) {
    comments.value.unshift({
      id: Date.now(),
      user: '当前用户',
      time: new Date().toLocaleDateString(),
      content: newComment.value
    })
    newComment.value = ''
  }
}


</script>

<style scoped>
.poem-detail {
  font-family: var(--font-ui);
  background: var(--bg-color);
  min-height: calc(100vh - 160px);
  padding: 2rem 0;
}

.poem-container {
  max-width: 800px;
  margin: 0 auto;
  padding: 0 2rem;
}

.poem-header {
  text-align: center;
  margin-bottom: 2rem;
  padding: 2rem;
  background: var(--card-bg);
  border-radius: 12px;
  box-shadow: 0 4px 20px var(--shadow-color);
  border: 1px solid var(--border-color);
}

.poem-title {
  font-size: 2.2rem;
  color: var(--accent-color);
  margin-bottom: 1rem;
  font-weight: bold;
  font-family: 'Noto Serif SC', 'SimSun', serif;
  position: relative;
  display: inline-block;
}

.poem-title::after {
  content: '';
  position: absolute;
  bottom: -8px;
  left: 25%;
  width: 50%;
  height: 2px;
  background: linear-gradient(90deg, transparent, var(--primary-color), transparent);
}

.poem-meta {
  color: var(--secondary-color);
  font-family: 'Noto Serif SC', 'SimSun', serif;
}

.author {
  font-size: 1.3rem;
  margin-right: 1rem;
  color: var(--secondary-color);
  font-family: 'Noto Serif SC', 'SimSun', serif;
}

.poem-content {
  text-align: center;
  margin: 2rem 0;
  padding: 2rem;
  background: var(--card-bg);
  border-radius: 12px;
  box-shadow: 0 4px 20px var(--shadow-color);
  border: 1px solid var(--border-color);
}

.poem-text {
  font-family: 'Noto Serif SC', 'SimSun', serif;
  font-size: 1.4rem;
  line-height: 2.2;
  white-space: pre-wrap;
  color: var(--text-color);
  text-shadow: 0.5px 0.5px 1px rgba(0, 0, 0, 0.05);
  font-weight: 400;
  letter-spacing: 0.5px;
}

.poem-actions {
  text-align: center;
  margin: 2rem 0;
}

.poem-actions .btn {
  margin: 0 0.5rem;
  background: var(--primary-color);
  border: none;
  color: white;
  padding: 0.75rem 1.5rem;
  border-radius: 25px;
  cursor: pointer;
  transition: all 0.3s ease;
  font-family: var(--font-ui);
}

.poem-actions .btn:hover {
  background: #6d5c47;
  transform: translateY(-2px);
}

.poem-actions .btn-secondary {
  background: var(--secondary-color);
}

.poem-actions .btn-secondary:hover {
  background: #8d6e63;
}

.poem-analysis,
.comments-section {
  background: var(--card-bg);
  padding: 1.5rem;
  border-radius: 12px;
  box-shadow: 0 4px 20px var(--shadow-color);
  margin-bottom: 1rem;
  border: 1px solid var(--border-color);
}

.poem-analysis h3,
.comments-section h3 {
  color: var(--accent-color);
  border-bottom: 2px solid var(--primary-color);
  padding-bottom: 0.5rem;
  margin-bottom: 1rem;
  font-family: var(--font-ui);
}

.comment-form textarea {
  width: 100%;
  height: 80px;
  padding: 0.5rem;
  border: 1px solid var(--border-color);
  border-radius: 4px;
  margin-bottom: 1rem;
  resize: vertical;
  background: var(--bg-color);
  font-family: var(--font-ui);
}

.comment {
  border-bottom: 1px solid var(--border-color);
  padding: 1rem 0;
}

.comment:last-child {
  border-bottom: none;
}

.comment-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 0.5rem;
}

.user-name {
  font-weight: bold;
  color: var(--primary-color);
  font-family: var(--font-ui);
}

.comment-time {
  color: var(--secondary-color);
  font-size: 0.9rem;
  font-family: var(--font-ui);
}

.loading, .error {
  text-align: center;
  padding: 2rem;
  color: var(--primary-color);
  font-family: var(--font-ui);
}

.loading-spinner {
  width: 40px;
  height: 40px;
  border: 4px solid var(--border-color);
  border-top: 4px solid var(--primary-color);
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin: 0 auto 1rem;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}
</style>