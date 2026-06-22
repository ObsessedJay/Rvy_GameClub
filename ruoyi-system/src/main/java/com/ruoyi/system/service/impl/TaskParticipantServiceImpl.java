package com.ruoyi.system.service.impl;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.system.domain.GuildTask;
import com.ruoyi.system.domain.TaskParticipant;
import com.ruoyi.system.mapper.GuildTaskMapper;
import com.ruoyi.system.mapper.TaskParticipantMapper;
import com.ruoyi.system.service.ITaskParticipantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class TaskParticipantServiceImpl implements ITaskParticipantService {

    @Autowired
    private TaskParticipantMapper participantMapper;

    @Autowired
    private GuildTaskMapper taskMapper;

    @Override
    public List<TaskParticipant> selectByTaskId(Long taskId) {
        return participantMapper.selectByTaskId(taskId);
    }

    @Override
    @Transactional
    public int joinTask(Long taskId, Long userId) {
        GuildTask task = taskMapper.selectGuildTaskById(taskId);
        if (task == null) throw new ServiceException("任务不存在");
        if (task.getStatus() != 1) throw new ServiceException("任务当前不可接取");

        int current = task.getCurrentPlayers() != null ? task.getCurrentPlayers() : 0;
        int max = task.getMaxPlayers() != null ? task.getMaxPlayers() : Integer.MAX_VALUE;
        if (current >= max) throw new ServiceException("任务人数已满");

        TaskParticipant existing = participantMapper.selectByTaskAndUser(taskId, userId);
        if (existing != null) throw new ServiceException("您已接取该任务");

        TaskParticipant tp = new TaskParticipant();
        tp.setTaskId(taskId);
        tp.setUserId(userId);
        tp.setStatus(1);
        int result = participantMapper.insert(tp);
        if (result > 0) {
            taskMapper.incrCurrentPlayers(taskId, 1);
        }
        return result;
    }

    @Override
    @Transactional
    public int quitTask(Long taskId, Long userId) {
        GuildTask task = taskMapper.selectGuildTaskById(taskId);
        if (task == null) throw new ServiceException("任务不存在");
        if (task.getStatus() != 1) throw new ServiceException("任务不可接取，无法取消");

        int result = participantMapper.deleteByTaskAndUser(taskId, userId);
        if (result > 0) {
            taskMapper.incrCurrentPlayers(taskId, -1);
        }
        return result;
    }

    @Override
    @Transactional
    public int cancelTask(Long taskId, Long userId) {
        GuildTask task = taskMapper.selectGuildTaskById(taskId);
        if (task == null) throw new ServiceException("任务不存在");
        if (task.getStatus() != 1 && task.getStatus() != 2) throw new ServiceException("任务当前不可取消接取");

        TaskParticipant tp = participantMapper.selectByTaskAndUser(taskId, userId);
        if (tp == null) throw new ServiceException("您未接取该任务");
        if (tp.getStatus() == 3) throw new ServiceException("任务已完成，无法取消");

        int result = participantMapper.deleteByTaskAndUser(taskId, userId);
        if (result > 0) {
            taskMapper.incrCurrentPlayers(taskId, -1);
        }
        return result;
    }

    @Override
    public int readyUp(Long taskId, Long userId) {
        TaskParticipant tp = participantMapper.selectByTaskAndUser(taskId, userId);
        if (tp == null) throw new ServiceException("您未接取该任务");
        if (tp.getStatus() != 1) throw new ServiceException("当前状态不可准备");
        return participantMapper.updateStatus(tp.getId(), 2);
    }

    @Override
    @Transactional
    public int markComplete(Long taskId, Long userId) {
        GuildTask task = taskMapper.selectGuildTaskById(taskId);
        if (task == null) throw new ServiceException("任务不存在");
        if (task.getStatus() != 2) throw new ServiceException("只有进行中的任务才能标记完成");

        TaskParticipant tp = participantMapper.selectByTaskAndUser(taskId, userId);
        if (tp == null) throw new ServiceException("您未接取该任务");
        if (tp.getStatus() == 3) throw new ServiceException("已标记为完成");

        int result = participantMapper.updateStatus(tp.getId(), 3);

        // 检查是否所有参与者都已完成
        List<TaskParticipant> all = participantMapper.selectByTaskId(taskId);
        boolean allDone = all.stream().allMatch(p -> p.getStatus() == 3);
        if (allDone) {
            GuildTask updateTask = new GuildTask();
            updateTask.setId(taskId);
            updateTask.setStatus(3); // 已完成
            taskMapper.updateGuildTask(updateTask);
        }
        return result;
    }

    @Override
    @Transactional
    public int markIncomplete(Long taskId, Long userId) {
        GuildTask task = taskMapper.selectGuildTaskById(taskId);
        if (task == null) throw new ServiceException("任务不存在");
        if (task.getStatus() != 2) throw new ServiceException("只有进行中的任务才能重置状态");

        TaskParticipant tp = participantMapper.selectByTaskAndUser(taskId, userId);
        if (tp == null) throw new ServiceException("您未接取该任务");
        if (tp.getStatus() != 3) throw new ServiceException("当前状态不是已完成");

        // 如果任务整体已完成，先回退到进行中
        if (task.getStatus() == 3) {
            GuildTask updateTask = new GuildTask();
            updateTask.setId(taskId);
            updateTask.setStatus(2);
            taskMapper.updateGuildTask(updateTask);
        }
        return participantMapper.updateStatus(tp.getId(), 1);
    }

    @Override
    public int countReady(Long taskId) {
        return participantMapper.countByTaskAndStatus(taskId, 2);
    }
}
