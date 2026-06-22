package com.ruoyi.common.core.domain.entity;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

/**
 * 用户-业务网站部门关联表 sys_user_dept
 * 用于实现多对多用户部门归属（方案C）
 * 
 * @author ruoyi
 */
public class SysUserDept extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键ID */
    private Long id;

    /** 用户ID */
    private Long userId;

    /** 部门ID */
    private Long deptId;

    /** 业务网站编码（如DEFAULT/GAMECLUB） */
    private String websiteCode;

    /** 是否主部门（0否 1是） */
    private Integer isPrimary;

    /** 加入时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date joinedAt;

    /** 创建时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createdAt;

    /** 更新时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date updatedAt;

    /** 非数据库字段：部门名称 */
    private String deptName;

    /** 非数据库字段：业务网站名称 */
    private String websiteName;

    public Long getId()
    {
        return id;
    }

    public void setId(Long id)
    {
        this.id = id;
    }

    public Long getUserId()
    {
        return userId;
    }

    public void setUserId(Long userId)
    {
        this.userId = userId;
    }

    public Long getDeptId()
    {
        return deptId;
    }

    public void setDeptId(Long deptId)
    {
        this.deptId = deptId;
    }

    public String getWebsiteCode()
    {
        return websiteCode;
    }

    public void setWebsiteCode(String websiteCode)
    {
        this.websiteCode = websiteCode;
    }

    public Integer getIsPrimary()
    {
        return isPrimary;
    }

    public void setIsPrimary(Integer isPrimary)
    {
        this.isPrimary = isPrimary;
    }

    public Date getJoinedAt()
    {
        return joinedAt;
    }

    public void setJoinedAt(Date joinedAt)
    {
        this.joinedAt = joinedAt;
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

    public String getDeptName()
    {
        return deptName;
    }

    public void setDeptName(String deptName)
    {
        this.deptName = deptName;
    }

    public String getWebsiteName()
    {
        return websiteName;
    }

    public void setWebsiteName(String websiteName)
    {
        this.websiteName = websiteName;
    }

    @Override
    public String toString()
    {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("userId", getUserId())
            .append("deptId", getDeptId())
            .append("websiteCode", getWebsiteCode())
            .append("isPrimary", getIsPrimary())
            .append("joinedAt", getJoinedAt())
            .append("createdAt", getCreatedAt())
            .append("updatedAt", getUpdatedAt())
            .toString();
    }
}
