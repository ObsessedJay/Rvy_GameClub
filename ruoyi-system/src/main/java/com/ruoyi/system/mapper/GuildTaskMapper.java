package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.GuildTask;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 工会任务Mapper接口
 */
public interface GuildTaskMapper {

    GuildTask selectGuildTaskById(@Param("id") Long id);

    List<GuildTask> selectGuildTaskList(@Param("guildId") Long guildId,
                                         @Param("type") Integer type,
                                         @Param("status") Integer status);

    int insertGuildTask(GuildTask task);

    int updateGuildTask(GuildTask task);

    int deleteGuildTaskById(@Param("id") Long id);

    int incrCurrentPlayers(@Param("id") Long id, @Param("delta") int delta);
}
