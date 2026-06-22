package com.ruoyi.system.service;

import com.ruoyi.system.domain.Guild;

import java.util.List;

/**
 * 工会Service接口
 * 
 * @author ruoyi
 */
public interface IGuildService {

    /**
     * 查询工会
     * 
     * @param id 工会ID
     * @return 工会
     */
    public Guild selectGuildById(Long id);

    /**
     * 查询工会列表
     * 
     * @param guild 查询条件
     * @return 工会列表
     */
    public List<Guild> selectGuildList(Guild guild);

    /**
     * 新增工会
     * 
     * @param guild 工会
     * @return 结果
     */
    public int insertGuild(Guild guild);

    /**
     * 修改工会
     * 
     * @param guild 工会
     * @return 结果
     */
    public int updateGuild(Guild guild);

    /**
     * 删除工会
     * 
     * @param id 工会ID
     * @return 结果
     */
    public int deleteGuildById(Long id);

    /**
     * 查询用户管理的工会
     * 
     * @param userId 用户ID
     * @return 工会列表
     */
    public List<Guild> selectGuildsByPresidentId(Long userId);

    /**
     * 校验工会名称是否唯一
     * 
     * @param gamePartitionId 游戏分区ID
     * @param name 工会名称
     * @param id 工会ID
     * @return 结果
     */
    public boolean checkNameUnique(Long gamePartitionId, String name, Long id);

    /**
     * 修改工会状态
     * 
     * @param id 工会ID
     * @param status 状态
     * @return 结果
     */
    public int changeStatus(Long id, Integer status);

    /**
     * 更新成员数量
     * 
     * @param id 工会ID
     * @param count 变化数量
     * @return 结果
     */
    public int updateMemberCount(Long id, int count);
}
