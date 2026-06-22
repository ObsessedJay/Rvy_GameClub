package com.ruoyi.system.service.impl;

import com.ruoyi.system.domain.GuildOperationLog;
import com.ruoyi.system.mapper.GuildOperationLogMapper;
import com.ruoyi.system.service.IGuildOperationLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 工会操作日志 Service 实现类
 */
@Service
public class GuildOperationLogServiceImpl implements IGuildOperationLogService {

    @Autowired
    private GuildOperationLogMapper guildOperationLogMapper;

    @Override
    public List<GuildOperationLog> selectGuildOperationLogList(GuildOperationLog log) {
        return guildOperationLogMapper.selectGuildOperationLogList(log);
    }

    @Override
    public GuildOperationLog selectGuildOperationLogById(Long id) {
        return guildOperationLogMapper.selectGuildOperationLogById(id);
    }

    @Override
    public int insertGuildOperationLog(GuildOperationLog log) {
        return guildOperationLogMapper.insertGuildOperationLog(log);
    }

    @Override
    public int deleteGuildOperationLogById(Long id) {
        return guildOperationLogMapper.deleteGuildOperationLogById(id);
    }

    @Override
    public int deleteGuildOperationLogByIds(Long[] ids) {
        return guildOperationLogMapper.deleteGuildOperationLogByIds(ids);
    }

    @Override
    public int clearGuildOperationLog(Long guildId) {
        return guildOperationLogMapper.clearGuildOperationLog(guildId);
    }
}