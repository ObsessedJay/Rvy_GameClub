package com.ruoyi.system.service;

import com.ruoyi.system.domain.GuildMessage;

import java.util.List;

/**
 * 工会消息Service接口
 * 
 * @author ruoyi
 */
public interface IGuildMessageService {

    /**
     * 查询工会消息
     * 
     * @param id 消息ID
     * @return 工会消息
     */
    public GuildMessage selectGuildMessageById(Long id);

    /**
     * 查询工会消息列表
     * 
     * @param message 查询条件
     * @return 工会消息列表
     */
    public List<GuildMessage> selectGuildMessageList(GuildMessage message);

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
    public int deleteGuildMessageById(Long id);

    /**
     * 标记为已读
     * 
     * @param id 消息ID
     * @return 结果
     */
    public int markAsRead(Long id);

    /**
     * 批量标记为已读
     * 
     * @param receiverId 接收者ID
     * @return 结果
     */
    public int markAllAsRead(Long receiverId);

    /**
     * 查询未读消息数量
     * 
     * @param receiverId 接收者ID
     * @return 数量
     */
    public int countUnread(Long receiverId);
}
