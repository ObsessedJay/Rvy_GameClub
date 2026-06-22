package com.ruoyi.system.service;

import com.ruoyi.system.domain.GuildMember;

import java.util.List;

/**
 * 工会成员Service接口
 * 
 * @author ruoyi
 */
public interface IGuildMemberService {

    /**
     * 查询工会成员
     * 
     * @param id 记录ID
     * @return 工会成员
     */
    public GuildMember selectGuildMemberById(Long id);

    /**
     * 查询工会成员列表
     * 
     * @param member 查询条件
     * @return 工会成员列表
     */
    public List<GuildMember> selectGuildMemberList(GuildMember member);

    /**
     * 新增工会成员
     * 
     * @param member 工会成员
     * @return 结果
     */
    public int insertGuildMember(GuildMember member);

    /**
     * 修改工会成员
     * 
     * @param member 工会成员
     * @return 结果
     */
    public int updateGuildMember(GuildMember member);

    /**
     * 删除工会成员
     * 
     * @param id 记录ID
     * @return 结果
     */
    public int deleteGuildMemberById(Long id);

    /**
     * 退出工会
     * 
     * @param id 记录ID
     * @return 结果
     */
    public int quitGuild(Long id);

    /**
     * 根据游戏分区和用户查询成员
     * 
     * @param gamePartitionId 游戏分区ID
     * @param userId 用户ID
     * @return 工会成员
     */
    public GuildMember selectByPartitionAndUser(Long gamePartitionId, Long userId);

    /**
     * 修改成员角色
     * 
     * @param id 记录ID
     * @param role 角色
     * @return 结果
     */
    public int changeRole(Long id, Integer role);
}
