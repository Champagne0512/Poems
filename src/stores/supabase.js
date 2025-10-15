import { defineStore } from 'pinia'
import { supabase } from '../utils/supabase.js'

export const useSupabaseStore = defineStore('supabase', {
  state: () => ({
    poems: [],
    user: null,
    loading: false,
    error: null
  }),

  actions: {
    // 获取所有诗词
    async fetchPoems() {
      this.loading = true
      try {
        const { data, error } = await supabase
          .from('poems')
          .select('*')
          .order('created_at', { ascending: false })
        
        if (error) throw error
        this.poems = data || []
        return data
      } catch (error) {
        this.error = error.message
        console.error('获取诗词失败:', error)
      } finally {
        this.loading = false
      }
    },

    // 根据ID获取诗词详情
    async fetchPoemById(id) {
      this.loading = true
      try {
        const { data, error } = await supabase
          .from('poems')
          .select('*')
          .eq('id', id)
          .single()
        
        if (error) throw error
        return data
      } catch (error) {
        this.error = error.message
        console.error('获取诗词详情失败:', error)
        return null
      } finally {
        this.loading = false
      }
    },

    // 搜索诗词
    async searchPoems(query) {
      this.loading = true
      try {
        const { data, error } = await supabase
          .from('poems')
          .select('*')
          .or(`title.ilike.%${query}%,author.ilike.%${query}%,content.ilike.%${query}%`)
          .order('created_at', { ascending: false })
        
        if (error) throw error
        return data || []
      } catch (error) {
        this.error = error.message
        console.error('搜索诗词失败:', error)
        return []
      } finally {
        this.loading = false
      }
    },

    // 用户登录
    async signIn(email, password) {
      try {
        const { data, error } = await supabase.auth.signInWithPassword({
          email,
          password
        })
        
        if (error) throw error
        this.user = data.user
        return data
      } catch (error) {
        this.error = error.message
        throw error
      }
    },

    // 用户注册
    async signUp(email, password, userData = {}) {
      try {
        const { data, error } = await supabase.auth.signUp({
          email,
          password,
          options: {
            data: userData
          }
        })
        
        if (error) throw error
        return data
      } catch (error) {
        this.error = error.message
        throw error
      }
    },

    // 用户登出
    async signOut() {
      try {
        const { error } = await supabase.auth.signOut()
        if (error) throw error
        this.user = null
      } catch (error) {
        this.error = error.message
        throw error
      }
    },

    // 获取当前用户
    async getCurrentUser() {
      try {
        const { data: { user } } = await supabase.auth.getUser()
        this.user = user
        return user
      } catch (error) {
        this.error = error.message
        return null
      }
    },

    // 添加收藏
    async addFavorite(poemId) {
      if (!this.user) throw new Error('请先登录')
      
      try {
        const { data, error } = await supabase
          .from('favorites')
          .insert({
            user_id: this.user.id,
            poem_id: poemId
          })
          .select()
        
        if (error) throw error
        return data
      } catch (error) {
        this.error = error.message
        throw error
      }
    },

    // 获取用户收藏
    async getFavorites() {
      if (!this.user) return []
      
      try {
        const { data, error } = await supabase
          .from('favorites')
          .select(`
            poem_id,
            poems (*)
          `)
          .eq('user_id', this.user.id)
        
        if (error) throw error
        return data.map(item => item.poems) || []
      } catch (error) {
        this.error = error.message
        return []
      }
    }
  }
})