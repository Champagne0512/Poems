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
  background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="50" cy="50" r="1" fill="%23ffffff" opacity="0.1"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
  pointer-events: none;
}

.profile-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
  position: relative;
  z-index: 1;
}

.profile-header {
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  padding: 3rem 2rem;
  border-radius: 0 0 30px 30px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  margin-bottom: 0;
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-top: none;
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
  color: #5D4037;
  font-size: 2.5rem;
  font-weight: 700;
  text-shadow: 2px 2px 4px rgba(139, 115, 85, 0.3);
  letter-spacing: 2px;
}

.user-bio {
  color: #4a5568;
  margin-bottom: 1rem;
  font-size: 1.1rem;
  line-height: 1.6;
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
  font-size: 2rem;
  font-weight: bold;
  color: #4facfe;
}

.stat-label {
  font-size: 1rem;
  color: #4a5568;
  font-weight: 500;
}

.tabs {
  display: flex;
  border-bottom: 1px solid rgba(255, 255, 255, 0.3);
  margin: 3rem 0 2rem 0;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  border-radius: 15px;
  padding: 0.5rem;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

.tab {
  padding: 1rem 2rem;
  background: none;
  border: none;
  cursor: pointer;
  border-radius: 10px;
  transition: all 0.3s;
  color: #4a5568;
  font-weight: 500;
  flex: 1;
}

.tab.active {
  background: linear-gradient(135deg, #8B7355, #A1887F);
  color: white;
  font-weight: 600;
  box-shadow: 0 4px 15px rgba(139, 115, 85, 0.3);
}

.tab:hover {
  background: rgba(79, 172, 254, 0.1);
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
  background: rgba(255, 255, 255, 0.98);
  backdrop-filter: blur(20px);
  padding: 2rem;
  border-radius: 15px;
  box-shadow: 
    0 4px 20px rgba(139, 115, 85, 0.15),
    inset 0 1px 0 rgba(255, 255, 255, 0.8);
  cursor: pointer;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  border: 1px solid rgba(139, 115, 85, 0.1);
  margin-bottom: 1.5rem;
}

.collection-item:hover,
.comment-item:hover,
.history-item:hover {
  transform: translateY(-8px) scale(1.02);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
}

.remove-btn,
.delete-btn {
  position: absolute;
  top: 1.5rem;
  right: 1.5rem;
  padding: 0.5rem 1rem;
  background: linear-gradient(135deg, #8B7355, #A1887F);
  color: white;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-size: 0.9rem;
  font-weight: 500;
  transition: all 0.3s;
  box-shadow: 0 2px 10px rgba(139, 115, 85, 0.3);
  font-family: 'STKaiti', 'KaiTi', serif;
}

.remove-btn:hover,
.delete-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 15px rgba(79, 172, 254, 0.4);
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
  padding: 4rem 2rem;
  color: #4a5568;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  border-radius: 20px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
}
</style>