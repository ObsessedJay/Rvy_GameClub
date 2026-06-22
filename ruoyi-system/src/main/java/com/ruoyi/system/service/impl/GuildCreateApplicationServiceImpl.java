package com.ruoyi.system.service.impl;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.system.domain.*;
import com.ruoyi.system.mapper.*;
import com.ruoyi.system.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class GuildCreateApplicationServiceImpl implements IGuildCreateApplicationService {

    @Autowired
    private GuildCreateApplicationMapper mapper;

    @Autowired
    private IGuildService guildService;

    @Autowired
    private IGuildMemberService guildMemberService;

    @Override
    public List<GuildCreateApplication> selectList(GuildCreateApplication application) {
        return mapper.selectList(application);
    }

    @Override
    public GuildCreateApplication selectById(Long id) {
        return mapper.selectById(id);
    }

    @Override
    public int insert(GuildCreateApplication application) {
        // 检查同分区是否已有同名待审核/已通过的工会创建申请
        application.setStatus(0);
        return mapper.insert(application);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int approve(Long id, Integer status, String rejectReason, Long reviewerId) {
        GuildCreateApplication app = mapper.selectById(id);
        if (app == null) throw new ServiceException("申请不存在");
        if (app.getStatus() != 0) throw new ServiceException("该申请已审批");

        app.setStatus(status);
        app.setRejectReason(rejectReason);
        app.setReviewerId(reviewerId);
        int result = mapper.approve(app);

        // 通过后创建工会，并将申请人设为会长
        if (status == 1) {
            Guild guild = new Guild();
            guild.setGamePartitionId(app.getGamePartitionId());
            guild.setName(app.getGuildName());
            guild.setDescription(app.getDescription());
            guild.setRecruitRequirement(app.getRecruitRequirement());
            guild.setPresidentId(app.getApplicantId());
            guild.setCreateBy("system");
            guildService.insertGuild(guild);

            // 将申请人添加为会长
            GuildMember member = new GuildMember();
            member.setGuildId(guild.getId());
            member.setGamePartitionId(app.getGamePartitionId());
            member.setUserId(app.getApplicantId());
            member.setRole(1); // 会长
            member.setStatus(1);
            member.setJoinTime(new java.util.Date());
            guildMemberService.insertGuildMember(member);
        }
        return result;
    }

    @Override
    public int deleteById(Long id) {
        return mapper.deleteById(id);
    }
}
