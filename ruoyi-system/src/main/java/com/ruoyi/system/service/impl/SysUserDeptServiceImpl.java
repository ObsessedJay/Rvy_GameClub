package com.ruoyi.system.service.impl;

import com.ruoyi.common.core.domain.entity.SysUserDept;
import com.ruoyi.common.core.domain.entity.SysWebsiteConfig;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.SysUserPost;
import com.ruoyi.system.mapper.SysUserDeptMapper;
import com.ruoyi.system.mapper.SysUserPostMapper;
import com.ruoyi.system.service.ISysUserDeptService;
import com.ruoyi.system.service.ISysWebsiteConfigService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * 用户-业务网站部门关联表 Service 业务层实现
 * 
 * @author ruoyi
 */
@Service
public class SysUserDeptServiceImpl implements ISysUserDeptService
{
    @Autowired
    private SysUserDeptMapper userDeptMapper;

    @Autowired
    private ISysWebsiteConfigService websiteConfigService;

    @Autowired
    private SysUserPostMapper sysUserPostMapper;

    @Override
    public SysUserDept selectByUserAndWebsite(Long userId, String websiteCode)
    {
        if (userId == null || StringUtils.isEmpty(websiteCode))
        {
            return null;
        }
        return userDeptMapper.selectByUserAndWebsite(userId, websiteCode);
    }

    @Override
    public List<SysUserDept> selectByUserId(Long userId)
    {
        if (userId == null)
        {
            return List.of();
        }
        return userDeptMapper.selectByUserId(userId);
    }

    @Override
    public SysUserDept selectPrimaryByUserId(Long userId)
    {
        if (userId == null)
        {
            return null;
        }
        return userDeptMapper.selectPrimaryByUserId(userId);
    }

    @Override
    public int insertUserDept(SysUserDept userDept)
    {
        if (userDept.getUserId() == null)
        {
            throw new ServiceException("用户ID不能为空");
        }
        if (userDept.getDeptId() == null)
        {
            throw new ServiceException("部门ID不能为空");
        }
        if (StringUtils.isEmpty(userDept.getWebsiteCode()))
        {
            throw new ServiceException("业务网站编码不能为空");
        }
        if (userDept.getJoinedAt() == null)
        {
            userDept.setJoinedAt(new Date());
        }
        return userDeptMapper.insertUserDept(userDept);
    }

    @Override
    public int updateUserDept(SysUserDept userDept)
    {
        return userDeptMapper.updateUserDept(userDept);
    }

    @Override
    public int deleteByUserAndWebsite(Long userId, String websiteCode)
    {
        return userDeptMapper.deleteByUserAndWebsite(userId, websiteCode);
    }

    @Override
    public int deleteById(Long id)
    {
        return userDeptMapper.deleteById(id);
    }

    @Override
    public int deleteByUserId(Long userId)
    {
        return userDeptMapper.deleteByUserId(userId);
    }

    @Override
    public List<SysUserDept> selectByWebsiteCode(String websiteCode)
    {
        return userDeptMapper.selectByWebsiteCode(websiteCode);
    }

    @Override
    public List<SysUserDept> selectByDeptId(Long deptId)
    {
        return userDeptMapper.selectByDeptId(deptId);
    }

