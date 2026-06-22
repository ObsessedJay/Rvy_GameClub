package com.ruoyi.web.controller.system;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.domain.model.LoginUser;
import com.ruoyi.system.domain.GuildChatMessage;
import com.ruoyi.system.domain.GuildMember;
import com.ruoyi.system.service.IGuildChatMessageService;
import com.ruoyi.system.service.IGuildMemberService;
import com.ruoyi.system.service.IGuildAiService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/system/gameclub/member")
public class GuildChatController extends BaseController {

    private static final Logger log = LoggerFactory.getLogger(GuildChatController.class);

    @Autowired
    private IGuildChatMessageService chatMessageService;

    @Autowired
    private IGuildMemberService guildMemberService;

    @Autowired
    private IGuildAiService guildAiService;

    /** 获取工会聊天历史 */
    @GetMapping("/chat/{guildId}/history")
    public AjaxResult history(@PathVariable("guildId") Long guildId,
                              @RequestParam(defaultValue = "50") int limit) {
        List<GuildChatMessage> list = chatMessageService.getHistory(guildId, limit);
        return success(list);
    }

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
            return success(buildMsgResult(aiMsg));
        }

        // 普通消息
        String senderName = getNickName(userId);
        GuildChatMessage msg = chatMessageService.send(guildId, userId, senderName, trimmed, 1);
        return success(buildMsgResult(msg));
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

    /** 轮询新消息（sinceId 之后的消息） */
    @GetMapping("/chat/{guildId}/poll")
    public AjaxResult pollMessages(@PathVariable("guildId") Long guildId,
                                   @RequestParam("sinceId") Long sinceId) {
        List<GuildChatMessage> list = chatMessageService.pollMessages(guildId, sinceId);
        return success(list);
    }

    private String getNickName(Long userId) {
        try {
            GuildMember q = new GuildMember();
            q.setUserId(userId);
            List<GuildMember> list = guildMemberService.selectGuildMemberList(q);
            for (GuildMember m : list) {
                if (m.getNickName() != null) return m.getNickName();
            }
        } catch (Exception ignored) {}
        return "用户" + userId;
    }
}
