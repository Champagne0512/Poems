<template>
  <div class="home">
    <!-- 现代化导航栏 -->
    <nav class="modern-nav">
      <div class="nav-container">
        <div class="nav-brand">
          <div class="logo-wrapper">
            <span class="logo-icon">📚</span>
            <h1 class="logo">诗词雅集</h1>
          </div>
        </div>
        <div class="nav-menu">
          <router-link to="/" class="nav-link active">首页</router-link>
          <router-link to="/poems" class="nav-link">诗词浏览</router-link>
          <router-link to="/search" class="nav-link">搜索</router-link>
          <router-link to="/profile" class="nav-link">个人中心</router-link>
        </div>
        <div class="nav-actions">
          <div class="search-wrapper">
            <input type="text" placeholder="搜索诗词..." class="search-input">
            <button class="search-btn">
              <span class="search-icon">🔍</span>
            </button>
          </div>
          <div class="auth-buttons">
            <button class="btn-login">登录</button>
            <button class="btn-register">注册</button>
          </div>
        </div>
      </div>
    </nav>

    <!-- 现代化英雄区域 -->
    <section class="modern-hero">
      <div class="hero-background">
        <div class="floating-elements">
          <div class="floating-element element-1">🌸</div>
          <div class="floating-element element-2">📜</div>
          <div class="floating-element element-3">🎭</div>
          <div class="floating-element element-4">🖋️</div>
        </div>
      </div>
      <div class="hero-content">
        <div class="hero-text">
          <h2 class="hero-title">
            <span class="title-line">探索千年</span>
            <span class="title-line highlight">诗词之美</span>
          </h2>
          <p class="hero-subtitle">沉浸式体验中华诗词文化的博大精深</p>
          <div class="hero-stats">
            <div class="stat-item">
              <span class="stat-number">5000+</span>
              <span class="stat-label">首诗词</span>
            </div>
            <div class="stat-item">
              <span class="stat-number">300+</span>
              <span class="stat-label">位诗人</span>
            </div>
            <div class="stat-item">
              <span class="stat-number">10+</span>
              <span class="stat-label">个朝代</span>
            </div>
          </div>
        </div>
        <div class="hero-search">
          <div class="search-container">
            <input type="text" placeholder="搜索诗词、作者或朝代..." class="modern-search-input">
            <button class="modern-search-btn">
              <span>开始探索</span>
              <span class="arrow">→</span>
            </button>
          </div>
        </div>
      </div>
    </section>

    <!-- 精选诗词卡片区 -->
    <section class="featured-section">
      <div class="container">
        <div class="section-header">
          <h3 class="section-title">精选诗词</h3>
          <p class="section-subtitle">经典诗词，永恒传颂</p>
        </div>
        <div class="featured-grid">
          <div v-for="(poem, index) in featuredPoems" :key="poem.id" 
               class="featured-card" 
               :style="{ animationDelay: `${index * 0.1}s` }"
               @click="viewPoem(poem.id)">
            <div class="card-gradient"></div>
            <div class="card-content">
              <div class="poem-header">
                <h4 class="poem-title">{{ poem.title }}</h4>
                <span class="poem-badge">{{ poem.dynasty }}</span>
              </div>
              <p class="poem-author">{{ poem.author }}</p>
              <div class="poem-excerpt">
                {{ poem.excerpt }}
              </div>
              <div class="card-footer">
                <span class="read-more">阅读全文 →</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 动态分类展示 -->
    <section class="categories-section">
      <div class="container">
        <div class="section-header">
          <h3 class="section-title">诗词分类</h3>
          <p class="section-subtitle">按主题浏览经典诗词</p>
        </div>
        <div class="categories-grid">
          <div v-for="category in categories" :key="category.id" 
               class="category-card" 
               @mouseenter="activateCategory(category.id)"
               @mouseleave="deactivateCategory">
            <div class="category-content">
              <div class="category-icon">{{ category.icon }}</div>
              <h4 class="category-name">{{ category.name }}</h4>
              <p class="category-count">{{ category.count }}首</p>
            </div>
            <div class="category-hover">
              <span>探索更多</span>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 热门诗词排行榜 -->
    <section class="popular-section">
      <div class="container">
        <div class="section-header">
          <h3 class="section-title">热门诗词</h3>
          <p class="section-subtitle">最受读者喜爱的经典作品</p>
        </div>
        <div class="popular-list">
          <div v-for="poem in popularPoems" :key="poem.id" 
               class="popular-item" 
               @click="viewPoem(poem.id)">
            <div class="rank-badge">
              <span class="rank-number">#{{ poem.rank }}</span>
            </div>
            <div class="poem-info">
              <h4 class="poem-title">{{ poem.title }}</h4>
              <p class="poem-author">{{ poem.author }}</p>
            </div>
            <div class="popular-stats">
              <div class="stat">
                <span class="stat-icon">👁️</span>
                <span class="stat-value">{{ poem.views }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 现代化页脚 -->
    <footer class="modern-footer">
      <div class="container">
        <div class="footer-content">
          <div class="footer-main">
            <div class="footer-brand">
              <span class="footer-logo-icon">📚</span>
              <h3>诗词雅集</h3>
              <p>传承中华文化，品味诗词之美</p>
            </div>
            <div class="footer-links">
              <div class="link-group">
                <h4>快速导航</h4>
                <a href="#">唐诗精选</a>
                <a href="#">宋词欣赏</a>
                <a href="#">元曲经典</a>
                <a href="#">明清诗词</a>
              </div>
              <div class="link-group">
                <h4>诗人名录</h4>
                <a href="#">李白</a>
                <a href="#">杜甫</a>
                <a href="#">苏轼</a>
                <a href="#">李清照</a>
              </div>
              <div class="link-group">
                <h4>关于我们</h4>
                <a href="#">团队介绍</a>
                <a href="#">联系我们</a>
                <a href="#">加入我们</a>
                <a href="#">帮助中心</a>
              </div>
            </div>
          </div>
          <div class="footer-bottom">
            <p>&copy; 2024 诗词雅集 - 让诗词之美触手可及</p>
            <div class="social-links">
              <a href="#" class="social-link">微信</a>
              <a href="#" class="social-link">微博</a>
              <a href="#" class="social-link">知乎</a>
            </div>
          </div>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const activeCategory = ref(null)

// 精选诗词数据
const featuredPoems = ref([
  {
    id: 1,
    title: '静夜思',
    author: '李白',
    dynasty: '唐代',
    excerpt: '床前明月光，疑是地上霜。举头望明月，低头思故乡。'
  },
  {
    id: 2,
    title: '春晓',
    author: '孟浩然',
    dynasty: '唐代',
    excerpt: '春眠不觉晓，处处闻啼鸟。夜来风雨声，花落知多少。'
  },
  {
    id: 3,
    title: '登鹳雀楼',
    author: '王之涣',
    dynasty: '唐代',
    excerpt: '白日依山尽，黄河入海流。欲穷千里目，更上一层楼。'
  },
  {
    id: 4,
    title: '相思',
    author: '王维',
    dynasty: '唐代',
    excerpt: '红豆生南国，春来发几枝。愿君多采撷，此物最相思。'
  },
  {
    id: 5,
    title: '江雪',
    author: '柳宗元',
    dynasty: '唐代',
    excerpt: '千山鸟飞绝，万径人踪灭。孤舟蓑笠翁，独钓寒江雪。'
  },
  {
    id: 6,
    title: '望庐山瀑布',
    author: '李白',
    dynasty: '唐代',
    excerpt: '日照香炉生紫烟，遥看瀑布挂前川。飞流直下三千尺，疑是银河落九天。'
  }
])

// 分类数据
const categories = ref([
  { id: 1, name: '唐诗', icon: '📜', count: 300 },
  { id: 2, name: '宋词', icon: '🌸', count: 250 },
  { id: 3, name: '元曲', icon: '🎭', count: 150 },
  { id: 4, name: '山水', icon: '🏞️', count: 120 },
  { id: 5, name: '离别', icon: '👋', count: 80 },
  { id: 6, name: '爱情', icon: '💕', count: 90 }
])

// 热门诗词数据
const popularPoems = ref([
  { id: 1, rank: 1, title: '静夜思', author: '李白', views: 12560 },
  { id: 2, rank: 2, title: '春晓', author: '孟浩然', views: 9870 },
  { id: 3, rank: 3, title: '登鹳雀楼', author: '王之涣', views: 8560 },
  { id: 4, rank: 4, title: '相思', author: '王维', views: 7430 },
  { id: 5, rank: 5, title: '江雪', author: '柳宗元', views: 6890 },
  { id: 6, rank: 6, title: '悯农', author: '李绅', views: 5670 }
])

// 页面加载动画
onMounted(() => {
  // 添加页面加载动画
  setTimeout(() => {
    document.querySelector('.modern-hero').classList.add('loaded')
  }, 100)
})

const viewPoem = (poemId) => {
  router.push(`/poem/${poemId}`)
}

const activateCategory = (categoryId) => {
  activeCategory.value = categoryId
}

const deactivateCategory = () => {
  activeCategory.value = null
}
</script>

<style scoped>
.home {
  font-family: 'PingFang SC', 'Microsoft YaHei', sans-serif;
  background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
  min-height: 100vh;
}

/* 现代化导航栏 */
.modern-nav {
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
  position: sticky;
  top: 0;
  z-index: 1000;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

.nav-container {
  max-width: 1400px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1rem 2rem;
}

.logo-wrapper {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.logo-icon {
  font-size: 2rem;
  animation: float 3s ease-in-out infinite;
}

.logo {
  color: #2d3748;
  font-size: 1.8rem;
  font-weight: 700;
  margin: 0;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.nav-menu {
  display: flex;
  gap: 2rem;
}

.nav-link {
  color: #4a5568;
  text-decoration: none;
  font-weight: 500;
  padding: 0.5rem 1rem;
  border-radius: 8px;
  transition: all 0.3s ease;
  position: relative;
}

.nav-link:hover,
.nav-link.active {
  color: #667eea;
  background: rgba(102, 126, 234, 0.1);
}

.nav-link.active::after {
  content: '';
  position: absolute;
  bottom: -8px;
  left: 50%;
  transform: translateX(-50%);
  width: 6px;
  height: 6px;
  background: #667eea;
  border-radius: 50%;
}

.nav-actions {
  display: flex;
  align-items: center;
  gap: 1.5rem;
}

.search-wrapper {
  position: relative;
  display: flex;
  align-items: center;
}

.search-input {
  padding: 0.75rem 3rem 0.75rem 1rem;
  border: 1px solid #e2e8f0;
  border-radius: 25px;
  background: #f7fafc;
  width: 250px;
  font-size: 0.9rem;
  transition: all 0.3s ease;
}

.search-input:focus {
  outline: none;
  border-color: #667eea;
  box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
}

.search-btn {
  position: absolute;
  right: 8px;
  background: #667eea;
  border: none;
  border-radius: 50%;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.3s ease;
}

.search-btn:hover {
  background: #5a67d8;
  transform: scale(1.1);
}

.auth-buttons {
  display: flex;
  gap: 0.75rem;
}

.btn-login,
.btn-register {
  padding: 0.75rem 1.5rem;
  border: 2px solid #667eea;
  border-radius: 25px;
  background: transparent;
  color: #667eea;
  cursor: pointer;
  font-weight: 600;
  transition: all 0.3s ease;
}

.btn-register {
  background: #667eea;
  color: white;
}

.btn-login:hover {
  background: #667eea;
  color: white;
  transform: translateY(-2px);
}

.btn-register:hover {
  background: #5a67d8;
  transform: translateY(-2px);
}

/* 现代化英雄区域 */
.modern-hero {
  position: relative;
  min-height: 80vh;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}

.hero-background {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  z-index: -1;
}

.floating-elements {
  position: absolute;
  width: 100%;
  height: 100%;
}

.floating-element {
  position: absolute;
  font-size: 3rem;
  opacity: 0.3;
  animation: float 6s ease-in-out infinite;
}

.element-1 { top: 20%; left: 10%; animation-delay: 0s; }
.element-2 { top: 60%; right: 15%; animation-delay: 2s; }
.element-3 { bottom: 30%; left: 20%; animation-delay: 4s; }
.element-4 { top: 40%; right: 25%; animation-delay: 1s; }

.hero-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 4rem;
  align-items: center;
}

.hero-text {
  color: rgba(255, 255, 255, 0.98);
}

.hero-title {
  font-size: 4rem;
  font-weight: 800;
  line-height: 1.1;
  margin-bottom: 1.5rem;
  text-shadow: 0 4px 30px rgba(0, 0, 0, 0.8),
               0 0 80px rgba(255, 215, 0, 0.3),
               0 0 120px rgba(70, 130, 180, 0.2);
}

.title-line {
  display: block;
  animation: textGlow 3s ease-in-out infinite alternate;
  position: relative;
  color: rgba(255, 255, 255, 0.95);
}

.title-line:first-child {
  animation-delay: 0s;
}

.title-line.highlight {
  background: linear-gradient(135deg, #ffd700 0%, #ff8c00 25%, #ff4500 50%, #da70d6 75%, #00bfff 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-size: 400% 400%;
  animation: gradientShift 8s ease-in-out infinite, textGlow 3s ease-in-out infinite alternate;
  animation-delay: 0s, 1s;
  text-shadow: 0 0 60px rgba(255, 215, 0, 0.7),
               0 0 120px rgba(255, 140, 0, 0.5),
               0 0 180px rgba(218, 112, 214, 0.3);
  position: relative;
  z-index: 2;
}

.title-line.highlight::before {
  content: '';
  position: absolute;
  top: -8px;
  left: -15px;
  right: -15px;
  bottom: -8px;
  background: linear-gradient(135deg, 
    rgba(255, 215, 0, 0.3), 
    rgba(255, 140, 0, 0.3), 
    rgba(255, 69, 0, 0.3),
    rgba(218, 112, 214, 0.3),
    rgba(0, 191, 255, 0.3));
  border-radius: 15px;
  z-index: -1;
  filter: blur(25px);
  animation: glowPulse 6s ease-in-out infinite;
}

.hero-subtitle {
  font-size: 1.3rem;
  margin-bottom: 2rem;
  line-height: 1.6;
  text-shadow: 0 2px 20px rgba(0, 0, 0, 0.7),
               0 0 60px rgba(255, 255, 255, 0.2);
  animation: fadeInUp 1s ease-out 0.5s both;
  font-weight: 500;
  letter-spacing: 0.5px;
  color: rgba(255, 255, 255, 0.9);
}

.hero-stats {
  display: flex;
  gap: 2rem;
  margin-bottom: 2rem;
  animation: fadeInUp 1s ease-out 0.8s both;
  position: relative;
  z-index: 2;
}

.stat-item {
  text-align: center;
  background: rgba(255, 255, 255, 0.15);
  backdrop-filter: blur(20px);
  padding: 1.5rem 2rem;
  border-radius: 20px;
  border: 1px solid rgba(255, 255, 255, 0.3);
  transition: all 0.4s ease;
  position: relative;
  overflow: hidden;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
}

.stat-item::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
  transition: left 0.6s ease;
}

.stat-item:hover::before {
  left: 100%;
}

.stat-item:hover {
  transform: translateY(-8px) scale(1.05);
  background: rgba(255, 255, 255, 0.25);
  box-shadow: 0 15px 40px rgba(0, 0, 0, 0.3),
              inset 0 1px 0 rgba(255, 255, 255, 0.4);
}

.stat-number {
  display: block;
  font-size: 2.8rem;
  font-weight: 800;
  margin-bottom: 0.5rem;
  background: linear-gradient(135deg, #ffffff 0%, #ffd700 25%, #ff8c00 50%, #ffffff 75%, #00bfff 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-size: 200% 200%;
  animation: gradientShift 6s ease-in-out infinite;
  text-shadow: 0 4px 20px rgba(0, 0, 0, 0.8),
               0 0 60px rgba(255, 215, 0, 0.4),
               0 0 100px rgba(0, 191, 255, 0.2);
  filter: drop-shadow(0 3px 8px rgba(0, 0, 0, 0.5));
  letter-spacing: -1px;
}

.stat-label {
  font-size: 0.95rem;
  font-weight: 600;
  text-shadow: 0 1px 8px rgba(0, 0, 0, 0.6);
  letter-spacing: 0.5px;
  color: rgba(255, 255, 255, 0.9);
}

/* 深色背景板效果 */
.hero-background {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, #0c0c0c 0%, #1a1a2e 25%, #16213e 50%, #0f3460 75%, #533483 100%);
  z-index: -1;
  overflow: hidden;
}

.hero-background::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: 
    radial-gradient(circle at 20% 20%, rgba(83, 52, 131, 0.4) 0%, transparent 50%),
    radial-gradient(circle at 80% 80%, rgba(31, 97, 141, 0.3) 0%, transparent 50%),
    radial-gradient(circle at 40% 60%, rgba(22, 33, 62, 0.5) 0%, transparent 50%),
    radial-gradient(circle at 60% 30%, rgba(26, 26, 46, 0.6) 0%, transparent 50%);
  animation: backgroundShift 10s ease-in-out infinite;
}

.hero-background::after {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: 
    linear-gradient(45deg, transparent 40%, rgba(255, 255, 255, 0.05) 50%, transparent 60%),
    linear-gradient(-45deg, transparent 30%, rgba(255, 255, 255, 0.03) 40%, transparent 50%);
  animation: shimmer 4s ease-in-out infinite;
}

.hero-background-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: 
    radial-gradient(circle at center, rgba(255, 255, 255, 0.02) 0%, transparent 70%),
    repeating-linear-gradient(0deg, transparent 0%, rgba(255, 255, 255, 0.01) 1px, transparent 2px);
  animation: subtlePulse 8s ease-in-out infinite;
}

.floating-elements {
  position: absolute;
  width: 100%;
  height: 100%;
  z-index: 1;
}

.floating-element {
  position: absolute;
  font-size: 4rem;
  opacity: 0.4;
  animation: float 6s ease-in-out infinite;
  filter: drop-shadow(0 0 10px rgba(255, 255, 255, 0.5));
  z-index: 1;
}

.element-1 { top: 20%; left: 10%; animation-delay: 0s; }
.element-2 { top: 60%; right: 15%; animation-delay: 2s; }
.element-3 { bottom: 30%; left: 20%; animation-delay: 4s; }
.element-4 { top: 40%; right: 25%; animation-delay: 1s; }
.element-5 { top: 10%; right: 30%; animation-delay: 3s; font-size: 3rem; }
.element-6 { bottom: 20%; right: 10%; animation-delay: 5s; font-size: 3.5rem; }

.hero-stats {
  display: flex;
  gap: 2rem;
  margin-bottom: 2rem;
}

.stat-item {
  text-align: center;
}

.stat-number {
  display: block;
  font-size: 2.5rem;
  font-weight: 700;
  margin-bottom: 0.5rem;
}

.stat-label {
  font-size: 0.9rem;
  opacity: 0.8;
}

.hero-search {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border-radius: 20px;
  padding: 2rem;
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.search-container {
  display: flex;
  gap: 1rem;
}

.modern-search-input {
  flex: 1;
  padding: 1rem 1.5rem;
  border: none;
  border-radius: 15px;
  background: rgba(255, 255, 255, 0.9);
  font-size: 1rem;
  transition: all 0.3s ease;
}

.modern-search-input:focus {
  outline: none;
  box-shadow: 0 0 0 3px rgba(255, 255, 255, 0.3);
}

.modern-search-btn {
  padding: 1rem 2rem;
  background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%);
  color: white;
  border: none;
  border-radius: 15px;
  font-weight: 600;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  transition: all 0.3s ease;
}

.modern-search-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 20px rgba(255, 107, 107, 0.3);
}

.arrow {
  font-size: 1.2rem;
}

/* 精选诗词区域 */
.featured-section {
  padding: 6rem 0;
  background: white;
}

.container {
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 2rem;
}

.section-header {
  text-align: center;
  margin-bottom: 4rem;
}

.section-title {
  font-size: 3rem;
  font-weight: 800;
  color: #2d3748;
  margin-bottom: 1rem;
}

.section-subtitle {
  font-size: 1.2rem;
  color: #718096;
}

.featured-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
  gap: 2rem;
}

