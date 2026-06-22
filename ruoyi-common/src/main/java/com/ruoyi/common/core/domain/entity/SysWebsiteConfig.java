package com.ruoyi.common.core.domain.entity;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

/**
 * 业务网站配置表 sys_website_config
 * 用于存储各业务网站的部门层级信息，供自动分类用户归属使用
 * 
 * @author ruoyi
 */
public class SysWebsiteConfig extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键ID */
    private Long id;

    /** 业务网站编码（如DEFAULT/GAMECLUB） */
    private String websiteCode;

    /** 业务网站名称 */
    private String websiteName;

    /** 该网站在部门树中的根部门ID */
    private Long rootDeptId;

    /** 默认部门ID（无业务归属时的兜底部门） */
    private Long defaultDeptId;

    /** 状态（0正常 1停用） */
    private String status;

    /** 备注 */
    private String remark;

    /** 创建时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createdAt;

    /** 更新时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date updatedAt;

    public Long getId()
    {
        return id;
    }

    public void setId(Long id)
    {
        this.id = id;
    }

    public String getWebsiteCode()
    {
        return websiteCode;
    }

    public void setWebsiteCode(String websiteCode)
    {
        this.websiteCode = websiteCode;
    }

    public String getWebsiteName()
    {
        return websiteName;
    }

    public void setWebsiteName(String websiteName)
    {
        this.websiteName = websiteName;
    }

    public Long getRootDeptId()
    {
        return rootDeptId;
    }

    public void setRootDeptId(Long rootDeptId)
    {
        this.rootDeptId = rootDeptId;
    }

    public Long getDefaultDeptId()
    {
        return defaultDeptId;
    }

    public void setDefaultDeptId(Long defaultDeptId)
    {
        this.defaultDeptId = defaultDeptId;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    @Override
    public String getRemark()
    {
        return remark;
    }

    @Override
    public void setRemark(String remark)
    {
        this.remark = remark;
    }

    public Date getCreatedAt()
    {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt)
    {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt()
    {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt)
    {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString()
    {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("websiteCode", getWebsiteCode())
            .append("websiteName", getWebsiteName())
            .append("rootDeptId", getRootDeptId())
            .append("defaultDeptId", getDefaultDeptId())
            .append("status", getStatus())
            .append("remark", getRemark())
            .append("createdAt", getCreatedAt())
            .append("updatedAt", getUpdatedAt())
            .toString();
    }
}
