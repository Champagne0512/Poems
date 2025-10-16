-- 创建搜索诗词的函数
CREATE OR REPLACE FUNCTION search_poems(query_text TEXT)
RETURNS TABLE (
  id UUID,
  title TEXT,
  author TEXT,
  dynasty TEXT,
  content TEXT,
  analysis TEXT,
  tags TEXT[],
  favorite_count INTEGER,
  view_count INTEGER,
  created_at TIMESTAMP WITH TIME ZONE,
  similarity_score REAL
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    p.id,
    p.title,
    p.author,
    p.dynasty,
    p.content,
    p.analysis,
    p.tags,
    p.favorite_count,
    p.view_count,
    p.created_at,
    GREATEST(
      similarity(p.title, query_text),
      similarity(p.author, query_text),
      similarity(p.content, query_text)
    ) as similarity_score
  FROM poems p
  WHERE 
    p.title ILIKE '%' || query_text || '%' OR
    p.author ILIKE '%' || query_text || '%' OR
    p.content ILIKE '%' || query_text || '%' OR
    query_text = ANY(p.tags)
  ORDER BY similarity_score DESC, p.favorite_count DESC;
END;
$$ LANGUAGE plpgsql;

-- 创建获取热门诗词的函数
CREATE OR REPLACE FUNCTION get_popular_poems(limit_count INTEGER DEFAULT 10)
RETURNS TABLE (
  id UUID,
  title TEXT,
  author TEXT,
  dynasty TEXT,
  content TEXT,
  favorite_count INTEGER,
  view_count INTEGER,
  rank INTEGER
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    p.id,
    p.title,
    p.author,
    p.dynasty,
    p.content,
    p.favorite_count,
    p.view_count,
    ROW_NUMBER() OVER (ORDER BY p.favorite_count DESC, p.view_count DESC) as rank
  FROM poems p
  ORDER BY p.favorite_count DESC, p.view_count DESC
  LIMIT limit_count;
END;
$$ LANGUAGE plpgsql;

-- 创建获取最新诗词的函数
CREATE OR REPLACE FUNCTION get_recent_poems(limit_count INTEGER DEFAULT 10)
RETURNS TABLE (
  id UUID,
  title TEXT,
  author TEXT,
  dynasty TEXT,
  content TEXT,
  favorite_count INTEGER,
  view_count INTEGER,
  created_at TIMESTAMP WITH TIME ZONE
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    p.id,
    p.title,
    p.author,
    p.dynasty,
    p.content,
    p.favorite_count,
    p.view_count,
    p.created_at
  FROM poems p
  ORDER BY p.created_at DESC
  LIMIT limit_count;
END;
$$ LANGUAGE plpgsql;

-- 创建按朝代筛选诗词的函数
CREATE OR REPLACE FUNCTION get_poems_by_dynasty(dynasty_name TEXT)
RETURNS TABLE (
  id UUID,
  title TEXT,
  author TEXT,
  dynasty TEXT,
  content TEXT,
  favorite_count INTEGER,
  view_count INTEGER
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    p.id,
    p.title,
    p.author,
    p.dynasty,
    p.content,
    p.favorite_count,
    p.view_count
  FROM poems p
  WHERE p.dynasty = dynasty_name
  ORDER BY p.favorite_count DESC, p.created_at DESC;
END;
$$ LANGUAGE plpgsql;

-- 创建增加浏览次数的函数
CREATE OR REPLACE FUNCTION increment_poem_view_count(poem_id UUID, user_id UUID)
RETURNS VOID AS $$
BEGIN
  -- 更新诗词的浏览次数
  UPDATE poems SET view_count = view_count + 1 WHERE id = poem_id;
  
  -- 记录浏览历史（如果用户已登录）
  IF user_id IS NOT NULL THEN
    INSERT INTO browse_history (user_id, poem_id) VALUES (user_id, poem_id);
  END IF;
END;
$$ LANGUAGE plpgsql;