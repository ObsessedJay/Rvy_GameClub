package com.ruoyi.system.service.impl;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.Guild;
import com.ruoyi.system.domain.GuildTask;
import com.ruoyi.system.mapper.GuildMapper;
import com.ruoyi.system.mapper.GuildTaskMapper;
import com.ruoyi.system.mapper.TaskParticipantMapper;
import com.ruoyi.system.service.IGuildTaskService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Service
public class GuildTaskServiceImpl implements IGuildTaskService {

    private static final Logger log = LoggerFactory.getLogger(GuildTaskServiceImpl.class);

    @Autowired
    private GuildTaskMapper guildTaskMapper;

    @Autowired
    private GuildMapper guildMapper;

    @Autowired
    private TaskParticipantMapper taskParticipantMapper;

    @Override
    public GuildTask selectGuildTaskById(Long id) {
        return guildTaskMapper.selectGuildTaskById(id);
    }

    @Override
    public List<GuildTask> selectGuildTaskList(GuildTask task) {
        // 查询前自动归档过期任务
        if (task.getGuildId() != null) {
            autoArchiveTasks(task.getGuildId());
        }
        return guildTaskMapper.selectGuildTaskList(
            task.getGuildId(), task.getType(), task.getStatus());
    }

    @Override
    public int insertGuildTask(GuildTask task) {
        if (StringUtils.isEmpty(task.getName())) throw new ServiceException("任务名称不能为空");
        if (task.getGuildId() == null) throw new ServiceException("工会不能为空");

        // 时间校验
        Date now = new Date();
        if (task.getJoinDeadline() == null) throw new ServiceException("请设置接取截止时间");
        if (task.getJoinDeadline().before(now)) throw new ServiceException("接取截止时间不能早于当前时间");
        if (task.getEndTime() == null) throw new ServiceException("请设置任务完成时限");
        if (task.getEndTime().before(task.getJoinDeadline())) throw new ServiceException("任务完成时限不能早于接取截止时间");

        if (task.getMinPlayers() == null) task.setMinPlayers(1);
        if (task.getMaxPlayers() == null) task.setMaxPlayers(task.getMinPlayers());
        if (task.getStatus() == null) task.setStatus(1);
        if (task.getCurrentPlayers() == null) task.setCurrentPlayers(0);
        if (task.getGamePartitionId() == null) {
            Guild guild = guildMapper.selectGuildById(task.getGuildId());
            if (guild != null && guild.getGamePartitionId() != null) {
                task.setGamePartitionId(guild.getGamePartitionId());
            }
        }
        return guildTaskMapper.insertGuildTask(task);
    }

    @Override
    public int updateGuildTask(GuildTask task) {
        if (task.getJoinDeadline() != null && task.getJoinDeadline().before(new Date())) {
            throw new ServiceException("接取截止时间不能早于当前时间");
        }
        return guildTaskMapper.updateGuildTask(task);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteGuildTaskById(Long id) {
        taskParticipantMapper.deleteByTaskId(id);
        return guildTaskMapper.deleteGuildTaskById(id);
    }

    @Override
    public int changeStatus(Long id, Integer status) {
        GuildTask task = new GuildTask();
        task.setId(id);
        task.setStatus(status);
        return guildTaskMapper.updateGuildTask(task);
    }

    @Override
    public int completeTask(Long taskId) {
        GuildTask task = guildTaskMapper.selectGuildTaskById(taskId);
        if (task == null) throw new ServiceException("任务不存在");
        if (task.getStatus() != 2) throw new ServiceException("只有进行中的任务才能完成");
        return changeStatus(taskId, 3);
    }

    // ========== 任务自动归档 ==========

    /**
     * 自动归档逻辑：每次查询任务列表时调用
     * 1) 可接取(1) + 超过接取截止 → 人数达标 → 进行中(2); 不达标 → 已过期(4)
     * 2) 进行中(2) + 超过完成时限 → 已过期(4)
     */
    public void autoArchiveTasks(Long guildId) {
        Date now = new Date();
        List<GuildTask> tasks = guildTaskMapper.selectGuildTaskList(guildId, null, null);
        for (GuildTask t : tasks) {
            try {
                if (t.getStatus() == 1 && t.getJoinDeadline() != null && now.after(t.getJoinDeadline())) {
                    // 接取截止，检查人数是否达标
                    int current = t.getCurrentPlayers() != null ? t.getCurrentPlayers() : 0;
                    int min = t.getMinPlayers() != null ? t.getMinPlayers() : 1;
                    if (current >= min) {
                        log.info("任务自动转为进行中 id={}", t.getId());
                        changeStatus(t.getId(), 2);
                    } else {
                        log.info("任务人数不达标，自动归档为已过期 id={}", t.getId());
                        changeStatus(t.getId(), 4);
                    }
                } else if (t.getStatus() == 2 && t.getEndTime() != null && now.after(t.getEndTime())) {
                    log.info("任务超过完成时限，自动归档为已过期 id={}", t.getId());
                    changeStatus(t.getId(), 4);
                }
            } catch (Exception e) {
                log.warn("自动归档任务失败 id={}, {}", t.getId(), e.getMessage());
            }
        }
    }

    // ========== 按用户ID查询参与的任务 ==========

    @Override
    public List<GuildTask> selectTasksByUserId(Long userId, Long guildId) {
        List<Long> taskIds = taskParticipantMapper.selectTaskIdsByUserId(userId);
        if (taskIds == null || taskIds.isEmpty()) {
            return java.util.Collections.emptyList();
        }
        // 先自动归档
        if (guildId != null) {
            autoArchiveTasks(guildId);
        }
        List<GuildTask> allTasks = guildTaskMapper.selectGuildTaskList(guildId, null, null);
        return allTasks.stream()
                .filter(t -> taskIds.contains(t.getId()))
                .collect(java.util.stream.Collectors.toList());
    }
}
