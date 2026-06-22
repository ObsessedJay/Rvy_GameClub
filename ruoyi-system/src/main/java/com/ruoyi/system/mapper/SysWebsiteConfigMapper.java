package com.ruoyi.system.mapper;

import com.ruoyi.common.core.domain.entity.SysWebsiteConfig;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 业务网站配置表 Mapper 接口
 * 
 * @author ruoyi
 */
public interface SysWebsiteConfigMapper
{
    /**
     * 根据业务网站编码查询配置
     */
    public SysWebsiteConfig selectByWebsiteCode(@Param("websiteCode") String websiteCode);

    /**
     * 根据ID查询配置
     */
    public SysWebsiteConfig selectById(@Param("id") Long id);

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
    public int deleteById(@Param("id") Long id);
}
