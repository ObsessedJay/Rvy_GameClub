package com.ruoyi.system.service.impl;

import com.ruoyi.system.domain.GuildChatMessage;
import com.ruoyi.system.mapper.GuildChatMessageMapper;
import com.ruoyi.system.service.IGuildChatMessageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;

@Service
public class GuildChatMessageServiceImpl implements IGuildChatMessageService {

    @Autowired
    private GuildChatMessageMapper mapper;

    @Override
    public List<GuildChatMessage> getHistory(Long guildId, int limit) {
        List<GuildChatMessage> list = mapper.selectHistory(guildId, limit);
        if (list == null) return Collections.emptyList();
        // 反转：数据库是 DESC，展示需要 ASC（旧→新）
        Collections.reverse(list);
        return list;
    }

    @Override
    @Transactional
    public GuildChatMessage send(Long guildId, Long senderId, String senderName, String content, Integer type) {
        GuildChatMessage msg = new GuildChatMessage();
        msg.setGuildId(guildId);
        msg.setSenderId(senderId);
        msg.setSenderName(senderName);
        msg.setContent(content);
        msg.setType(type != null ? type : 1);
        mapper.insert(msg);
        return msg;
    }

    @Override
    public List<GuildChatMessage> pollMessages(Long guildId, Long sinceId) {
        List<GuildChatMessage> list = mapper.selectSinceId(guildId, sinceId);
        return list != null ? list : Collections.emptyList();
    }
}
