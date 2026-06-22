package com.ruoyi.system.service.impl;

import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.core.domain.entity.SysWebsiteConfig;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.system.domain.Guild;
import com.ruoyi.system.domain.GuildMember;
import com.ruoyi.system.domain.SysUserPost;
import com.ruoyi.system.mapper.GuildMemberMapper;
import com.ruoyi.system.mapper.GuildMapper;
import com.ruoyi.system.mapper.SysUserMapper;
import com.ruoyi.system.mapper.SysUserPostMapper;
import com.ruoyi.system.service.IGuildMemberService;
import com.ruoyi.system.service.ISysUserDeptService;
import com.ruoyi.system.service.ISysWebsiteConfigService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * 工会成员Service业务层处理
 * 
 * @author ruoyi
 */
@Service
public class GuildMemberServiceImpl implements IGuildMemberService {

    @Autowired
    private GuildMemberMapper guildMemberMapper;

    @Autowired
    private GuildMapper guildMapper;

    @Autowired
    private ISysUserDeptService userDeptService;

    @Autowired
    private SysUserMapper sysUserMapper;

    @Autowired
    private ISysWebsiteConfigService websiteConfigService;

    @Autowired
    private SysUserPostMapper sysUserPostMapper;

    /**
     * 查询工会成员
     * 
     * @param id 记录ID
     * @return 工会成员
     */
    @Override
    public GuildMember selectGuildMemberById(Long id) {
        return guildMemberMapper.selectGuildMemberById(id);
    }

    /**
     * 查询工会成员列表
     * 
     * @param member 查询条件
     * @return 工会成员列表
     */
    @Override
    public List<GuildMember> selectGuildMemberList(GuildMember member) {
        return guildMemberMapper.selectGuildMemberList(member.getGuildId(), member.getUserId(), member.getRole(), member.getStatus());
    }

    /**
     * 新增工会成员
     * 
     * @param member 工会成员
     * @return 结果
     */
    @Override
    @Transactional
    public int insertGuildMember(GuildMember member) {
        // 检查用户是否已在该游戏分区的其他工会
        GuildMember existing = guildMemberMapper.selectByPartitionAndUser(member.getGamePartitionId(), member.getUserId());
        if (existing != null) {
            throw new ServiceException("该用户已在此游戏分区的其他工会中，请先退出原工会！");
        }

        // 检查用户是否已在该工会
        GuildMember inGuild = guildMemberMapper.selectByGuildAndUser(member.getGuildId(), member.getUserId());
        if (inGuild != null) {
            if (inGuild.getStatus() == 1) {
                throw new ServiceException("该用户已在此工会中！");
            } else {
                // 重新加入，更新状态
                inGuild.setStatus(1);
                inGuild.setJoinTime(new Date());
                inGuild.setRole(member.getRole() != null ? member.getRole() : 3);
                return guildMemberMapper.updateGuildMember(inGuild);
            }
        }

        // 设置默认值
        if (member.getRole() == null) {
            member.setRole(3); // 默认普通成员
        }
        if (member.getStatus() == null) {
            member.setStatus(1); // 默认正常
        }
        if (member.getJoinTime() == null) {
            member.setJoinTime(new Date());
        }

        int result = guildMemberMapper.insertGuildMember(member);

        // 更新工会成员数量
        if (result > 0) {
            guildMapper.updateMemberCount(member.getGuildId(), 1);

            // 方案C：加入工会后，更新用户在GameClub下的部门归属为该工会部门
            if (member.getUserId() != null) {
                Guild guild = guildMapper.selectGuildById(member.getGuildId());
                if (guild != null && guild.getDeptId() != null) {
                    userDeptService.updateUserWebsiteDept(member.getUserId(), "GAMECLUB", guild.getDeptId());
                    // 同时更新用户主部门，让组织机构页面能正确显示
                    SysUser user = new SysUser();
                    user.setUserId(member.getUserId());
                    user.setDeptId(guild.getDeptId());
                    sysUserMapper.updateUser(user);
                    // 根据角色分配用户岗位
                    assignUserPost(member.getUserId(), member.getRole());
                }
            }
        }

        return result;
    }

    /**
     * 修改工会成员
     * 
     * @param member 工会成员
     * @return 结果
     */
    @Override
    public int updateGuildMember(GuildMember member) {
        return guildMemberMapper.updateGuildMember(member);
    }

