<template>
  <div class="poem-detail" v-if="poem">
    <div class="poem-container">
      <div class="poem-header">
        <h1 class="poem-title">{{ poem.title }}</h1>
        <div class="poem-meta">
          <span class="author">{{ poem.author }}</span>
          <span class="dynasty">{{ poem.dynasty }}</span>
        </div>
      </div>
      
      <div class="poem-content">
        <pre class="poem-text">{{ poem.content }}</pre>
      </div>
      
      <div class="poem-actions">
        <button class="btn btn-primary" @click="toggleFavorite">
          {{ isFavorite ? '取消收藏' : '收藏' }}
        </button>
        <button class="btn btn-secondary" @click="sharePoem">分享</button>
      </div>
      
      <div class="poem-analysis">
        <h3>诗词赏析</h3>
        <p>{{ poem.analysis || '暂无赏析内容' }}</p>
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
  </div>
  <div v-else class="loading">
    <p>加载中...</p>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { useSupabaseStore } from '../stores/supabase'

const route = useRoute()
const supabaseStore = useSupabaseStore()
const poemId = route.params.id

const poem = ref(null)
const isFavorite = ref(false)
const newComment = ref('')
const comments = ref([])
const loading = ref(true)

onMounted(async () => {
  loading.value = true
  try {
    poem.value = await supabaseStore.fetchPoemById(poemId)
    if (!poem.value) {
      // 如果Supabase中没有数据，使用默认数据
      poem.value = getDefaultPoemData(poemId)
    }
  } catch (error) {
    console.error('加载诗词详情失败:', error)
    poem.value = getDefaultPoemData(poemId)
  } finally {
    loading.value = false
  }
})

// 默认诗词数据
const getDefaultPoemData = (id) => {
  const defaultPoems = {
    1: {
      id: 1,
      title: '静夜思',
      author: '李白',
      dynasty: '唐代',
      content: '床前明月光，疑是地上霜。\n举头望明月，低头思故乡。',
      analysis: '这首诗通过描绘月夜思乡的场景，表达了诗人深切的思乡之情。语言简练，意境深远，是李白最著名的诗作之一。'
    },
    2: {
      id: 2,
      title: '春晓',
      author: '孟浩然',
      dynasty: '唐代',
      content: '春眠不觉晓，处处闻啼鸟。\n夜来风雨声，花落知多少。',
      analysis: '这首诗描绘了春天早晨的景色，语言清新自然，表达了诗人对春天的热爱和对时光流逝的感慨。'
    }
  }
  return defaultPoems[id] || defaultPoems[1]
}

const toggleFavorite = async () => {
  if (!supabaseStore.user) {
    alert('请先登录')
    return
  }
  
  try {
    if (isFavorite.value) {
      // 取消收藏逻辑
      isFavorite.value = false
    } else {
      await supabaseStore.addFavorite(poemId)
      isFavorite.value = true
    }
  } catch (error) {
    console.error('收藏操作失败:', error)
  }
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
  font-family: 'STKaiti', 'KaiTi', 'SimSun', serif;
  background: linear-gradient(135deg, #8B7355 0%, #A1887F 50%, #BCAAA4 100%);
  min-height: 100vh;
  padding: 0;
  position: relative;
  overflow: hidden;
}

.poem-detail::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="50" cy="50" r="1" fill="%23ffffff" opacity="0.1"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
  pointer-events: none;
}

.poem-container {
  max-width: 800px;
  margin: 0 auto;
  padding: 0 2rem;
  position: relative;
  z-index: 1;
}

.poem-header {
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

.poem-title {
  font-size: 3rem;
  color: #2d3748;
  margin-bottom: 1rem;
  font-weight: 700;
  background: linear-gradient(135deg, #8B7355, #A1887F);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.poem-meta {
  color: #8b7355;
}

.author {
  font-size: 1.2rem;
  margin-right: 1rem;
  color: #8b7355;
}

.poem-content {
  text-align: center;
  margin: 3rem 0;
  padding: 3rem;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  border-radius: 20px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.poem-text {
  font-family: 'SimSun', serif;
  font-size: 1.4rem;
  line-height: 2;
  white-space: pre-line;
  color: #2d3748;
  font-weight: 500;
}

.poem-actions {
  text-align: center;
  margin: 3rem 0;
}

.poem-actions .btn {
  margin: 0 1rem;
  background: linear-gradient(135deg, #8B7355, #A1887F);
  border: none;
  color: white;
  padding: 1rem 2rem;
  border-radius: 50px;
  cursor: pointer;
  transition: all 0.3s;
  font-size: 1.1rem;
  font-weight: 600;
  box-shadow: 0 4px 15px rgba(139, 115, 85, 0.3);
}

.poem-actions .btn:hover {
  transform: translateY(-3px);
  box-shadow: 0 8px 25px rgba(139, 115, 85, 0.4);
}

.poem-actions .btn-secondary {
  background: linear-gradient(135deg, #BCAAA4, #A1887F);
}

.poem-actions .btn-secondary:hover {
  box-shadow: 0 8px 25px rgba(188, 170, 164, 0.4);
}

.poem-analysis,
.comments-section {
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  padding: 2rem;
  border-radius: 20px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  margin-bottom: 2rem;
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.poem-analysis h3,
.comments-section h3 {
  color: #2d3748;
  border-bottom: 3px solid #8B7355;
  padding-bottom: 1rem;
  margin-bottom: 1.5rem;
  font-size: 1.8rem;
  font-weight: 700;
}

.comment-form textarea {
  width: 100%;
  height: 100px;
  padding: 1rem;
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-radius: 15px;
  margin-bottom: 1rem;
  resize: vertical;
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(10px);
  font-size: 1rem;
  transition: all 0.3s;
  outline: none;
}

.comment-form textarea:focus {
  border-color: #8B7355;
  box-shadow: 0 0 20px rgba(139, 115, 85, 0.3);
  background: rgba(255, 255, 255, 1);
}

.comment {
  border-bottom: 1px solid rgba(255, 255, 255, 0.3);
  padding: 1.5rem 0;
  transition: all 0.3s;
}

.comment:last-child {
  border-bottom: none;
}

.comment:hover {
  background: rgba(255, 255, 255, 0.1);
  border-radius: 10px;
  padding: 1.5rem;
  margin: 0 -1rem;
}

.comment-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 1rem;
}

.user-name {
  font-weight: bold;
  color: #8B7355;
  font-size: 1.1rem;
}

.comment-time {
  color: #4a5568;
  font-size: 1rem;
}

.loading {
  text-align: center;
  padding: 4rem 2rem;
  color: #4a5568;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  border-radius: 20px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
}
</style>