# 诗词赏析网站

基于Vue 3 + Supabase构建的现代诗词赏析网站。

## 功能特性

- 🎨 古风设计风格，统一页面布局
- 📚 诗词浏览、搜索、收藏功能
- 👤 用户个人中心（收藏、评论、浏览历史）
- 🔍 智能搜索和筛选功能
- 📱 响应式设计，支持移动端

## 技术栈

- **前端框架**: Vue 3 + Composition API
- **状态管理**: Pinia
- **路由**: Vue Router 4
- **后端服务**: Supabase
- **构建工具**: Vite
- **样式**: CSS3 + 变量系统

## 项目结构

```
src/
├── components/          # 公共组件
├── views/              # 页面组件
│   ├── Home.vue        # 首页
│   ├── Poems.vue       # 诗词列表页
│   ├── PoemDetail.vue  # 诗词详情页
│   ├── Search.vue      # 搜索页
│   └── Profile.vue     # 个人中心
├── stores/             # 状态管理
│   └── poemStore.js    # 诗词数据管理
├── utils/              # 工具函数
│   └── supabase.js     # Supabase配置
├── style.css           # 全局样式
└── main.js             # 应用入口
```

## 快速开始

### 1. 安装依赖

```bash
npm install
```

### 2. 配置环境变量

复制 `.env.example` 文件为 `.env`，并填入你的Supabase项目配置：

```bash
cp .env.example .env
```

编辑 `.env` 文件：

```env
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key-here
```

### 3. 启动开发服务器

```bash
npm run dev
```

访问 http://localhost:3000 查看网站。

### 4. 构建生产版本

```bash
npm run build
```

## 页面功能

### 首页 (Home)
- 展示精选诗词
- 热门诗词排行
- 快速导航入口

### 诗词列表 (Poems)
- 浏览所有诗词
- 按朝代筛选
- 分页加载

### 诗词详情 (PoemDetail)
- 完整诗词内容
- 诗词赏析
- 评论功能
- 收藏功能

### 搜索页 (Search)
- 智能搜索诗词
- 热门搜索标签
- 实时搜索建议

### 个人中心 (Profile)
- 我的收藏
- 我的评论
- 浏览历史
- 用户统计

## 设计特色

### 古风设计
- 使用古风字体（马善政、华文行楷、宋体）
- 传统色彩搭配（赭石色、米色、深棕色）
- 毛玻璃效果和渐变背景
- 卡片悬浮动画效果

### 响应式布局
- 移动端友好设计
- 自适应屏幕尺寸
- 触摸友好的交互

## Supabase数据库结构

项目需要以下数据表：

```sql
-- 诗词表
CREATE TABLE poems (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  author TEXT NOT NULL,
  dynasty TEXT NOT NULL,
  content TEXT NOT NULL,
  analysis TEXT,
  favorite_count INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 收藏表
CREATE TABLE favorites (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  poem_id UUID NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 评论表
CREATE TABLE comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  poem_id UUID NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 浏览历史表
CREATE TABLE browse_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  poem_id UUID NOT NULL,
  viewed_at TIMESTAMP DEFAULT NOW()
);
```

## 开发说明

### 添加新功能
1. 在对应的页面组件中添加功能
2. 在 `poemStore.js` 中添加状态管理逻辑
3. 在 `supabase.js` 中添加API方法
4. 更新路由配置（如需要）

### 样式开发
- 使用CSS变量系统保持设计一致性
- 遵循古风设计规范
- 确保响应式兼容性

## 部署

### Vercel部署
1. 连接GitHub仓库到Vercel
2. 配置环境变量
3. 自动部署

### Netlify部署
1. 连接GitHub仓库到Netlify
2. 配置构建命令和环境变量
3. 部署网站

## 贡献指南

欢迎提交Issue和Pull Request来改进项目。

## 许可证

MIT License