<template>
  <div class="profile">
    <div class="profile-header">
      <div class="user-info">
        <div class="avatar">
          <img :src="user.avatar" :alt="user.name" />
        </div>
        <div class="user-details">
          <h1>{{ user.name }}</h1>
          <p class="user-bio">{{ user.bio }}</p>
          <div class="user-stats">
            <div class="stat">
              <span class="stat-number">{{ userStats.collections }}</span>
              <span class="stat-label">收藏</span>
            </div>
            <div class="stat">
              <span class="stat-number">{{ userStats.comments }}</span>
              <span class="stat-label">评论</span>
            </div>
            <div class="stat">
              <span class="stat-number">{{ userStats.views }}</span>
              <span class="stat-label">浏览</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="profile-content">
      <div class="tabs">
        <button 
          v-for="tab in tabs" 
          :key="tab.id"
          :class="['tab', { active: activeTab === tab.id }]"
          @click="activeTab = tab.id"
        >
          {{ tab.label }}
        </button>
      </div>

      <div class="tab-content">
        <!-- 收藏的诗词 -->
        <div v-if="activeTab === 'collections'" class="collections">
          <h2>我的收藏</h2>
          <div v-if="collections.length > 0" class="collection-list">
            <div v-for="poem in collections" :key="poem.id" class="collection-item" @click="viewPoem(poem.id)">
              <h3>{{ poem.title }}</h3>
              <p>{{ poem.author }} · {{ poem.dynasty }}</p>
              <button class="remove-btn" @click.stop="removeCollection(poem.id)">取消收藏</button>
            </div>
          </div>
          <div v-else class="empty-state">
            <p>暂无收藏的诗词</p>
          </div>
        </div>

        <!-- 我的评论 -->
        <div v-if="activeTab === 'comments'" class="comments">
          <h2>我的评论</h2>
          <div v-if="userComments.length > 0" class="comment-list">
            <div v-for="comment in userComments" :key="comment.id" class="comment-item">
              <div class="comment-header">
                <span class="poem-title" @click="viewPoem(comment.poemId)">{{ comment.poemTitle }}</span>
                <span class="comment-time">{{ comment.time }}</span>
              </div>
              <p class="comment-content">{{ comment.content }}</p>
              <button class="delete-btn" @click="deleteComment(comment.id)">删除</button>
            </div>
          </div>
          <div v-else class="empty-state">
            <p>暂无评论</p>
          </div>
        </div>

        <!-- 浏览历史 -->
        <div v-if="activeTab === 'history'" class="history">
          <h2>浏览历史</h2>
          <div v-if="browseHistory.length > 0" class="history-list">
            <div v-for="item in browseHistory" :key="item.id" class="history-item" @click="viewPoem(item.poemId)">
              <h3>{{ item.poemTitle }}</h3>
              <p>{{ item.author }} · {{ item.dynasty }}</p>
              <span class="view-time">{{ item.time }}</span>
            </div>
          </div>
          <div v-else class="empty-state">
            <p>暂无浏览历史</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()

// 用户信息
const user = ref({
  name: '诗词爱好者',
  avatar: '/api/placeholder/avatar/80',
  bio: '热爱中国古典诗词，喜欢在诗词中寻找生活的诗意。'
})

const userStats = ref({
  collections: 12,
  comments: 8,
  views: 156
})

const tabs = ref([
  { id: 'collections', label: '我的收藏' },
  { id: 'comments', label: '我的评论' },
  { id: 'history', label: '浏览历史' }
])

const activeTab = ref('collections')

// 模拟数据
const collections = ref([
  { id: 1, title: '静夜思', author: '李白', dynasty: '唐代' },
  { id: 2, title: '春晓', author: '孟浩然', dynasty: '唐代' },
  { id: 3, title: '登鹳雀楼', author: '王之涣', dynasty: '唐代' }
])

const userComments = ref([
  { id: 1, poemId: 1, poemTitle: '静夜思', content: '这首诗意境优美，读来令人回味无穷。', time: '2024-01-15' },
  { id: 2, poemId: 2, poemTitle: '春晓', content: '孟浩然的诗总是那么清新自然。', time: '2024-01-14' }
])

const browseHistory = ref([
  { id: 1, poemId: 1, poemTitle: '静夜思', author: '李白', dynasty: '唐代', time: '2024-01-15 10:30' },
  { id: 2, poemId: 2, poemTitle: '春晓', author: '孟浩然', dynasty: '唐代', time: '2024-01-15 09:15' },
  { id: 3, poemId: 3, poemTitle: '登鹳雀楼', author: '王之涣', dynasty: '唐代', time: '2024-01-14 16:45' }
])

const viewPoem = (poemId) => {
  router.push(`/poem/${poemId}`)
}

const removeCollection = (poemId) => {
  collections.value = collections.value.filter(poem => poem.id !== poemId)
}

const deleteComment = (commentId) => {
  userComments.value = userComments.value.filter(comment => comment.id !== commentId)
}
</script>

<style scoped>
.profile {
  font-family: 'Microsoft YaHei', sans-serif;
  background: #f8f5f0;
  min-height: calc(100vh - 120px);
  padding: 2rem 0;
}

.profile-container {
  max-width: 800px;
  margin: 0 auto;
  padding: 0 2rem;
}

.profile-header {
  background: white;
  padding: 2rem;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  margin-bottom: 2rem;
  border: 1px solid #e8e4da;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 2rem;
}

.avatar img {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  background: #ecf0f1;
}

.user-details h1 {
  margin: 0 0 0.5rem 0;
  color: #5d4037;
}

.user-bio {
  color: #8b7355;
  margin-bottom: 1rem;
}

.user-stats {
  display: flex;
  gap: 2rem;
}

.stat {
  text-align: center;
}

.stat-number {
  display: block;
  font-size: 1.5rem;
  font-weight: bold;
  color: #8b7355;
}

.stat-label {
  font-size: 0.9rem;
  color: #a1887f;
}

.tabs {
  display: flex;
  border-bottom: 1px solid #ddd;
  margin-bottom: 2rem;
}

.tab {
  padding: 1rem 2rem;
  background: none;
  border: none;
  cursor: pointer;
  border-bottom: 2px solid transparent;
  transition: all 0.3s;
  color: #8b7355;
}

.tab.active {
  border-bottom-color: #8b7355;
  color: #5d4037;
  font-weight: bold;
}

.tab:hover {
  background: #f8f5f0;
}

.collection-list,
.comment-list,
.history-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.collection-item,
.comment-item,
.history-item {
  background: white;
  padding: 1.5rem;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: all 0.3s;
  position: relative;
  border: 1px solid #e8e4da;
}

.collection-item:hover,
.comment-item:hover,
.history-item:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 24px rgba(0, 0, 0, 0.15);
}

.remove-btn,
.delete-btn {
  position: absolute;
  top: 1rem;
  right: 1rem;
  padding: 0.25rem 0.5rem;
  background: #a1887f;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 0.8rem;
  transition: background 0.3s;
}

.remove-btn:hover,
.delete-btn:hover {
  background: #8d6e63;
}

.comment-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 0.5rem;
}

.poem-title {
  color: #8b7355;
  cursor: pointer;
  font-weight: bold;
}

.poem-title:hover {
  text-decoration: underline;
}

.comment-time,
.view-time {
  color: #a1887f;
  font-size: 0.9rem;
}

.empty-state {
  text-align: center;
  padding: 3rem;
  color: #a1887f;
  background: white;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  border: 1px solid #e8e4da;
}
</style>