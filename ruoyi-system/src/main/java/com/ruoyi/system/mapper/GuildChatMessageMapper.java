package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.GuildChatMessage;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface GuildChatMessageMapper {

    List<GuildChatMessage> selectHistory(@Param("guildId") Long guildId, @Param("limit") int limit);

    List<GuildChatMessage> selectSinceId(@Param("guildId") Long guildId, @Param("sinceId") Long sinceId);

    int insert(GuildChatMessage message);
}
