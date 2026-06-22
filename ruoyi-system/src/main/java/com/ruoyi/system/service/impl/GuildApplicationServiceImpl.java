package com.ruoyi.system.service.impl;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.system.domain.Guild;
import com.ruoyi.system.domain.GuildApplication;
import com.ruoyi.system.domain.GuildMember;
import com.ruoyi.system.mapper.GuildApplicationMapper;
import com.ruoyi.system.mapper.GuildMapper;
import com.ruoyi.system.mapper.GuildMemberMapper;
import com.ruoyi.system.service.IGuildApplicationService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 工会申请 Service 实现类
 */
@Service
public class GuildApplicationServiceImpl implements IGuildApplicationService {

    private static final Logger log = LoggerFactory.getLogger(GuildApplicationServiceImpl.class);

    @Autowired
    private GuildApplicationMapper guildApplicationMapper;

    @Autowired
    private GuildMapper guildMapper;

    @Autowired
    private GuildMemberMapper guildMemberMapper;

    @Override
    public List<GuildApplication> selectGuildApplicationList(GuildApplication application) {
        return guildApplicationMapper.selectGuildApplicationList(application);
    }

    @Override
    public GuildApplication selectGuildApplicationById(Long id) {
        return guildApplicationMapper.selectGuildApplicationById(id);
    }

    @Override
    public int insertGuildApplication(GuildApplication application) {
        // 从工会信息中获取游戏分区ID
        Guild guild = guildMapper.selectGuildById(application.getGuildId());
        if (guild == null) {
            throw new ServiceException("工会不存在");
        }
        if (guild.getGamePartitionId() != null) {
            GuildMember existingMember = guildMemberMapper.selectByPartitionAndUser(guild.getGamePartitionId(), application.getUserId());
            if (existingMember != null && existingMember.getStatus() == 1) {
                throw new ServiceException("您已加入该游戏分区的工会，不能重复申请！");
            }
            // 将游戏分区ID写入申请记录
            application.setGamePartitionId(guild.getGamePartitionId());
        }
        return guildApplicationMapper.insertGuildApplication(application);
    }

    @Override
    public int updateGuildApplication(GuildApplication application) {
        return guildApplicationMapper.updateGuildApplication(application);
    }

    @Override
    public int deleteGuildApplicationById(Long id) {
        return guildApplicationMapper.deleteGuildApplicationById(id);
    }

    @Override
    public int deleteGuildApplicationByIds(Long[] ids) {
        return guildApplicationMapper.deleteGuildApplicationByIds(ids);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int approveGuildApplication(Long id, Integer status, String remark) {
        GuildApplication application = guildApplicationMapper.selectGuildApplicationById(id);
        if (application == null) {
            throw new ServiceException("申请不存在");
        }
        if (application.getStatus() != 0) {
            throw new ServiceException("该申请已审批");
        }
        log.info("审批申请 id={}, status={}, guildId={}, userId={}", id, status, application.getGuildId(), application.getUserId());

        application.setStatus(status);
        application.setRejectReason(remark);
        int result = guildApplicationMapper.approveGuildApplication(application);
        log.info("申请状态已更新 id={}, result={}", id, result);

        // 审批通过时，将用户加入工会成员表
        if (status == 1) {
            Long guildId = application.getGuildId();
            Long userId = application.getUserId();
            Long gamePartitionId = application.getGamePartitionId();
            if (gamePartitionId == null) {
                Guild guild = guildMapper.selectGuildById(guildId);
                if (guild != null) {
                    gamePartitionId = guild.getGamePartitionId();
                }
            }
            log.info("开始添加成员 guildId={}, gamePartitionId={}, userId={}", guildId, gamePartitionId, userId);

            // 先按分区+用户查找（匹配表唯一键 uk_partition_user），不限 status
            List<GuildMember> allMembers = guildMemberMapper.selectGuildMemberList(null, userId, null, null);
            GuildMember existing = null;
            for (GuildMember m : allMembers) {
                if (gamePartitionId != null && gamePartitionId.equals(m.getGamePartitionId())) {
                    existing = m;
                    break;
                }
            }

            if (existing != null) {
                log.info("找到已有成员记录 id={}, guildId={}, status={}", existing.getId(), existing.getGuildId(), existing.getStatus());
                // 更新该记录为当前工会、状态正常
                existing.setGuildId(guildId);
                existing.setGamePartitionId(gamePartitionId);
                existing.setRole(3);
                existing.setStatus(1);
                existing.setJoinTime(new java.util.Date());
                guildMemberMapper.updateGuildMemberFull(existing);
                log.info("已更新成员记录 id={}", existing.getId());
            } else {
                GuildMember member = new GuildMember();
                member.setGuildId(guildId);
                member.setGamePartitionId(gamePartitionId);
                member.setUserId(userId);
                member.setRole(3);
                member.setStatus(1);
                member.setJoinTime(new java.util.Date());
                int ins = guildMemberMapper.insertGuildMember(member);
                log.info("新增成员结果 ins={}, generatedId={}", ins, member.getId());
                if (ins <= 0) {
                    throw new ServiceException("添加工会成员失败");
                }
            }
        }
        return result;
    }

    @Override
    public int batchApproveGuildApplication(Long[] ids, Integer status) {
        return guildApplicationMapper.batchApproveGuildApplication(ids, status);
    }
}