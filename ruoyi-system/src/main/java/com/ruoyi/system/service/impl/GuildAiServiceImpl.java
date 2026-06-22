package com.ruoyi.system.service.impl;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.system.domain.Guild;
import com.ruoyi.system.domain.GuildMember;
import com.ruoyi.system.service.IGuildAiService;
import com.ruoyi.system.service.IGuildMemberService;
import com.ruoyi.system.service.IGuildService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class GuildAiServiceImpl implements IGuildAiService {

    private static final Logger log = LoggerFactory.getLogger(GuildAiServiceImpl.class);

    @Autowired
    private IGuildService guildService;

    @Autowired
    private IGuildMemberService guildMemberService;

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

        String systemPrompt = buildSystemPrompt(guildId);

        try {
            JSONObject body = new JSONObject();
            body.put("model", model);

            JSONArray messages = new JSONArray();
            JSONObject sysMsg = new JSONObject();
            sysMsg.put("role", "system");
            sysMsg.put("content", systemPrompt);
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

    private String buildSystemPrompt(Long guildId) {
        try {
            Guild guild = guildService.selectGuildById(guildId);
            if (guild == null) {
                return "你是一个游戏工会的AI助手。请用中文简洁回复，不要超过200字。";
            }

            StringBuilder sb = new StringBuilder();
            sb.append("你是工会「").append(guild.getName()).append("」的AI助手。");
            if (guild.getDescription() != null && !guild.getDescription().isEmpty()) {
                sb.append("工会简介：").append(guild.getDescription()).append("。");
            }

            // 加载成员列表
            try {
                GuildMember query = new GuildMember();
                query.setGuildId(guildId);
                List<GuildMember> members = guildMemberService.selectGuildMemberList(query);
                if (members != null && !members.isEmpty()) {
                    List<GuildMember> active = members.stream()
                        .filter(m -> m.getStatus() != null && m.getStatus() == 1)
                        .collect(Collectors.toList());
                    sb.append("工会共有").append(active.size()).append("名成员：");
                    for (int i = 0; i < Math.min(active.size(), 20); i++) {
                        GuildMember m = active.get(i);
                        String name = m.getNickName() != null ? m.getNickName() : m.getUserName();
                        String roleText = roleName(m.getRole());
                        sb.append(name).append("（").append(roleText).append("）");
                        if (i < Math.min(active.size(), 20) - 1) sb.append("、");
                    }
                    if (active.size() > 20) sb.append("等（仅展示前20人）");
                    sb.append("。");
                }
            } catch (Exception ignored) {}

            sb.append("请用中文简洁回复，不要超过200字。");
            return sb.toString();
        } catch (Exception e) {
            return "你是一个游戏工会的AI助手。请用中文简洁回复，不要超过200字。";
        }
    }

    private String roleName(Integer role) {
        if (role == null) return "成员";
        switch (role) {
            case 1: return "会长";
            case 2: return "管理员";
            default: return "成员";
        }
    }
}
