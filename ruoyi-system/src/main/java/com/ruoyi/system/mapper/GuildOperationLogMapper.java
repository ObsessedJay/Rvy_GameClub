package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.GuildOperationLog;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * 工会操作日志 Mapper 接口
 */
@Mapper
public interface GuildOperationLogMapper {

    /**
     * 查询工会操作日志列表
     *
     * @param log 日志信息
     * @return 日志列表
     */
    List<GuildOperationLog> selectGuildOperationLogList(GuildOperationLog log);

    /**
     * 查询工会操作日志详细
     *
     * @param id 日志ID
     * @return 日志信息
     */
    GuildOperationLog selectGuildOperationLogById(Long id);

    /**
     * 新增工会操作日志
     *
     * @param log 日志信息
     * @return 结果
     */
    int insertGuildOperationLog(GuildOperationLog log);

    /**
     * 删除工会操作日志
     *
     * @param id 日志ID
     * @return 结果
     */
    int deleteGuildOperationLogById(Long id);

    /**
     * 批量删除工会操作日志
     *
     * @param ids 需要删除的数据ID
     * @return 结果
     */
    int deleteGuildOperationLogByIds(Long[] ids);

    /**
     * 清空工会操作日志
     *
     * @param guildId 工会ID
     * @return 结果
     */
    int clearGuildOperationLog(Long guildId);
}