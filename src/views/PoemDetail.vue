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
  <div v-else class="loading">
    <p>加载中...</p>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()
const poemId = route.params.id

const poem = ref(null)
const isFavorite = ref(false)
const newComment = ref('')
const comments = ref([])

// 模拟诗词详情数据
const poemData = {
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

onMounted(() => {
  // 模拟加载数据
  setTimeout(() => {
    poem.value = poemData[poemId] || poemData[1]
    comments.value = [
      { id: 1, user: '诗词爱好者', time: '2024-01-15', content: '这首诗意境优美，读来令人回味无穷。' },
      { id: 2, user: '文学研究者', time: '2024-01-14', content: '李白的诗作总是充满浪漫主义色彩。' }
    ]
  }, 500)
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
  font-family: 'Microsoft YaHei', sans-serif;
  background: #f8f5f0;
  min-height: calc(100vh - 120px);
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
  background: white;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  border: 1px solid #e8e4da;
}

.poem-title {
  font-size: 2rem;
  color: #5d4037;
  margin-bottom: 1rem;
  font-weight: bold;
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
  margin: 2rem 0;
  padding: 2rem;
  background: white;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  border: 1px solid #e8e4da;
}

.poem-text {
  font-family: 'SimSun', serif;
  font-size: 1.2rem;
  line-height: 2;
  white-space: pre-line;
  color: #5d4037;
}

.poem-actions {
  text-align: center;
  margin: 2rem 0;
}

.poem-actions .btn {
  margin: 0 0.5rem;
  background: #8b7355;
  border: none;
  color: white;
  padding: 0.75rem 1.5rem;
  border-radius: 4px;
  cursor: pointer;
  transition: background 0.3s;
}

.poem-actions .btn:hover {
  background: #6d5c47;
}

.poem-actions .btn-secondary {
  background: #a1887f;
}

.poem-actions .btn-secondary:hover {
  background: #8d6e63;
}

.poem-analysis,
.comments-section {
  background: white;
  padding: 1.5rem;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  margin-bottom: 1rem;
  border: 1px solid #e8e4da;
}

.poem-analysis h3,
.comments-section h3 {
  color: #5d4037;
  border-bottom: 2px solid #8b7355;
  padding-bottom: 0.5rem;
  margin-bottom: 1rem;
}

.comment-form textarea {
  width: 100%;
  height: 80px;
  padding: 0.5rem;
  border: 1px solid #e8e4da;
  border-radius: 4px;
  margin-bottom: 1rem;
  resize: vertical;
  background: #faf9f7;
}

.comment {
  border-bottom: 1px solid #eee;
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
  color: #8b7355;
}

.comment-time {
  color: #7f8c8d;
  font-size: 0.9rem;
}

.loading {
  text-align: center;
  padding: 2rem;
  color: #8b7355;
}
</style>