package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.Guild;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 工会Mapper接口
 * 
 * @author ruoyi
 */
public interface GuildMapper {

    /**
     * 查询工会
     * 
     * @param id 工会ID
     * @return 工会
     */
    public Guild selectGuildById(@Param("id") Long id);

    /**
     * 查询工会列表
     * 
     * @param gamePartitionId 游戏分区ID
     * @param name 工会名称
     * @param status 状态
     * @return 工会集合
     */
    public List<Guild> selectGuildList(@Param("gamePartitionId") Long gamePartitionId, 
                                        @Param("name") String name, 
                                        @Param("status") Integer status);

    /**
     * 根据游戏分区和工会名称查询
     * 
     * @param gamePartitionId 游戏分区ID
     * @param name 工会名称
     * @return 工会
     */
    public Guild selectByPartitionAndName(@Param("gamePartitionId") Long gamePartitionId, @Param("name") String name);

    /**
     * 校验工会名称是否唯一
     * 
     * @param gamePartitionId 游戏分区ID
     * @param name 工会名称
     * @param id 工会ID
     * @return 结果
     */
    public int checkNameUnique(@Param("gamePartitionId") Long gamePartitionId, 
                               @Param("name") String name, 
                               @Param("id") Long id);

    /**
     * 查询用户管理的工会
     * 
     * @param userId 用户ID
     * @return 工会列表
     */
    public List<Guild> selectGuildsByPresidentId(@Param("userId") Long userId);

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
     * 删除工会（软删除）
     * 
     * @param id 工会ID
     * @return 结果
     */
    public int deleteGuildById(@Param("id") Long id);

    /**
     * 更新成员数量
     * 
     * @param id 工会ID
     * @param count 变化数量
     * @return 结果
     */
    public int updateMemberCount(@Param("id") Long id, @Param("count") int count);
}
