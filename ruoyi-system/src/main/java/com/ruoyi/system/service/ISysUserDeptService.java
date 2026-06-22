package com.ruoyi.system.service;

import com.ruoyi.common.core.domain.entity.SysUserDept;

import java.util.List;

/**
 * 用户-业务网站部门关联表 Service 接口
 * 
 * @author ruoyi
 */
public interface ISysUserDeptService
{
    /**
     * 根据用户ID和业务网站编码查询关联记录
     */
    public SysUserDept selectByUserAndWebsite(Long userId, String websiteCode);

    /**
     * 查询用户的所有部门关联记录
     */
    public List<SysUserDept> selectByUserId(Long userId);

    /**
     * 查询用户的主部门关联记录
     */
    public SysUserDept selectPrimaryByUserId(Long userId);

    /**
     * 新增用户-部门关联
     */
    public int insertUserDept(SysUserDept userDept);

    /**
     * 更新用户-部门关联
     */
    public int updateUserDept(SysUserDept userDept);

    /**
     * 根据用户ID和业务网站编码删除关联记录
     */
    public int deleteByUserAndWebsite(Long userId, String websiteCode);

    /**
     * 根据ID删除关联记录
     */
    public int deleteById(Long id);

    /**
     * 根据用户ID删除所有关联记录
     */
    public int deleteByUserId(Long userId);

    /**
     * 查询某个业务网站下的用户关联列表
     */
    public List<SysUserDept> selectByWebsiteCode(String websiteCode);

    /**
     * 查询某个部门下的用户关联列表
     */
    public List<SysUserDept> selectByDeptId(Long deptId);

    /**
     * 登记用户进入某个业务网站（自动创建或保持部门归属）
     * @param userId 用户ID
     * @param websiteCode 业务网站编码
     * @return 最新的关联记录
     */
    public SysUserDept registerUserToWebsite(Long userId, String websiteCode);

    /**
     * 更新用户在某个业务网站的部门归属（如加入工会时）
     * @param userId 用户ID
     * @param websiteCode 业务网站编码
     * @param newDeptId 新的部门ID
     * @return 最新的关联记录
     */
    public SysUserDept updateUserWebsiteDept(Long userId, String websiteCode, Long newDeptId);

    /**
     * 回退用户在某个业务网站的部门归属到默认部门（如退出工会时）
     * @param userId 用户ID
     * @param websiteCode 业务网站编码
     * @return 最新的关联记录
     */
    public SysUserDept fallbackToDefaultDept(Long userId, String websiteCode);
}
