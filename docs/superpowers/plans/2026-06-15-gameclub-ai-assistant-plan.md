# GameClub AI 工会助手 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 在工会聊天室中接入 DeepSeek AI 助手，发送 `/ai` 前缀消息时调用 AI API 并返回回复

**Architecture:** 后端新增 `GuildAiService` 封装 DeepSeek API 调用，`GuildChatController.sendMessage()` 中检测 `/ai` 前缀后调用 AI 服务，AI 回复以 `type=2` 保存入库。前端通过 `msg.type === 2` 识别 AI 消息并用紫色气泡渲染。

**Tech Stack:** Spring Boot RestTemplate + DeepSeek API (OpenAI-compatible) + Vue 2.x

---

### Task 1: 创建 AI 服务接口和实现

**Files:**
- Create: `ruoyi-system/src/main/java/com/ruoyi/system/service/IGuildAiService.java`
- Create: `ruoyi-system/src/main/java/com/ruoyi/system/service/impl/GuildAiServiceImpl.java`

- [ ] **Step 1: 创建 AI 服务接口**

```java
// ruoyi-system/src/main/java/com/ruoyi/system/service/IGuildAiService.java
package com.ruoyi.system.service;

public interface IGuildAiService {
    /** 向 AI 提问并获取回复 */
    String chat(String question, Long guildId);
}
```

- [ ] **Step 2: 创建 AI 服务实现**

```java
// ruoyi-system/src/main/java/com/ruoyi/system/service/impl/GuildAiServiceImpl.java
package com.ruoyi.system.service.impl;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.system.service.IGuildAiService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.List;
import java.util.Map;

@Service
public class GuildAiServiceImpl implements IGuildAiService {

    private static final Logger log = LoggerFactory.getLogger(GuildAiServiceImpl.class);

    private static final String SYSTEM_PROMPT = "你是一个游戏工会的AI助手，帮助成员解答问题、讨论游戏策略、管理工会事务。请用中文简洁回复，不要超过200字。";

    @Value("${deepseek.api.key:}")
    private String apiKey;

    @Value("${deepseek.api.url:https://api.deepseek.com/v1/chat/completions}")
    private String apiUrl;

    @Value("${deepseek.api.model:deepseek-chat}")
    private String model;

    private final RestTemplate restTemplate = new RestTemplate();

    @Override
    public String chat(String question, Long guildId) {
        if (apiKey == null || apiKey.isEmpty()) {
            return "AI 助手暂未配置 API Key，请联系管理员。";
        }

        try {
            JSONObject body = new JSONObject();
            body.put("model", model);

            JSONArray messages = new JSONArray();
            JSONObject sysMsg = new JSONObject();
            sysMsg.put("role", "system");
            sysMsg.put("content", SYSTEM_PROMPT);
            messages.add(sysMsg);

            JSONObject userMsg = new JSONObject();
            userMsg.put("role", "user");
            userMsg.put("content", question);
            messages.add(userMsg);

            body.put("messages", messages);
            body.put("max_tokens", 500);
            body.put("temperature", 0.7);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.set("Authorization", "Bearer " + apiKey);

            HttpEntity<String> entity = new HttpEntity<>(body.toJSONString(), headers);
            ResponseEntity<String> response = restTemplate.postForEntity(apiUrl, entity, String.class);

            if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
                JSONObject respJson = JSON.parseObject(response.getBody());
                JSONArray choices = respJson.getJSONArray("choices");
                if (choices != null && !choices.isEmpty()) {
                    JSONObject choice = choices.getJSONObject(0);
                    JSONObject msg = choice.getJSONObject("message");
                    if (msg != null) {
                        String reply = msg.getString("content");
                        return reply != null ? reply.trim() : "（AI 返回为空）";
                    }
                }
            }
            return "AI 助手暂时无法回复，请稍后再试。";

        } catch (Exception e) {
            log.error("[AI] DeepSeek API call failed", e);
            return "AI 助手调用失败：" + e.getMessage();
        }
    }
}
```

- [ ] **Step 3: 编译验证**

```bash
cd d:\RpoJec\RuoYi-Vue && mvn.cmd compile -pl ruoyi-system -am -q -DskipTests
```

Expected: BUILD SUCCESS

---

### Task 2: 添加 DeepSeek 配置项

**Files:**
- Modify: `ruoyi-admin/src/main/resources/application.yml`

- [ ] **Step 1: 在 application.yml 末尾追加配置**

```yaml
# DeepSeek AI配置
deepseek:
  api:
    # API Key（支持环境变量 DEEPSEEK_API_KEY）
    key: ${DEEPSEEK_API_KEY:sk-your-api-key-here}
    # API 地址
    url: https://api.deepseek.com/v1/chat/completions
    # 模型名称
    model: deepseek-chat
```

插入位置：`application.yml` 文件末尾，`xss.urlPatterns` 之后。

---

### Task 3: 修改 GuildChatController 拦截 /ai 消息

**Files:**
- Modify: `ruoyi-admin/src/main/java/com/ruoyi/web/controller/system/GuildChatController.java`

- [ ] **Step 1: 注入 GuildAiService**

在类中新增 `@Autowired` 字段：

