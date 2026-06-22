import { sendChatMessage as httpSend, pollChatMessages, getChatHistory } from '@/api/gameclub/task'

let pollTimer = null
let lastMsgId = 0
let onMessageCallback = null
let pollGuildId = null

/**
 * 开始聊天（加载历史 + 启动轮询）
 */
export function startChat(guildId, onMessage) {
  stopChat()
  onMessageCallback = onMessage
  pollGuildId = guildId
  lastMsgId = 0

  // 先加载历史消息，完成后再启动轮询
  getChatHistory(guildId, 50).then(res => {
    const list = res.data || []
    if (list.length > 0) {
      lastMsgId = list[list.length - 1].id || 0
    }
    if (onMessageCallback) {
      onMessageCallback(list, true) // true = history
    }
    // 历史加载完成后启动轮询
    startPolling()
  }).catch(() => {
    startPolling()
  })
}

function startPolling() {
  if (pollTimer) return
  pollTimer = setInterval(() => {
    if (!pollGuildId || !onMessageCallback) return
    pollChatMessages(pollGuildId, lastMsgId).then(res => {
      const list = res.data || []
      if (list.length > 0) {
        lastMsgId = list[list.length - 1].id || lastMsgId
        onMessageCallback(list, false)
      }
    }).catch(() => {})
  }, 2000)
}

/**
 * 发送消息
 * @param {number} guildId
 * @param {string} content
 * @returns {Promise}
 */
export function sendChatMessage(guildId, content) {
  return httpSend(guildId, content)
}

/**
 * 停止聊天（清除轮询）
 */
export function stopChat() {
  if (pollTimer) {
    clearInterval(pollTimer)
    pollTimer = null
  }
  onMessageCallback = null
  pollGuildId = null
  lastMsgId = 0
}

// 兼容旧接口
export const connectChat = () => {}
export const disconnectChat = stopChat
