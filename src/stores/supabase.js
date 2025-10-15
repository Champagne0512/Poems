import { defineStore } from 'pinia'
import { supabase } from '../utils/supabase.js'

export const useSupabaseStore = defineStore('supabase', {
  state: () => ({
    poems: [],
    favorites: [],
    history: [],
    loading: false
  }),

  actions: {
    // 获取所有诗词
    async fetchPoems() {
      try {
        this.loading = true
        const { data, error } = await supabase
          .from('poems')
          .select('*')
          .order('created_at', { ascending: false })
        
        if (error) throw error
        this.poems = data || []
        return data
      } catch (error) {
        console.error('获取诗词失败:', error)
        return []
      } finally {
        this.loading = false
      }
    },

    // 根据ID获取诗词详情
    async fetchPoemById(id) {
      try {
        const { data, error } = await supabase
          .from('poems')
          .select('*')
          .eq('id', id)
          .single()
        
        if (error) throw error
        return data
      } catch (error) {
        console.error('获取诗词详情失败:', error)
        return null
      }
    },

    // 搜索诗词
    async searchPoems(query) {
      try {
        const { data, error } = await supabase
          .from('poems')
          .select('*')
          .or(`title.ilike.%${query}%,author.ilike.%${query}%,content.ilike.%${query}%`)
          .order('created_at', { ascending: false })
        
        if (error) throw error
        return data || []
      } catch (error) {
        console.error('搜索诗词失败:', error)
        return []
      }
    },

    // 获取收藏列表
    async getFavorites() {
      try {
        const { data, error } = await supabase
          .from('favorites')
          .select(`
            poem_id,
            poems (*)
          `)
        
        if (error) throw error
        return data?.map(item => item.poems) || []
      } catch (error) {
        console.error('获取收藏失败:', error)
        return []
      }
    },

    // 添加收藏
    async addFavorite(poemId) {
      try {
        const { error } = await supabase
          .from('favorites')
          .insert({ poem_id: poemId })
        
        if (error) throw error
        return true
      } catch (error) {
        console.error('添加收藏失败:', error)
        return false
      }
    },

    // 移除收藏
    async removeFavorite(poemId) {
      try {
        const { error } = await supabase
          .from('favorites')
          .delete()
          .eq('poem_id', poemId)
        
        if (error) throw error
        return true
      } catch (error) {
        console.error('移除收藏失败:', error)
        return false
      }
    },

    // 添加浏览历史
    async addHistory(poemId) {
      try {
        const { error } = await supabase
          .from('history')
          .insert({ 
            poem_id: poemId,
            viewed_at: new Date().toISOString()
          })
        
        if (error) throw error
        return true
      } catch (error) {
        console.error('添加历史失败:', error)
        return false
      }
    },

    // 获取浏览历史
    async getHistory() {
      try {
        const { data, error } = await supabase
          .from('history')
          .select(`
            viewed_at,
            poems (*)
          `)
          .order('viewed_at', { ascending: false })
          .limit(20)
        
        if (error) throw error
        return data?.map(item => ({
          ...item.poems,
          timestamp: item.viewed_at
        })) || []
      } catch (error) {
        console.error('获取历史失败:', error)
        return []
      }
    },

    // 添加评论
    async addComment(poemId, content) {
      try {
        const { error } = await supabase
          .from('comments')
          .insert({
            poem_id: poemId,
            content: content,
            created_at: new Date().toISOString()
          })
        
        if (error) throw error
        return true
      } catch (error) {
        console.error('添加评论失败:', error)
        return false
      }
    },

    // 获取评论
    async fetchComments(poemId) {
      try {
        const { data, error } = await supabase
          .from('comments')
          .select('*')
          .eq('poem_id', poemId)
          .order('created_at', { ascending: false })
        
        if (error) throw error
        return data || []
      } catch (error) {
        console.error('获取评论失败:', error)
        return []
      }
    }
  }
})