```java
@Autowired
private com.ruoyi.system.service.IGuildAiService guildAiService;
```

放在 `@Autowired private IGuildMemberService guildMemberService;` 之后。

- [ ] **Step 2: 修改 sendMessage 方法，添加 /ai 前缀检测**

将 `sendMessage` 方法替换为：

```java
/** HTTP 发送聊天消息 */
@PostMapping("/chat/{guildId}/send")
public AjaxResult sendMessage(@PathVariable("guildId") Long guildId,
                              @RequestBody Map<String, String> body) {
    LoginUser loginUser = getLoginUser();
    if (loginUser == null) {
        return error("请先登录");
    }
    Long userId = loginUser.getUserId();
    String content = body.get("content");
    if (content == null || content.trim().isEmpty()) {
        return error("内容不能为空");
    }
    String trimmed = content.trim();

    // AI 消息：/ai 前缀
    if (trimmed.startsWith("/ai")) {
        String question = trimmed.substring(3).trim();
        if (question.isEmpty()) {
            return error("请在 /ai 后输入问题，例如：/ai 今天有什么任务");
        }
        String aiReply = guildAiService.chat(question, guildId);
        GuildChatMessage aiMsg = chatMessageService.send(guildId, 0L, "AI助手", aiReply, 2);
        Map<String, Object> result = buildMsgResult(aiMsg);
        return success(result);
    }

    // 普通消息
    String senderName = getNickName(userId);
    GuildChatMessage msg = chatMessageService.send(guildId, userId, senderName, trimmed, 1);
    Map<String, Object> result = buildMsgResult(msg);
    return success(result);
}

private Map<String, Object> buildMsgResult(GuildChatMessage msg) {
    Map<String, Object> result = new HashMap<>();
    result.put("id", msg.getId());
    result.put("guildId", msg.getGuildId());
    result.put("senderId", msg.getSenderId());
    result.put("senderName", msg.getSenderName());
    result.put("content", msg.getContent());
    result.put("type", msg.getType());
    result.put("createdAt", msg.getCreatedAt() != null ? msg.getCreatedAt().getTime() : System.currentTimeMillis());
    return result;
}
```

删除原来 `sendMessage` 方法末尾的内联 `Map<String, Object> result` 构建代码（已提取到 `buildMsgResult` 复用）。

- [ ] **Step 3: 编译验证**

```bash
cd d:\RpoJec\RuoYi-Vue && mvn.cmd compile -q -DskipTests
```

Expected: BUILD SUCCESS

---

### Task 4: 修改前端模板渲染 AI 消息

**Files:**
- Modify: `ruoyi-ui/src/views/gameclub-portal/myguild/index.vue`

- [ ] **Step 1: 修改聊天消息模板，添加 AI 样式类**

将第 28-29 行的消息循环改为：

```vue
<div v-for="msg in chatMessages" :key="msg.id" class="chat-msg" :class="{ mine: isMyMsg(msg), ai: msg.type === 2 }">
  <div class="chat-msg-avatar">{{ msg.type === 2 ? '🤖' : '👤' }}</div>
```

- [ ] **Step 2: 修改输入框 placeholder**

将第 40 行的 placeholder 改为：

```vue
<el-input v-model="chatInput" placeholder="输入消息...（/ai 开头可与AI助手对话）" @keyup.enter.native="sendChat" :disabled="!chatConnected">
```

- [ ] **Step 3: 新增加载状态提示（AI 回复需要等待）**

不需要额外修改。AI 回复通过轮询自然拉取。`chatSending` 锁已经防止了重复发送。

- [ ] **Step 4: 新增 AI 消息 CSS**

在 `<style scoped>` 中，`.chat-msg.mine .chat-msg-content` 之后（约第 657 行）新增：

```css
.chat-msg.ai .chat-msg-content {
  background: rgba(168, 85, 247, 0.12);
}
.chat-msg.ai .chat-msg-name {
  color: rgba(168, 85, 247, 0.8);
}
```

- [ ] **Step 5: 编译验证**

刷新页面即可，前端 dev server 热更新。

---

### Task 5: 集成测试

- [ ] **Step 1: 启动后端**

```bash
cd d:\RpoJec\RuoYi-Vue && mvn.cmd spring-boot:run -pl ruoyi-admin
```

- [ ] **Step 2: 验证 API 配置加载**

查看启动日志中是否有 `deepseek.api` 相关输出。无异常即正常。

- [ ] **Step 3: 测试普通消息**

在聊天中发送 `你好`，确认普通消息正常显示。

- [ ] **Step 4: 测试 AI 消息（需先配置 API Key）**

发送 `/ai 你好`，等待 AI 回复（2-4秒后轮询拉取），确认：
- AI 消息显示 🤖 头像
- AI 消息气泡为紫色
- 发送者名显示"AI助手"
- 内容为 AI 回复文本

- [ ] **Step 5: 测试空问题**

发送 `/ai `（无问题内容），确认收到错误提示"请在 /ai 后输入问题"

- [ ] **Step 6: 测试未配置 API Key 时的降级**

如未配置 `deepseek.api.key`，发送 `/ai 你好`，AI 应回复"AI 助手暂未配置 API Key，请联系管理员。"