.featured-card {
  background: white;
  border-radius: 20px;
  overflow: hidden;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: all 0.3s ease;
  position: relative;
  animation: slideUp 0.6s ease-out forwards;
  opacity: 0;
  transform: translateY(30px);
}

.featured-card:hover {
  transform: translateY(-10px);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
}

.card-gradient {
  height: 120px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.card-content {
  padding: 2rem;
}

.poem-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
}

.poem-title {
  color: #2d3748;
  font-size: 1.4rem;
  font-weight: 700;
  margin: 0;
}

.poem-badge {
  background: #e2e8f0;
  color: #4a5568;
  padding: 0.25rem 0.75rem;
  border-radius: 15px;
  font-size: 0.8rem;
  font-weight: 600;
}

.poem-author {
  color: #718096;
  font-size: 1rem;
  margin-bottom: 1.5rem;
}

.poem-excerpt {
  color: #4a5568;
  line-height: 1.8;
  font-style: italic;
  margin-bottom: 1.5rem;
}

.card-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.read-more {
  color: #667eea;
  font-weight: 600;
  transition: all 0.3s ease;
}

.featured-card:hover .read-more {
  transform: translateX(5px);
}

/* 分类展示区域 */
.categories-section {
  padding: 6rem 0;
  background: #f7fafc;
}

