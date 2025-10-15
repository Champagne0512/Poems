-- Supabase数据库表结构
-- 在Supabase SQL编辑器中执行这些语句

-- 诗词表
CREATE TABLE IF NOT EXISTS poems (
  id BIGSERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  author VARCHAR(100) NOT NULL,
  dynasty VARCHAR(50) NOT NULL,
  content TEXT NOT NULL,
  analysis TEXT,
  image_url VARCHAR(500) DEFAULT '/images/OIP.jpg',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 收藏表
CREATE TABLE IF NOT EXISTS favorites (
  id BIGSERIAL PRIMARY KEY,
  poem_id BIGINT REFERENCES poems(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(poem_id)
);

-- 浏览历史表
CREATE TABLE IF NOT EXISTS history (
  id BIGSERIAL PRIMARY KEY,
  poem_id BIGINT REFERENCES poems(id) ON DELETE CASCADE,
  viewed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 评论表
CREATE TABLE IF NOT EXISTS comments (
  id BIGSERIAL PRIMARY KEY,
  poem_id BIGINT REFERENCES poems(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  user_name VARCHAR(100) DEFAULT '匿名用户',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 插入示例数据
INSERT INTO poems (title, author, dynasty, content, analysis) VALUES
('静夜思', '李白', '唐代', '床前明月光，疑是地上霜。\n举头望明月，低头思故乡。', '这首诗表达了诗人对故乡的深切思念。'),
('春晓', '孟浩然', '唐代', '春眠不觉晓，处处闻啼鸟。\n夜来风雨声，花落知多少。', '描绘了春天早晨的美丽景色和诗人的感受。'),
('登鹳雀楼', '王之涣', '唐代', '白日依山尽，黄河入海流。\n欲穷千里目，更上一层楼。', '表达了诗人登高望远、积极向上的精神。'),
('相思', '王维', '唐代', '红豆生南国，春来发几枝。\n愿君多采撷，此物最相思。', '以红豆寄托相思之情，意境优美。'),
('江雪', '柳宗元', '唐代', '千山鸟飞绝，万径人踪灭。\n孤舟蓑笠翁，独钓寒江雪。', '描绘了一幅寂静的冬日江雪图。'),
('望庐山瀑布', '李白', '唐代', '日照香炉生紫烟，遥看瀑布挂前川。\n飞流直下三千尺，疑是银河落九天。', '以夸张手法描绘庐山瀑布的壮丽景色。'),
('黄鹤楼送孟浩然之广陵', '李白', '唐代', '故人西辞黄鹤楼，烟花三月下扬州。\n孤帆远影碧空尽，唯见长江天际流。', '表达了诗人对友人的深情送别。'),
('枫桥夜泊', '张继', '唐代', '月落乌啼霜满天，江枫渔火对愁眠。\n姑苏城外寒山寺，夜半钟声到客船。', '描绘了秋夜泊船时的孤寂感受。'),
('悯农', '李绅', '唐代', '锄禾日当午，汗滴禾下土。\n谁知盘中餐，粒粒皆辛苦。', '表达了诗人对农民辛勤劳动的同情。'),
('游子吟', '孟郊', '唐代', '慈母手中线，游子身上衣。\n临行密密缝，意恐迟迟归。\n谁言寸草心，报得三春晖。', '歌颂了母爱的伟大和无私。'),
('清明', '杜牧', '唐代', '清明时节雨纷纷，路上行人欲断魂。\n借问酒家何处有，牧童遥指杏花村。', '描绘了清明时节的雨景和行人的愁绪。'),
('山行', '杜牧', '唐代', '远上寒山石径斜，白云生处有人家。\n停车坐爱枫林晚，霜叶红于二月花。', '赞美了秋天山林的美丽景色。'),
('鹿柴', '王维', '唐代', '空山不见人，但闻人语响。\n返景入深林，复照青苔上。', '描绘了山林中的幽静景色。'),
('九月九日忆山东兄弟', '王维', '唐代', '独在异乡为异客，每逢佳节倍思亲。\n遥知兄弟登高处，遍插茱萸少一人。', '表达了诗人对家乡亲人的思念。'),
('望岳', '杜甫', '唐代', '岱宗夫如何？齐鲁青未了。\n造化钟神秀，阴阳割昏晓。\n荡胸生曾云，决眦入归鸟。\n会当凌绝顶，一览众山小。', '赞美了泰山的雄伟壮丽。'),
('春夜喜雨', '杜甫', '唐代', '好雨知时节，当春乃发生。\n随风潜入夜，润物细无声。\n野径云俱黑，江船火独明。\n晓看红湿处，花重锦官城。', '描绘了春雨的美好和生机。'),
('早发白帝城', '李白', '唐代', '朝辞白帝彩云间，千里江陵一日还。\n两岸猿声啼不住，轻舟已过万重山。', '表达了诗人顺流而下的畅快心情。'),
('回乡偶书', '贺知章', '唐代', '少小离家老大回，乡音无改鬓毛衰。\n儿童相见不相识，笑问客从何处来。', '描绘了诗人回乡时的感慨和变化。');

-- 启用Row Level Security (RLS)
ALTER TABLE poems ENABLE ROW LEVEL SECURITY;
ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE history ENABLE ROW LEVEL SECURITY;
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;

-- 设置RLS策略（允许所有操作）
CREATE POLICY "允许所有人访问诗词" ON poems FOR ALL USING (true);
CREATE POLICY "允许所有人管理收藏" ON favorites FOR ALL USING (true);
CREATE POLICY "允许所有人管理历史" ON history FOR ALL USING (true);
CREATE POLICY "允许所有人管理评论" ON comments FOR ALL USING (true);