package com.ruoyi.system.service;

import com.ruoyi.system.domain.GuildTask;
import java.util.List;

public interface IGuildTaskService {
    GuildTask selectGuildTaskById(Long id);
    List<GuildTask> selectGuildTaskList(GuildTask task);
    int insertGuildTask(GuildTask task);
    int updateGuildTask(GuildTask task);
    int deleteGuildTaskById(Long id);
    int changeStatus(Long id, Integer status);
    int completeTask(Long taskId);

    /** 自动归档任务（接取截止/超时） */
    void autoArchiveTasks(Long guildId);

    /** 查询用户参与的任务 */
    List<GuildTask> selectTasksByUserId(Long userId, Long guildId);
}
