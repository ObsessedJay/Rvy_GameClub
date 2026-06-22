package com.ruoyi.system.service.impl;

import com.ruoyi.system.domain.GuildAnnouncement;
import com.ruoyi.system.mapper.GuildAnnouncementMapper;
import com.ruoyi.system.service.IGuildAnnouncementService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 工会公告 Service 实现类
 */
@Service
public class GuildAnnouncementServiceImpl implements IGuildAnnouncementService {

    @Autowired
    private GuildAnnouncementMapper guildAnnouncementMapper;

    @Override
    public List<GuildAnnouncement> selectGuildAnnouncementList(GuildAnnouncement announcement) {
        return guildAnnouncementMapper.selectGuildAnnouncementList(announcement);
    }

    @Override
    public GuildAnnouncement selectGuildAnnouncementById(Long id) {
        return guildAnnouncementMapper.selectGuildAnnouncementById(id);
    }

    @Override
    public int insertGuildAnnouncement(GuildAnnouncement announcement) {
        return guildAnnouncementMapper.insertGuildAnnouncement(announcement);
    }

    @Override
    public int updateGuildAnnouncement(GuildAnnouncement announcement) {
        return guildAnnouncementMapper.updateGuildAnnouncement(announcement);
    }

    @Override
    public int deleteGuildAnnouncementById(Long id) {
        return guildAnnouncementMapper.deleteGuildAnnouncementById(id);
    }

    @Override
    public int deleteGuildAnnouncementByIds(Long[] ids) {
        return guildAnnouncementMapper.deleteGuildAnnouncementByIds(ids);
    }

    @Override
    public int publishGuildAnnouncement(Long id) {
        return guildAnnouncementMapper.publishGuildAnnouncement(id);
    }

    @Override
    public int withdrawGuildAnnouncement(Long id) {
        return guildAnnouncementMapper.withdrawGuildAnnouncement(id);
    }

    @Override
    public List<GuildAnnouncement> selectPublishedAnnouncements() {
        return guildAnnouncementMapper.selectPublishedAnnouncements();
    }
}