    /**
     * 删除工会成员
     * 
     * @param id 记录ID
     * @return 结果
     */
    @Override
    @Transactional
    public int deleteGuildMemberById(Long id) {
        GuildMember member = guildMemberMapper.selectGuildMemberById(id);
        int result = guildMemberMapper.deleteGuildMemberById(id);

        // 更新工会成员数量
        if (result > 0 && member != null && member.getStatus() == 1) {
            guildMapper.updateMemberCount(member.getGuildId(), -1);

            // 方案C：删除成员后回退部门归属到默认部门
            if (member.getUserId() != null) {
                userDeptService.fallbackToDefaultDept(member.getUserId(), "GAMECLUB");
                // 同时更新用户主部门为无工会用户部门
                SysWebsiteConfig config = websiteConfigService.selectByWebsiteCode("GAMECLUB");
                if (config != null && config.getDefaultDeptId() != null) {
                    SysUser user = new SysUser();
                    user.setUserId(member.getUserId());
                    user.setDeptId(config.getDefaultDeptId());
                    sysUserMapper.updateUser(user);
                    // 回退岗位为无工会用户(postId=4)
                    assignUserPost(member.getUserId(), 4);
                }
            }
        }

        return result;
    }

    /**
     * 退出工会
     * 
     * @param id 记录ID
     * @return 结果
     */
    @Override
    @Transactional
    public int quitGuild(Long id) {
        GuildMember member = guildMemberMapper.selectGuildMemberById(id);
        if (member == null) {
            throw new ServiceException("成员不存在！");
        }
        if (member.getStatus() == 0) {
            throw new ServiceException("该成员已退出工会！");
        }
        if (member.getRole() == 1) {
            throw new ServiceException("会长不能退出工会，请先转让会长职位！");
        }

        int result = guildMemberMapper.quitGuild(id);

        // 更新工会成员数量
        if (result > 0) {
            guildMapper.updateMemberCount(member.getGuildId(), -1);

            // 方案C：退出工会后，将用户在GameClub下的部门归属回退到默认部门（无工会用户区）
            if (member.getUserId() != null) {
                userDeptService.fallbackToDefaultDept(member.getUserId(), "GAMECLUB");
                // 同时更新用户主部门为无工会用户部门
                SysWebsiteConfig config = websiteConfigService.selectByWebsiteCode("GAMECLUB");
                if (config != null && config.getDefaultDeptId() != null) {
                    SysUser user = new SysUser();
                    user.setUserId(member.getUserId());
                    user.setDeptId(config.getDefaultDeptId());
                    sysUserMapper.updateUser(user);
                    // 回退岗位为无工会用户(postId=4)
                    assignUserPost(member.getUserId(), 4);
                }
            }
        }

        return result;
    }

    /**
     * 根据游戏分区和用户查询成员
     * 
     * @param gamePartitionId 游戏分区ID
     * @param userId 用户ID
     * @return 工会成员
     */
    @Override
    public GuildMember selectByPartitionAndUser(Long gamePartitionId, Long userId) {
        return guildMemberMapper.selectByPartitionAndUser(gamePartitionId, userId);
    }

    /**
     * 修改成员角色
     * 
     * @param id 记录ID
     * @param role 角色
     * @return 结果
     */
    @Override
    public int changeRole(Long id, Integer role) {
        GuildMember member = new GuildMember();
        member.setId(id);
        member.setRole(role);
        return guildMemberMapper.updateGuildMember(member);
    }

    /**
     * 根据角色分配用户岗位
     * role: 1-会长→postId=1, 2-管理员→postId=2, 3-普通成员→postId=3, 4-无工会用户→postId=4
     */
    private void assignUserPost(Long userId, Integer role) {
        // 先删除用户原有岗位
        sysUserPostMapper.deleteUserPostByUserId(userId);
        // 插入新岗位
        Long postId = (role != null && role >= 1 && role <= 3) ? role.longValue() : 4L;
        SysUserPost up = new SysUserPost();
        up.setUserId(userId);
        up.setPostId(postId);
        List<SysUserPost> list = new ArrayList<>();
        list.add(up);
        sysUserPostMapper.batchUserPost(list);
    }
}
