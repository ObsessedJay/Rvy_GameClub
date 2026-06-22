# GameClub AI 工会助手设计方案

**日期：** 2026-06-15
**状态：** 已批准

## 1. 概述

在工会聊天室中接入 AI 助手（DeepSeek），成员发送以 `/ai` 开头的消息时，后端调用 AI API 并返回回复，AI 回复以机器人身份显示在聊天中。

## 2. 架构

### 2.1 技术选型

| 项目 | 选择 |
|------|------|
| AI 服务 | DeepSeek API（兼容 OpenAI 格式） |
| 触发方式 | 聊天输入 `/ai <问题>` |
| 显示方式 | 嵌入聊天消息流，type=2 区分 AI 消息 |
| API 配置 | application.yml 中的 `deepseek.api.key`、`deepseek.api.url` |

### 2.2 数据流

```
用户发送 "/ai 今天有什么任务?"
  → POST /chat/{guildId}/send { content: "/ai 今天有什么任务?" }
  → GuildChatController 检测 /ai 前缀
  → 提取问题内容
  → GuildAiService.chat(question, guildId)
  → 构造系统提示词 + 用户问题
  → 调用 DeepSeek API
  → 返回 AI 回复文本
  → 保存为 GuildChatMessage(type=2, senderId=0, senderName="AI助手")
  → 前端轮询拉取，渲染为 AI 消息
```

## 3. 后端设计

### 3.1 新增文件

| 文件 | 职责 |
|------|------|
| `ruoyi-system/src/main/java/com/ruoyi/system/service/IGuildAiService.java` | AI 服务接口 |
| `ruoyi-system/src/main/java/com/ruoyi/system/service/impl/GuildAiServiceImpl.java` | AI 核心服务：构造 prompt、调用 API、解析回复 |

### 3.2 修改文件

| 文件 | 修改点 |
|------|--------|
| `GuildChatController.sendMessage()` | 检测 `/ai` 前缀 → 调用 GuildAiService → AI 回复保存入库 |
| `ruoyi-admin/src/main/resources/application.yml` | 新增 `deepseek.api.key`、`deepseek.api.url` 配置 |

### 3.3 核心逻辑

```java
// GuildChatController.sendMessage()
if (content.startsWith("/ai")) {
    String question = content.substring(3).trim();
    if (question.isEmpty()) {
        return error("请输入问题");
    }
    String aiReply = guildAiService.chat(question, guildId);
    GuildChatMessage msg = chatMessageService.send(guildId, 0L, "AI助手", aiReply, 2);
    return success(msg);
}
```

### 3.4 Prompt 设计

- 系统提示词：`你是一个游戏工会的 AI 助手，帮助成员解答问题、讨论游戏策略、管理工会事务。请用中文简洁回复，不要超过200字。`
- 用户问题：直接拼接用户输入

## 4. 前端设计

### 4.1 模板改动

AI 消息通过 `type === 2` 识别，显示机器人头像 🤖，气泡颜色为紫色。

```vue
<div v-for="msg in chatMessages" :key="msg.id"
     class="chat-msg"
     :class="{ mine: isMyMsg(msg), ai: msg.type === 2 }">
  <div class="chat-msg-avatar">{{ msg.type === 2 ? '🤖' : '👤' }}</div>
  <div class="chat-msg-body">
    <div class="chat-msg-header">
      <span class="chat-msg-name">{{ msg.senderName }}</span>
      <span class="chat-msg-time">{{ parseChatTime(msg.createdAt) }}</span>
    </div>
    <div class="chat-msg-content">{{ msg.content }}</div>
  </div>
</div>
```

### 4.2 输入提示

placeholder 改为：`"输入消息...（/ai 开头可与AI助手对话）"`

### 4.3 CSS 新增

```css
.chat-msg.ai .chat-msg-content {
  background: rgba(168, 85, 247, 0.12);
}
.chat-msg.ai .chat-msg-name {
  color: rgba(168, 85, 247, 0.8);
}
```

## 5. 配置项

```yaml
# application.yml
deepseek:
  api:
    key: ${DEEPSEEK_API_KEY:sk-xxx}
    url: https://api.deepseek.com/v1/chat/completions
```

## 6. 文件变更清单

| 操作 | 文件 |
|------|------|
| 新增 | `ruoyi-system/.../service/IGuildAiService.java` |
| 新增 | `ruoyi-system/.../service/impl/GuildAiServiceImpl.java` |
| 修改 | `ruoyi-admin/.../GuildChatController.java` |
| 修改 | `ruoyi-admin/.../resources/application.yml` |
| 修改 | `ruoyi-ui/.../myguild/index.vue`（模板 + CSS + placeholder） |
| 新增 | `ruoyi-system/pom.xml` 中增加 okhttp 或使用 RestTemplate |
