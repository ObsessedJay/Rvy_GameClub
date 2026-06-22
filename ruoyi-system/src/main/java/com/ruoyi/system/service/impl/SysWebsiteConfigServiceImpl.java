package com.ruoyi.system.service.impl;

import com.ruoyi.common.core.domain.entity.SysWebsiteConfig;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.mapper.SysWebsiteConfigMapper;
import com.ruoyi.system.service.ISysWebsiteConfigService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 业务网站配置表 Service 业务层实现
 * 
 * @author ruoyi
 */
@Service
public class SysWebsiteConfigServiceImpl implements ISysWebsiteConfigService
{
    @Autowired
    private SysWebsiteConfigMapper websiteConfigMapper;

    @Override
    public SysWebsiteConfig selectByWebsiteCode(String websiteCode)
    {
        if (StringUtils.isEmpty(websiteCode))
        {
            return null;
        }
        return websiteConfigMapper.selectByWebsiteCode(websiteCode);
    }

    @Override
    public SysWebsiteConfig selectById(Long id)
    {
        return websiteConfigMapper.selectById(id);
    }

    @Override
    public List<SysWebsiteConfig> selectAll()
    {
        return websiteConfigMapper.selectAll();
    }

    @Override
    public int insertWebsiteConfig(SysWebsiteConfig config)
    {
        if (StringUtils.isEmpty(config.getWebsiteCode()))
        {
            throw new ServiceException("业务网站编码不能为空");
        }
        if (StringUtils.isEmpty(config.getWebsiteName()))
        {
            throw new ServiceException("业务网站名称不能为空");
        }
        if (config.getRootDeptId() == null)
        {
            throw new ServiceException("根部门ID不能为空");
        }
        if (config.getDefaultDeptId() == null)
        {
            throw new ServiceException("默认部门ID不能为空");
        }
        return websiteConfigMapper.insertWebsiteConfig(config);
    }

    @Override
    public int updateWebsiteConfig(SysWebsiteConfig config)
    {
        return websiteConfigMapper.updateWebsiteConfig(config);
    }

    @Override
    public int deleteById(Long id)
    {
        return websiteConfigMapper.deleteById(id);
    }

    @Override
    public Long getDefaultDeptId(String websiteCode)
    {
        SysWebsiteConfig config = selectByWebsiteCode(websiteCode);
        return config != null ? config.getDefaultDeptId() : null;
    }

    @Override
    public Long getRootDeptId(String websiteCode)
    {
        SysWebsiteConfig config = selectByWebsiteCode(websiteCode);
        return config != null ? config.getRootDeptId() : null;
    }
}
