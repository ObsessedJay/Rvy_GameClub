package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.GuildAnnouncement;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 工会公告 Mapper 接口
 */
@Mapper
public interface GuildAnnouncementMapper {

    /**
     * 查询工会公告列表
     *
     * @param announcement 公告信息
     * @return 公告列表
     */
    List<GuildAnnouncement> selectGuildAnnouncementList(GuildAnnouncement announcement);

    /**
     * 查询工会公告详细
     *
     * @param id 公告ID
     * @return 公告信息
     */
    GuildAnnouncement selectGuildAnnouncementById(Long id);

    /**
     * 新增工会公告
     *
     * @param announcement 公告信息
     * @return 结果
     */
    int insertGuildAnnouncement(GuildAnnouncement announcement);

    /**
     * 修改工会公告
     *
     * @param announcement 公告信息
     * @return 结果
     */
    int updateGuildAnnouncement(GuildAnnouncement announcement);

    /**
     * 删除工会公告
     *
     * @param id 公告ID
     * @return 结果
     */
    int deleteGuildAnnouncementById(Long id);

    /**
     * 批量删除工会公告
     *
     * @param ids 需要删除的数据ID
     * @return 结果
     */
    int deleteGuildAnnouncementByIds(Long[] ids);

    /**
     * 发布公告
     *
     * @param id 公告ID
     * @return 结果
     */
    int publishGuildAnnouncement(Long id);

    /**
     * 撤回公告
     *
     * @param id 公告ID
     * @return 结果
     */
    int withdrawGuildAnnouncement(Long id);

    /**
     * 查询所有已发布的公告（公开接口）
     *
     * @return 已发布的公告列表
     */
    List<GuildAnnouncement> selectPublishedAnnouncements();
}