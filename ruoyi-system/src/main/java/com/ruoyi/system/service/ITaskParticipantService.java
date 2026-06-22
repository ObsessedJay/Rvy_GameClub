package com.ruoyi.system.service;

import com.ruoyi.system.domain.TaskParticipant;
import java.util.List;

public interface ITaskParticipantService {
    List<TaskParticipant> selectByTaskId(Long taskId);
    int joinTask(Long taskId, Long userId);
    int quitTask(Long taskId, Long userId);
    int cancelTask(Long taskId, Long userId);
    int readyUp(Long taskId, Long userId);
    int countReady(Long taskId);

    /** 参与者标记任务完成，若全部完成则归档任务 */
    int markComplete(Long taskId, Long userId);

    /** 参与者取消完成标记 */
    int markIncomplete(Long taskId, Long userId);
}