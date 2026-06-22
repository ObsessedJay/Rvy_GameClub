package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.GuildMember;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 工会成员Mapper接口
 * 
 * @author ruoyi
 */
public interface GuildMemberMapper {

    /**
     * 查询工会成员
     * 
     * @param id 记录ID
     * @return 工会成员
     */
    public GuildMember selectGuildMemberById(@Param("id") Long id);

    /**
     * 查询工会成员列表
     * 
     * @param guildId 工会ID
     * @param userId 用户ID
     * @param role 角色
     * @param status 状态
     * @return 工会成员集合
     */
    public List<GuildMember> selectGuildMemberList(@Param("guildId") Long guildId, 
                                                    @Param("userId") Long userId, 
                                                    @Param("role") Integer role, 
                                                    @Param("status") Integer status);

    /**
     * 根据工会ID和用户ID查询
     * 
     * @param guildId 工会ID
     * @param userId 用户ID
     * @return 工会成员
     */
    public GuildMember selectByGuildAndUser(@Param("guildId") Long guildId, @Param("userId") Long userId);

    /**
     * 根据游戏分区和用户ID查询
     * 
     * @param gamePartitionId 游戏分区ID
     * @param userId 用户ID
     * @return 工会成员
     */
    public GuildMember selectByPartitionAndUser(@Param("gamePartitionId") Long gamePartitionId, @Param("userId") Long userId);

    /**
     * 查询工会成员数量
     * 
     * @param guildId 工会ID
     * @return 数量
     */
    public int countByGuildId(@Param("guildId") Long guildId);

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
     * 全量修改工会成员（含 guild_id、game_partition_id、join_time）
     */
    public int updateGuildMemberFull(GuildMember member);

    /**
     * 删除工会成员
     * 
     * @param id 记录ID
     * @return 结果
     */
    public int deleteGuildMemberById(@Param("id") Long id);

    /**
     * 退出工会（更新状态）
     * 
     * @param id 记录ID
     * @return 结果
     */
    public int quitGuild(@Param("id") Long id);
}
