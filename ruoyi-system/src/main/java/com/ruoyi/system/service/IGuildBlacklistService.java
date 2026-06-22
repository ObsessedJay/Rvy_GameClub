package com.ruoyi.system.service;

import com.ruoyi.system.domain.GuildBlacklist;

import java.util.List;

/**
 * 工会黑名单 Service 接口
 */
public interface IGuildBlacklistService {

    /**
     * 查询工会黑名单列表
     *
     * @param blacklist 黑名单信息
     * @return 黑名单列表
     */
    List<GuildBlacklist> selectGuildBlacklistList(GuildBlacklist blacklist);

    /**
     * 查询工会黑名单详细
     *
     * @param id 黑名单ID
     * @return 黑名单信息
     */
    GuildBlacklist selectGuildBlacklistById(Long id);

    /**
     * 新增工会黑名单
     *
     * @param blacklist 黑名单信息
     * @return 结果
     */
    int insertGuildBlacklist(GuildBlacklist blacklist);

    /**
     * 修改工会黑名单
     *
     * @param blacklist 黑名单信息
     * @return 结果
     */
    int updateGuildBlacklist(GuildBlacklist blacklist);

    /**
     * 删除工会黑名单
     *
     * @param id 黑名单ID
     * @return 结果
     */
    int deleteGuildBlacklistById(Long id);

    /**
     * 批量删除工会黑名单
     *
     * @param ids 需要删除的数据ID
     * @return 结果
     */
    int deleteGuildBlacklistByIds(Long[] ids);

    /**
     * 解除黑名单
     *
     * @param id 黑名单ID
     * @return 结果
     */
    int removeGuildBlacklist(Long id);

    /**
     * 检查用户是否在黑名单中
     *
     * @param guildId 工会ID
     * @param userId  用户ID
     * @return 是否在黑名单中
     */
    boolean isInBlacklist(Long guildId, Long userId);
}