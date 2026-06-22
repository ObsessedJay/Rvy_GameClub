package com.ruoyi.system.service.impl;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.GuildMessage;
import com.ruoyi.system.mapper.GuildMessageMapper;
import com.ruoyi.system.service.IGuildMessageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 工会消息Service业务层处理
 * 
 * @author ruoyi
 */
@Service
public class GuildMessageServiceImpl implements IGuildMessageService {

    @Autowired
    private GuildMessageMapper guildMessageMapper;

    /**
     * 查询工会消息
     * 
     * @param id 消息ID
     * @return 工会消息
     */
    @Override
    public GuildMessage selectGuildMessageById(Long id) {
        return guildMessageMapper.selectGuildMessageById(id);
    }

    /**
     * 查询工会消息列表
     * 
     * @param message 查询条件
     * @return 工会消息列表
     */
    @Override
    public List<GuildMessage> selectGuildMessageList(GuildMessage message) {
        return guildMessageMapper.selectGuildMessageList(message.getReceiverId(), message.getGuildId(), message.getMsgType(), message.getStatus());
    }

    /**
     * 新增工会消息
     * 
     * @param message 工会消息
     * @return 结果
     */
    @Override
    public int insertGuildMessage(GuildMessage message) {
        if (StringUtils.isEmpty(message.getTitle())) {
            throw new ServiceException("消息标题不能为空！");
        }
        if (message.getReceiverId() == null) {
            throw new ServiceException("接收者不能为空！");
        }
        if (message.getStatus() == null) {
            message.setStatus(0); // 默认未读
        }
        return guildMessageMapper.insertGuildMessage(message);
    }

    /**
     * 修改工会消息
     * 
     * @param message 工会消息
     * @return 结果
     */
    @Override
    public int updateGuildMessage(GuildMessage message) {
        return guildMessageMapper.updateGuildMessage(message);
    }

    /**
     * 删除工会消息
     * 
     * @param id 消息ID
     * @return 结果
     */
    @Override
    public int deleteGuildMessageById(Long id) {
        return guildMessageMapper.deleteGuildMessageById(id);
    }

    /**
     * 标记为已读
     * 
     * @param id 消息ID
     * @return 结果
     */
    @Override
    public int markAsRead(Long id) {
        return guildMessageMapper.markAsRead(id);
    }

    /**
     * 批量标记为已读
     * 
     * @param receiverId 接收者ID
     * @return 结果
     */
    @Override
    public int markAllAsRead(Long receiverId) {
        return guildMessageMapper.markAllAsRead(receiverId);
    }

    /**
     * 查询未读消息数量
     * 
     * @param receiverId 接收者ID
     * @return 数量
     */
    @Override
    public int countUnread(Long receiverId) {
        return guildMessageMapper.countUnread(receiverId);
    }
}
