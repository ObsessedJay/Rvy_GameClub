package com.ruoyi.system.mapper;

import com.ruoyi.common.core.domain.entity.SysUserDept;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 用户-业务网站部门关联表 Mapper 接口
 * 
 * @author ruoyi
 */
public interface SysUserDeptMapper
{
    /**
     * 根据用户ID和业务网站编码查询关联记录
     */
    public SysUserDept selectByUserAndWebsite(@Param("userId") Long userId, @Param("websiteCode") String websiteCode);

    /**
     * 查询用户的所有部门关联记录
     */
    public List<SysUserDept> selectByUserId(@Param("userId") Long userId);

    /**
     * 查询用户的主部门关联记录
     */
    public SysUserDept selectPrimaryByUserId(@Param("userId") Long userId);

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
    public int deleteByUserAndWebsite(@Param("userId") Long userId, @Param("websiteCode") String websiteCode);

    /**
     * 根据ID删除关联记录
     */
    public int deleteById(@Param("id") Long id);

    /**
     * 根据用户ID删除所有关联记录
     */
    public int deleteByUserId(@Param("userId") Long userId);

    /**
     * 查询某个业务网站下的用户关联列表
     */
    public List<SysUserDept> selectByWebsiteCode(@Param("websiteCode") String websiteCode);

    /**
     * 查询某个部门下的用户关联列表
     */
    public List<SysUserDept> selectByDeptId(@Param("deptId") Long deptId);
}