.categories-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1.5rem;
}

.category-card {
  background: white;
  border-radius: 15px;
  padding: 2rem;
  text-align: center;
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
  cursor: pointer;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.category-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 15px 30px rgba(0, 0, 0, 0.12);
}

.category-content {
  position: relative;
  z-index: 2;
}

.category-icon {
  font-size: 3.5rem;
  margin-bottom: 1rem;
  display: block;
}

.category-name {
  color: #2d3748;
  font-size: 1.3rem;
  font-weight: 700;
  margin-bottom: 0.5rem;
}

.category-count {
  color: #718096;
  font-size: 0.9rem;
}

.category-hover {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: all 0.3s ease;
  transform: translateY(100%);
}

.category-card:hover .category-hover {
  opacity: 1;
  transform: translateY(0);
}

.category-hover span {
  color: white;
  font-weight: 600;
  font-size: 1.1rem;
}

/* 热门诗词区域 */
.popular-section {
  padding: 6rem 0;
  background: white;
}

.popular-list {
  max-width: 800px;
  margin: 0 auto;
}

.popular-item {
  display: flex;
  align-items: center;
  padding: 1.5rem;
  background: white;
  border-radius: 15px;
  margin-bottom: 1rem;
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
  cursor: pointer;
  transition: all 0.3s ease;
}