    /**
     * 登记用户进入某个业务网站（自动创建或保持部门归属）
     * 
     * 业务逻辑：
     * 1. 查询用户在该网站下是否已有部门关联记录
     * 2. 如有，返回现有记录（不做改动）
     * 3. 如无，创建新记录，部门ID使用该网站的默认部门ID
     */
    @Override
    public SysUserDept registerUserToWebsite(Long userId, String websiteCode)
    {
        if (userId == null || StringUtils.isEmpty(websiteCode))
        {
            throw new ServiceException("用户ID和业务网站编码不能为空");
        }

        // 1. 先查用户在该网站下是否已有关联
        SysUserDept existing = userDeptMapper.selectByUserAndWebsite(userId, websiteCode);
        if (existing != null)
        {
            return existing;
        }

        // 2. 查询该网站的配置，获取默认部门ID
        SysWebsiteConfig config = websiteConfigService.selectByWebsiteCode(websiteCode);
        if (config == null)
        {
            throw new ServiceException("未找到业务网站配置: " + websiteCode);
        }

        // 3. 创建新的关联记录，使用默认部门
        SysUserDept newUserDept = new SysUserDept();
        newUserDept.setUserId(userId);
        newUserDept.setDeptId(config.getDefaultDeptId());
        newUserDept.setWebsiteCode(websiteCode);
        newUserDept.setIsPrimary("DEFAULT".equals(websiteCode) ? 1 : 0);
        newUserDept.setJoinedAt(new Date());
        userDeptMapper.insertUserDept(newUserDept);

        // 首次进入GameClub，分配"无工会用户"岗位(postId=4)
        sysUserPostMapper.deleteUserPostByUserId(userId);
        SysUserPost up = new SysUserPost();
        up.setUserId(userId);
        up.setPostId(4L);
        List<SysUserPost> list = new ArrayList<>();
        list.add(up);
        sysUserPostMapper.batchUserPost(list);

        return userDeptMapper.selectByUserAndWebsite(userId, websiteCode);
    }

    /**
     * 更新用户在某个业务网站的部门归属（如加入工会时）
     */
    @Override
    public SysUserDept updateUserWebsiteDept(Long userId, String websiteCode, Long newDeptId)
    {
        if (userId == null || StringUtils.isEmpty(websiteCode) || newDeptId == null)
        {
            throw new ServiceException("用户ID、业务网站编码和新部门ID不能为空");
        }

        SysUserDept existing = userDeptMapper.selectByUserAndWebsite(userId, websiteCode);
        if (existing == null)
        {
            // 没有现有记录，直接创建一条
            SysUserDept newUserDept = new SysUserDept();
            newUserDept.setUserId(userId);
            newUserDept.setDeptId(newDeptId);
            newUserDept.setWebsiteCode(websiteCode);
            newUserDept.setIsPrimary("DEFAULT".equals(websiteCode) ? 1 : 0);
            newUserDept.setJoinedAt(new Date());
            userDeptMapper.insertUserDept(newUserDept);
        }
        else
        {
            // 更新现有记录的部门ID
            existing.setDeptId(newDeptId);
            existing.setUpdatedAt(new Date());
            userDeptMapper.updateUserDept(existing);
        }

        return userDeptMapper.selectByUserAndWebsite(userId, websiteCode);
    }

    /**
     * 回退用户在某个业务网站的部门归属到默认部门（如退出工会时）
     */
    @Override
    public SysUserDept fallbackToDefaultDept(Long userId, String websiteCode)
    {
        if (userId == null || StringUtils.isEmpty(websiteCode))
        {
            throw new ServiceException("用户ID和业务网站编码不能为空");
        }

        // 查询该网站的默认部门ID
        SysWebsiteConfig config = websiteConfigService.selectByWebsiteCode(websiteCode);
        if (config == null)
        {
            throw new ServiceException("未找到业务网站配置: " + websiteCode);
        }

        SysUserDept existing = userDeptMapper.selectByUserAndWebsite(userId, websiteCode);
        if (existing == null)
        {
            // 没有现有记录，创建一条使用默认部门
            SysUserDept newUserDept = new SysUserDept();
            newUserDept.setUserId(userId);
            newUserDept.setDeptId(config.getDefaultDeptId());
            newUserDept.setWebsiteCode(websiteCode);
            newUserDept.setIsPrimary("DEFAULT".equals(websiteCode) ? 1 : 0);
            newUserDept.setJoinedAt(new Date());
            userDeptMapper.insertUserDept(newUserDept);
        }
        else
        {
            // 更新为默认部门
            existing.setDeptId(config.getDefaultDeptId());
            existing.setUpdatedAt(new Date());
            userDeptMapper.updateUserDept(existing);
        }

        return userDeptMapper.selectByUserAndWebsite(userId, websiteCode);
    }
}
