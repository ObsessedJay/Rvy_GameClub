package com.ruoyi.system.service;

import com.ruoyi.system.domain.GuildChatMessage;
import java.util.List;

public interface IGuildChatMessageService {
    /** 获取最近N条历史消息 */
    List<GuildChatMessage> getHistory(Long guildId, int limit);
    /** 保存消息 */
    GuildChatMessage send(Long guildId, Long senderId, String senderName, String content, Integer type);
    /** 轮询 sinceId 之后的新消息 */
    List<GuildChatMessage> pollMessages(Long guildId, Long sinceId);
}