.popular-item:hover {
  transform: translateX(10px);
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.12);
}

.rank-badge {
  background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%);
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 20px;
  margin-right: 1.5rem;
}

.rank-number {
  font-weight: 700;
  font-size: 1.1rem;
}

.poem-info {
  flex: 1;
}

.poem-title {
  color: #2d3748;
  font-size: 1.2rem;
  font-weight: 600;
  margin-bottom: 0.25rem;
}

.poem-author {
  color: #718096;
  font-size: 0.9rem;
}

.popular-stats {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.stat {
  display: flex;
  align-items: center;
  gap: 0.25rem;
  color: #718096;
  font-size: 0.9rem;
}

.stat-icon {
  font-size: 1rem;
}

/* 现代化页脚 */
.modern-footer {
  background: linear-gradient(135deg, #2d3748 0%, #1a202c 100%);
  color: white;
  padding: 4rem 0 2rem;
}

.footer-content {
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 2rem;
}

.footer-main {
  display: grid;
  grid-template-columns: 1fr 2fr;
  gap: 4rem;
  margin-bottom: 3rem;
}

.footer-brand {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.footer-logo-icon {
  font-size: 3rem;
}

.footer-brand h3 {
  font-size: 2rem;
  font-weight: 700;
  margin: 0;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.footer-brand p {
  opacity: 0.8;
  line-height: 1.6;
}

.footer-links {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 2rem;
}

.link-group h4 {
  font-size: 1.1rem;
  font-weight: 600;
  margin-bottom: 1rem;
  color: #e2e8f0;
}

.link-group a {
  display: block;
  color: #a0aec0;
  text-decoration: none;
  margin-bottom: 0.5rem;
  transition: color 0.3s ease;
}

.link-group a:hover {
  color: #667eea;
}

.footer-bottom {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 2rem;
  border-top: 1px solid #4a5568;
}

.social-links {
  display: flex;
  gap: 1rem;
}

.social-link {
  color: #a0aec0;
  text-decoration: none;
  padding: 0.5rem 1rem;
  border: 1px solid #4a5568;
  border-radius: 20px;
  transition: all 0.3s ease;
}

.social-link:hover {
  color: #667eea;
  border-color: #667eea;
}

/* 动画定义 */
@keyframes float {
  0%, 100% { transform: translateY(0px); }
  50% { transform: translateY(-20px); }
}

@keyframes slideUp {
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes textGlow {
  0% {
    text-shadow: 0 0 20px rgba(255, 255, 255, 0.5),
                 0 0 40px rgba(255, 255, 255, 0.3),
                 0 0 60px rgba(255, 255, 255, 0.1);
  }
  100% {
    text-shadow: 0 0 30px rgba(255, 255, 255, 0.8),
                 0 0 60px rgba(255, 255, 255, 0.5),
                 0 0 80px rgba(255, 255, 255, 0.2);
  }
}

@keyframes gradientShift {
  0% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
  100% {
    background-position: 0% 50%;
  }
}

@keyframes fadeInUp {
  0% {
    opacity: 0;
    transform: translateY(30px);
  }
  100% {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes glowPulse {
  0%, 100% {
    opacity: 0.5;
    transform: scale(1);
  }
  50% {
    opacity: 0.8;
    transform: scale(1.05);
  }
}

@keyframes backgroundShift {
  0%, 100% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
}

@keyframes shimmer {
  0%, 100% {
    transform: translateX(-100%);
  }
  50% {
    transform: translateX(100%);
  }
}

@keyframes subtlePulse {
  0%, 100% {
    opacity: 0.3;
    transform: scale(1);
  }
  50% {
    opacity: 0.5;
    transform: scale(1.02);
  }
}

/* 响应式设计 */
@media (max-width: 1024px) {
  .hero-content {
    grid-template-columns: 1fr;
    text-align: center;
    gap: 3rem;
  }
  
  .hero-title {
    font-size: 3rem;
  }
  
  .featured-grid {
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  }
}

@media (max-width: 768px) {
  .nav-container {
    flex-direction: column;
    gap: 1rem;
    padding: 1rem;
  }
  
  .nav-menu {
    gap: 1rem;
  }
  
  .nav-actions {
    flex-direction: column;
    gap: 1rem;
  }
  
  .search-input {
    width: 200px;
  }
  
  .hero-title {
    font-size: 2.5rem;
  }
  
  .hero-stats {
    flex-direction: column;
    gap: 1rem;
  }
  
  .search-container {
    flex-direction: column;
  }
  
  .footer-main {
    grid-template-columns: 1fr;
    gap: 2rem;
  }
  
  .footer-links {
    grid-template-columns: 1fr;
    gap: 1.5rem;
  }
  
  .footer-bottom {
    flex-direction: column;
    gap: 1rem;
    text-align: center;
  }
}

@media (max-width: 480px) {
  .featured-grid {
    grid-template-columns: 1fr;
  }
  
  .categories-grid {
    grid-template-columns: 1fr;
  }
  
  .hero-title {
    font-size: 2rem;
  }
  
  .section-title {
    font-size: 2rem;
  }
}
</style>