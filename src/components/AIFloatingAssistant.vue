<template>
  <div class="ai-assistant" :class="{ minimized: isMinimized }">
    <div class="ai-header" @click="toggleMinimize">
      <span>AI助手</span>
      <div class="header-buttons">
        <button class="test-btn" @click.stop="testConnection" title="测试连接">
          🔄
        </button>
        <button class="minimize-btn">
          {{ isMinimized ? '+' : '-' }}
        </button>
      </div>
    </div>
    
    <div class="ai-content" v-if="!isMinimized">
      <div class="message-container">
        <div v-for="(msg, index) in messages" :key="index" class="message" :class="msg.type">
          {{ msg.text }}
        </div>
      </div>
      
      <div class="input-area">
        <input v-model="inputMessage" @keyup.enter="sendMessage" placeholder="输入您的问题...">
        <button @click="sendMessage">发送</button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      isMinimized: false,
      inputMessage: '',
      messages: [],
      isLoading: false
    }
  },
  mounted() {
    this.loadMessages()
  },
  methods: {
    async testConnection() {
      if (this.isLoading) return
      
      this.isLoading = true
      this.messages.push({ 
        text: '正在测试API连接...', 
        type: 'loading',
        timestamp: new Date().toISOString()
      })
      
      try {
        const response = await fetch('https://apis.iflow.cn/v1/chat/completions', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer sk-5f9158b2879db5ae96bc09626b6ba18a`
          },
          body: JSON.stringify({
            model: "deepseek-v3.2",
            messages: [{ role: 'user', content: '你好，请回复"连接成功"' }],
            temperature: 0.7
          })
        })
        
        if (!response.ok) {
          throw new Error(`HTTP错误: ${response.status} ${response.statusText}`)
        }
        
        const data = await response.json()
        this.messages = this.messages.filter(msg => msg.type !== 'loading')
        
        let aiReply = '连接测试失败'
        if (data.choices && data.choices[0] && data.choices[0].message) {
          aiReply = `连接成功！API回复: ${data.choices[0].message.content}`
        } else if (data.reply) {
          aiReply = `连接成功！API回复: ${data.reply}`
        }
        
        this.messages.push({ 
          text: aiReply, 
          type: 'bot',
          timestamp: new Date().toISOString()
        })
        
      } catch (error) {
        console.error('API连接测试失败:', error)
        this.messages = this.messages.filter(msg => msg.type !== 'loading')
        this.messages.push({ 
          text: `连接失败: ${error.message}`, 
          type: 'error',
          timestamp: new Date().toISOString()
        })
      }
      
      this.isLoading = false
      this.saveMessages()
      this.scrollToBottom()
    },
    loadMessages() {
      const saved = localStorage.getItem('ai_chat_history')
      if (saved) {
        this.messages = JSON.parse(saved)
      } else {
        this.messages = [
          { 
            text: '您好！我是AI助手，请问有什么可以帮您？', 
            type: 'bot',
            timestamp: new Date().toISOString()
          }
        ]
      }
    },
    saveMessages() {
      localStorage.setItem('ai_chat_history', JSON.stringify(this.messages))
    },
    toggleMinimize() {
      this.isMinimized = !this.isMinimized
    },
    formatTime(isoString) {
      const date = new Date(isoString)
      return `${date.getHours()}:${date.getMinutes().toString().padStart(2, '0')}`
    },
    scrollToBottom() {
      this.$nextTick(() => {
        const container = this.$el.querySelector('.message-container')
        if (container) {
          container.scrollTop = container.scrollHeight
        }
      })
    },
    async sendMessage() {
      if (this.inputMessage.trim() && !this.isLoading) {
        const userMessage = this.inputMessage
        this.messages.push({ 
          text: userMessage, 
          type: 'user',
          timestamp: new Date().toISOString()
        })
        this.saveMessages()
        this.scrollToBottom()
        this.isLoading = true
        this.inputMessage = ''
        
        // 添加加载状态
        this.messages.push({ text: '思考中...', type: 'loading' })
        
        try {
          // 使用提供的API端点
          const response = await fetch('https://apis.iflow.cn/v1/chat/completions', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
              'Authorization': `Bearer sk-5f9158b2879db5ae96bc09626b6ba18a`
            },
            body: JSON.stringify({
              model: "deepseek-v3.2",
              messages: this.messages
                .filter(msg => msg.type !== 'loading')
                .map(msg => ({
                  role: msg.type === 'user' ? 'user' : 'assistant',
                  content: msg.text
                })),
              temperature: 0.7
            })
          })
          
          if (!response.ok) {
            throw new Error(`HTTP错误: ${response.status} ${response.statusText}`)
          }
          
          const data = await response.json()
          
          // 移除加载消息，添加AI回复
          this.messages = this.messages.filter(msg => msg.type !== 'loading')
          
          // 处理不同的API响应格式
          let aiReply = '抱歉，暂时无法获取回复'
          if (data.choices && data.choices[0] && data.choices[0].message) {
            aiReply = data.choices[0].message.content
          } else if (data.reply) {
            aiReply = data.reply
          } else if (data.error) {
            aiReply = `API错误: ${data.error.message || data.error}`
          }
          
          this.messages.push({ 
            text: aiReply, 
            type: 'bot',
            timestamp: new Date().toISOString()
          })
          this.saveMessages()
          this.scrollToBottom()
          this.isLoading = false
          
        } catch (error) {
          console.error('AI助手API错误:', error)
          this.messages = this.messages.filter(msg => msg.type !== 'loading')
          
          let errorMessage = '网络错误，请稍后再试'
          if (error.message.includes('fetch')) {
            errorMessage = '网络连接失败，请检查网络'
          } else if (error.message.includes('401')) {
            errorMessage = 'API密钥无效或已过期'
          } else if (error.message.includes('429')) {
            errorMessage = 'API请求过于频繁，请稍后再试'
          } else if (error.message.includes('500')) {
            errorMessage = '服务器内部错误，请稍后再试'
          }
          
          this.messages.push({ 
            text: errorMessage, 
            type: 'error',
            timestamp: new Date().toISOString()
          })
          this.isLoading = false
        }
      }
    }
  }
}
</script>

<style scoped>
.ai-assistant {
  position: fixed;
  right: 20px;
  bottom: 20px;
  width: 320px;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  z-index: 1000;
  transition: all 0.3s ease;
  border: 1px solid rgba(255, 255, 255, 0.2);
  font-family: var(--font-ui);
}

.ai-header {
  padding: 12px 20px;
  background: linear-gradient(135deg, var(--accent-color) 0%, #1a202c 100%);
  color: white;
  border-radius: 12px 12px 0 0;
  cursor: pointer;
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-weight: 500;
}

.header-buttons {
  display: flex;
  gap: 8px;
  align-items: center;
}

.test-btn {
  background: rgba(255,255,255,0.2);
  border: none;
  color: white;
  font-size: 16px;
  cursor: pointer;
  border-radius: 4px;
  padding: 4px 8px;
  transition: all 0.3s ease;
}

.test-btn:hover {
  background: rgba(255,255,255,0.3);
  transform: rotate(180deg);
}

.minimize-btn {
  background: rgba(255,255,255,0.2);
  border: none;
  color: white;
  font-size: 14px;
  cursor: pointer;
  border-radius: 4px;
  padding: 2px 8px;
  transition: all 0.3s ease;
}

.minimize-btn:hover {
  background: rgba(255,255,255,0.3);
}

.ai-content {
  padding: 10px;
}

.message-container {
  height: 200px;
  overflow-y: auto;
  margin-bottom: 10px;
}

.message {
  margin: 8px 0;
  padding: 12px 16px;
  border-radius: 8px;
  font-size: 15px;
  line-height: 1.5;
  font-family: var(--font-ui);
  color: #000;
}

.message.user {
  background: rgba(139, 115, 85, 0.1);
  margin-left: 20px;
  border-left: 3px solid var(--primary-color);
}

.message.bot {
  background: rgba(245, 245, 245, 0.7);
  margin-right: 20px;
  border-right: 3px solid var(--accent-color);
}

.message.loading {
  color: #666;
  font-style: italic;
}

.message.error {
  background: #ffebee;
  color: #c62828;
}

.input-area {
  display: flex;
  gap: 5px;
}

.input-area input {
  flex: 1;
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
}

.input-area button {
  padding: 8px 16px;
  background: var(--primary-color);
  color: white;
  border: none;
  border-radius: 25px;
  cursor: pointer;
  font-weight: 500;
  transition: all 0.3s ease;
}

.input-area button:hover {
  background: #6d5c47;
  transform: translateY(-2px);
}

.input-area button:disabled {
  background: #cccccc;
  transform: none;
  cursor: not-allowed;
}

.ai-assistant.minimized {
  width: 100px;
  height: 40px;
  overflow: hidden;
}

.ai-assistant.minimized .ai-content {
  display: none;
}
</style>