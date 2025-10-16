-- 创建诗词表
CREATE TABLE IF NOT EXISTS poems (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  author TEXT NOT NULL,
  dynasty TEXT NOT NULL,
  content TEXT NOT NULL,
  analysis TEXT,
  tags TEXT[] DEFAULT '{}',
  favorite_count INTEGER DEFAULT 0,
  view_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建收藏表
CREATE TABLE IF NOT EXISTS favorites (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  poem_id UUID REFERENCES poems(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, poem_id)
);

-- 创建评论表
CREATE TABLE IF NOT EXISTS comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  poem_id UUID REFERENCES poems(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建浏览历史表
CREATE TABLE IF NOT EXISTS browse_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  poem_id UUID REFERENCES poems(id) ON DELETE CASCADE,
  viewed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建索引以提高查询性能
CREATE INDEX IF NOT EXISTS idx_poems_dynasty ON poems(dynasty);
CREATE INDEX IF NOT EXISTS idx_poems_author ON poems(author);
CREATE INDEX IF NOT EXISTS idx_poems_created_at ON poems(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_favorites_user_id ON favorites(user_id);
CREATE INDEX IF NOT EXISTS idx_favorites_poem_id ON favorites(poem_id);
CREATE INDEX IF NOT EXISTS idx_comments_poem_id ON comments(poem_id);
CREATE INDEX IF NOT EXISTS idx_comments_created_at ON comments(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_browse_history_user_id ON browse_history(user_id);
CREATE INDEX IF NOT EXISTS idx_browse_history_viewed_at ON browse_history(viewed_at DESC);

-- 启用行级安全策略
ALTER TABLE poems ENABLE ROW LEVEL SECURITY;
ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE browse_history ENABLE ROW LEVEL SECURITY;

-- 创建诗词表的策略
CREATE POLICY "诗词表公开读取" ON poems FOR SELECT USING (true);
CREATE POLICY "仅管理员可插入诗词" ON poems FOR INSERT WITH CHECK (auth.role() = 'authenticated' AND auth.jwt() ->> 'email' = 'admin@example.com');
CREATE POLICY "仅管理员可更新诗词" ON poems FOR UPDATE USING (auth.role() = 'authenticated' AND auth.jwt() ->> 'email' = 'admin@example.com');
CREATE POLICY "仅管理员可删除诗词" ON poems FOR DELETE USING (auth.role() = 'authenticated' AND auth.jwt() ->> 'email' = 'admin@example.com');

-- 创建收藏表的策略
CREATE POLICY "用户只能查看自己的收藏" ON favorites FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "用户只能添加自己的收藏" ON favorites FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "用户只能删除自己的收藏" ON favorites FOR DELETE USING (auth.uid() = user_id);

-- 创建评论表的策略
CREATE POLICY "评论公开读取" ON comments FOR SELECT USING (true);
CREATE POLICY "用户只能添加自己的评论" ON comments FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "用户只能更新自己的评论" ON comments FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "用户只能删除自己的评论" ON comments FOR DELETE USING (auth.uid() = user_id);

-- 创建浏览历史表的策略
CREATE POLICY "用户只能查看自己的浏览历史" ON browse_history FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "用户只能添加自己的浏览历史" ON browse_history FOR INSERT WITH CHECK (auth.uid() = user_id);

-- 创建更新时间的触发器函数
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 为诗词表和评论表添加更新时间触发器
CREATE TRIGGER update_poems_updated_at BEFORE UPDATE ON poems FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_comments_updated_at BEFORE UPDATE ON comments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 创建收藏数更新的触发器函数
CREATE OR REPLACE FUNCTION update_poem_favorite_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE poems SET favorite_count = favorite_count + 1 WHERE id = NEW.poem_id;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE poems SET favorite_count = favorite_count - 1 WHERE id = OLD.poem_id;
    END IF;
    RETURN NULL;
END;
$$ language 'plpgsql';

-- 为收藏表添加触发器
CREATE TRIGGER update_favorite_count AFTER INSERT OR DELETE ON favorites FOR EACH ROW EXECUTE FUNCTION update_poem_favorite_count();

-- 插入示例数据
INSERT INTO poems (title, author, dynasty, content, analysis, tags) VALUES
('静夜思', '李白', '唐代', '床前明月光，疑是地上霜。\n举头望明月，低头思故乡。', '这首诗通过描绘月夜思乡的场景，表达了诗人深切的思乡之情。语言简练，意境深远。', '{"思乡","月亮","夜晚"}'),
('春晓', '孟浩然', '唐代', '春眠不觉晓，处处闻啼鸟。\n夜来风雨声，花落知多少。', '这首诗描绘了春天早晨的景色，语言清新自然，表达了诗人对春天的热爱。', '{"春天","早晨","自然"}'),
('登鹳雀楼', '王之涣', '唐代', '白日依山尽，黄河入海流。\n欲穷千里目，更上一层楼。', '这首诗通过登高望远的场景，表达了积极向上的人生态度。', '{"登高","励志","景色"}'),
('相思', '王维', '唐代', '红豆生南国，春来发几枝。\n愿君多采撷，此物最相思。', '这首诗以红豆为象征，表达了深切的相思之情。', '{"相思","爱情","红豆"}'),
('江雪', '柳宗元', '唐代', '千山鸟飞绝，万径人踪灭。\n孤舟蓑笠翁，独钓寒江雪。', '这首诗描绘了一幅寂静的冬日江景，意境深远。', '{"冬天","孤独","景色"}');