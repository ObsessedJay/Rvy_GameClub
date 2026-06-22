package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.TaskParticipant;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface TaskParticipantMapper {

    List<TaskParticipant> selectByTaskId(@Param("taskId") Long taskId);

    TaskParticipant selectByTaskAndUser(@Param("taskId") Long taskId, @Param("userId") Long userId);

    /** 查询用户参与的所有任务 */
    List<Long> selectTaskIdsByUserId(@Param("userId") Long userId);

    int insert(TaskParticipant p);

    int deleteById(@Param("id") Long id);

    int deleteByTaskAndUser(@Param("taskId") Long taskId, @Param("userId") Long userId);

    int deleteByTaskId(@Param("taskId") Long taskId);

    int updateStatus(@Param("id") Long id, @Param("status") Integer status);

    int countByTaskAndStatus(@Param("taskId") Long taskId, @Param("status") Integer status);
}
