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
    
    <div class="poem-grid">
      <div v-for="poem in filteredPoems" :key="poem.id" class="poem-item" @click="viewPoem(poem.id)">
        <div class="poem-image" v-if="poem.image">
          <img :src="poem.image" :alt="poem.title" class="poem-img">
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
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()

// 诗词数据
const poems = ref([
  {
    id: 1,
    title: '静夜思',
    author: '李白',
    dynasty: '唐代',
    content: '床前明月光，疑是地上霜。\n举头望明月，低头思故乡。',
    image: '/images/poem1.jpg'
  },
  {
    id: 2,
    title: '春晓',
    author: '孟浩然',
    dynasty: '唐代',
    content: '春眠不觉晓，处处闻啼鸟。\n夜来风雨声，花落知多少。',
    image: '/images/poem2.jpg'
  },
  {
    id: 3,
    title: '登鹳雀楼',
    author: '王之涣',
    dynasty: '唐代',
    content: '白日依山尽，黄河入海流。\n欲穷千里目，更上一层楼。',
    image: '/images/poem3.jpg'
  },
  {
    id: 4,
    title: '相思',
    author: '王维',
    dynasty: '唐代',
    content: '红豆生南国，春来发几枝。\n愿君多采撷，此物最相思。',
    image: '/images/poem4.jpg'
  },
  {
    id: 5,
    title: '江雪',
    author: '柳宗元',
    dynasty: '唐代',
    content: '千山鸟飞绝，万径人踪灭。\n孤舟蓑笠翁，独钓寒江雪。',
    image: '/images/poem5.jpg'
  },
  {
    id: 6,
    title: '望庐山瀑布',
    author: '李白',
    dynasty: '唐代',
    content: '日照香炉生紫烟，遥看瀑布挂前川。\n飞流直下三千尺，疑是银河落九天。',
    image: '/images/poem6.jpg'
  },
  {
    id: 7,
    title: '悯农',
    author: '李绅',
    dynasty: '唐代',
    content: '锄禾日当午，汗滴禾下土。\n谁知盘中餐，粒粒皆辛苦。',
    image: '/images/poem7.jpg'
  },
  {
    id: 8,
    title: '清明',
    author: '杜牧',
    dynasty: '唐代',
    content: '清明时节雨纷纷，路上行人欲断魂。\n借问酒家何处有，牧童遥指杏花村。',
    image: '/images/poem8.jpg'
  },
  {
    id: 9,
    title: '黄鹤楼送孟浩然之广陵',
    author: '李白',
    dynasty: '唐代',
    content: '故人西辞黄鹤楼，烟花三月下扬州。\n孤帆远影碧空尽，唯见长江天际流。',
    image: '/images/poem9.jpg'
  },
  {
    id: 10,
    title: '枫桥夜泊',
    author: '张继',
    dynasty: '唐代',
    content: '月落乌啼霜满天，江枫渔火对愁眠。\n姑苏城外寒山寺，夜半钟声到客船。',
    image: '/images/poem10.jpg'
  },
  {
    id: 11,
    title: '游子吟',
    author: '孟郊',
    dynasty: '唐代',
    content: '慈母手中线，游子身上衣。\n临行密密缝，意恐迟迟归。\n谁言寸草心，报得三春晖。',
    image: '/images/poem11.jpg'
  },
  {
    id: 12,
    title: '望岳',
    author: '杜甫',
    dynasty: '唐代',
    content: '岱宗夫如何？齐鲁青未了。\n造化钟神秀，阴阳割昏晓。\n荡胸生曾云，决眦入归鸟。\n会当凌绝顶，一览众山小。',
    image: '/images/poem12.jpg'
  },
  {
    id: 13,
    title: '水调歌头·明月几时有',
    author: '苏轼',
    dynasty: '宋代',
    content: '明月几时有？把酒问青天。\n不知天上宫阙，今夕是何年。\n我欲乘风归去，又恐琼楼玉宇，高处不胜寒。\n起舞弄清影，何似在人间。',
    image: '/images/poem13.jpg'
  },
  {
    id: 14,
    title: '声声慢·寻寻觅觅',
    author: '李清照',
    dynasty: '宋代',
    content: '寻寻觅觅，冷冷清清，凄凄惨惨戚戚。\n乍暖还寒时候，最难将息。\n三杯两盏淡酒，怎敌他、晚来风急？\n雁过也，正伤心，却是旧时相识。',
    image: '/images/poem14.jpg'
  },
  {
    id: 15,
    title: '青玉案·元夕',
    author: '辛弃疾',
    dynasty: '宋代',
    content: '东风夜放花千树，更吹落、星如雨。\n宝马雕车香满路。\n凤箫声动，玉壶光转，一夜鱼龙舞。',
    image: '/images/poem15.jpg'
  },
  {
    id: 16,
    title: '天净沙·秋思',
    author: '马致远',
    dynasty: '元代',
    content: '枯藤老树昏鸦，小桥流水人家，古道西风瘦马。\n夕阳西下，断肠人在天涯。',
    image: '/images/poem16.jpg'
  },
  {
    id: 17,
    title: '石灰吟',
    author: '于谦',
    dynasty: '明代',
    content: '千锤万凿出深山，烈火焚烧若等闲。\n粉骨碎身浑不怕，要留清白在人间。',
    image: '/images/poem17.jpg'
  },
  {
    id: 18,
    title: '己亥杂诗',
    author: '龚自珍',
    dynasty: '清代',
    content: '九州生气恃风雷，万马齐喑究可哀。\n我劝天公重抖擞，不拘一格降人才。',
    image: '/images/poem18.jpg'
  }
])

const selectedDynasty = ref('')
const selectedAuthor = ref('')

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
  font-family: 'Microsoft YaHei', sans-serif;
  background: #f8f5f0;
  min-height: calc(100vh - 120px);
  padding: 2rem 0;
}

.page-header {
  background: white;
  padding: 1.5rem 0;
  margin-bottom: 2rem;
  border-bottom: 1px solid #e8e4da;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
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
  color: #5d4037;
  margin: 0;
  font-size: 1.8rem;
  font-weight: bold;
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

.poem-grid {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
  gap: 1.5rem;
}

.poem-item {
  background: white;
  padding: 1.5rem;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: all 0.3s;
  border: 1px solid #f0f0f0;
  position: relative;
  overflow: hidden;
}

.poem-item:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.15);
  border-color: #8b7355;
}

.poem-image {
  height: 120px;
  background: linear-gradient(135deg, #f0ebe2 0%, #e8e4da 100%);
  margin: -1.5rem -1.5rem 1rem -1.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}

.poem-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.poem-title {
  color: #5d4037;
  margin-bottom: 0.5rem;
  font-size: 1.2rem;
  font-weight: 600;
}

.poem-meta {
  color: #8b7355;
  font-size: 0.9rem;
  margin-bottom: 1rem;
}

.poem-content {
  white-space: pre-line;
  line-height: 1.8;
  color: #666;
  font-family: 'SimSun', serif;
  font-size: 0.95rem;
  max-height: 120px;
  overflow: hidden;
  display: -webkit-box;
  -webkit-line-clamp: 4;
  -webkit-box-orient: vertical;
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