package com.ruoyi.system.service.impl;

import com.ruoyi.system.domain.GuildBlacklist;
import com.ruoyi.system.mapper.GuildBlacklistMapper;
import com.ruoyi.system.service.IGuildBlacklistService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 工会黑名单 Service 实现类
 */
@Service
public class GuildBlacklistServiceImpl implements IGuildBlacklistService {

    @Autowired
    private GuildBlacklistMapper guildBlacklistMapper;

    @Override
    public List<GuildBlacklist> selectGuildBlacklistList(GuildBlacklist blacklist) {
        return guildBlacklistMapper.selectGuildBlacklistList(blacklist);
    }

    @Override
    public GuildBlacklist selectGuildBlacklistById(Long id) {
        return guildBlacklistMapper.selectGuildBlacklistById(id);
    }

    @Override
    public int insertGuildBlacklist(GuildBlacklist blacklist) {
        return guildBlacklistMapper.insertGuildBlacklist(blacklist);
    }

    @Override
    public int updateGuildBlacklist(GuildBlacklist blacklist) {
        return guildBlacklistMapper.updateGuildBlacklist(blacklist);
    }

    @Override
    public int deleteGuildBlacklistById(Long id) {
        return guildBlacklistMapper.deleteGuildBlacklistById(id);
    }

    @Override
    public int deleteGuildBlacklistByIds(Long[] ids) {
        return guildBlacklistMapper.deleteGuildBlacklistByIds(ids);
    }

    @Override
    public int removeGuildBlacklist(Long id) {
        return guildBlacklistMapper.deleteGuildBlacklistById(id);
    }

    @Override
    public boolean isInBlacklist(Long guildId, Long userId) {
        return guildBlacklistMapper.checkBlacklist(guildId, userId) > 0;
    }
}