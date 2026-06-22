package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.GuildMessage;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 工会消息Mapper接口
 * 
 * @author ruoyi
 */
public interface GuildMessageMapper {

    /**
     * 查询工会消息
     * 
     * @param id 消息ID
     * @return 工会消息
     */
    public GuildMessage selectGuildMessageById(@Param("id") Long id);

    /**
     * 查询工会消息列表
     * 
     * @param receiverId 接收者ID
     * @param guildId 工会ID
     * @param msgType 消息类型
     * @param status 状态
     * @return 工会消息集合
     */
    public List<GuildMessage> selectGuildMessageList(@Param("receiverId") Long receiverId, 
                                                      @Param("guildId") Long guildId, 
                                                      @Param("msgType") Integer msgType, 
                                                      @Param("status") Integer status);

    /**
     * 查询未读消息数量
     * 
     * @param receiverId 接收者ID
     * @return 数量
     */
    public int countUnread(@Param("receiverId") Long receiverId);

    /**
     * 新增工会消息
     * 
     * @param message 工会消息
     * @return 结果
     */
    public int insertGuildMessage(GuildMessage message);

    /**
     * 修改工会消息
     * 
     * @param message 工会消息
     * @return 结果
     */
    public int updateGuildMessage(GuildMessage message);

    /**
     * 删除工会消息
     * 
     * @param id 消息ID
     * @return 结果
     */
    public int deleteGuildMessageById(@Param("id") Long id);

    /**
     * 标记为已读
     * 
     * @param id 消息ID
     * @return 结果
     */
    public int markAsRead(@Param("id") Long id);

    /**
     * 批量标记为已读
     * 
     * @param receiverId 接收者ID
     * @return 结果
     */
    public int markAllAsRead(@Param("receiverId") Long receiverId);
}
