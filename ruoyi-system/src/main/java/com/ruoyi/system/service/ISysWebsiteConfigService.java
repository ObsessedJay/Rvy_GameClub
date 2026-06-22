package com.ruoyi.system.service;

import com.ruoyi.common.core.domain.entity.SysWebsiteConfig;

import java.util.List;

/**
 * 业务网站配置表 Service 接口
 * 
 * @author ruoyi
 */
public interface ISysWebsiteConfigService
{
    /**
     * 根据业务网站编码查询配置
     */
    public SysWebsiteConfig selectByWebsiteCode(String websiteCode);

    /**
     * 根据ID查询配置
     */
    public SysWebsiteConfig selectById(Long id);

    /**
     * 查询所有业务网站配置
     */
    public List<SysWebsiteConfig> selectAll();

    /**
     * 新增业务网站配置
     */
    public int insertWebsiteConfig(SysWebsiteConfig config);

    /**
     * 更新业务网站配置
     */
    public int updateWebsiteConfig(SysWebsiteConfig config);

    /**
     * 删除业务网站配置
     */
    public int deleteById(Long id);

    /**
     * 获取某个业务网站的默认部门ID
     */
    public Long getDefaultDeptId(String websiteCode);

    /**
     * 获取某个业务网站的根部门ID
     */
    public Long getRootDeptId(String websiteCode);
}
