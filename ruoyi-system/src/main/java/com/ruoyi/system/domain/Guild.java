package com.ruoyi.system.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 工会对象 guild
 * 
 * @author ruoyi
 */
public class Guild extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /** 工会ID */
    private Long id;

    /** 所属游戏分区 */
    private Long gamePartitionId;

    /** 对应部门ID（与sys_dept表关联，用于用户部门归属） */
    private Long deptId;

    /** 游戏分区名称（非数据库字段） */
    private String gamePartitionName;

    /** 工会名称 */
    private String name;

    /** 工会简介 */
    private String description;

    /** 招募要求 */
    private String recruitRequirement;

    /** 常驻在线时段 */
    private String onlineTime;

    /** 工会头像URL */
    private String avatar;

    /** 宣传图URL */
    private String banner;

    /** 会长用户ID */
    private Long presidentId;

    /** 会长用户名（非数据库字段） */
    private String presidentName;

    /** 成员数量 */
    private Integer memberCount;

    /** 状态：0-解散 1-正常 */
    private Integer status;

    /** 删除时间（软删除） */
    private Date deletedAt;

    /** 归档到期时间 */
    private Date archiveUntil;

    /** 创建时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createdAt;

    /** 更新时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date updatedAt;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getGamePartitionId() {
        return gamePartitionId;
    }

    public void setGamePartitionId(Long gamePartitionId) {
        this.gamePartitionId = gamePartitionId;
    }

    public Long getDeptId() {
        return deptId;
    }

    public void setDeptId(Long deptId) {
        this.deptId = deptId;
    }

    public String getGamePartitionName() {
        return gamePartitionName;
    }

    public void setGamePartitionName(String gamePartitionName) {
        this.gamePartitionName = gamePartitionName;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getRecruitRequirement() {
        return recruitRequirement;
    }

    public void setRecruitRequirement(String recruitRequirement) {
        this.recruitRequirement = recruitRequirement;
    }

    public String getOnlineTime() {
        return onlineTime;
    }

    public void setOnlineTime(String onlineTime) {
        this.onlineTime = onlineTime;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getBanner() {
        return banner;
    }

    public void setBanner(String banner) {
        this.banner = banner;
    }

    public Long getPresidentId() {
        return presidentId;
    }

    public void setPresidentId(Long presidentId) {
        this.presidentId = presidentId;
    }

    public String getPresidentName() {
        return presidentName;
    }

    public void setPresidentName(String presidentName) {
        this.presidentName = presidentName;
    }

    public Integer getMemberCount() {
        return memberCount;
    }

    public void setMemberCount(Integer memberCount) {
        this.memberCount = memberCount;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Date getDeletedAt() {
        return deletedAt;
    }

    public void setDeletedAt(Date deletedAt) {
        this.deletedAt = deletedAt;
    }

    public Date getArchiveUntil() {
        return archiveUntil;
    }

    public void setArchiveUntil(Date archiveUntil) {
        this.archiveUntil = archiveUntil;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "Guild{" +
                "id=" + id +
                ", gamePartitionId=" + gamePartitionId +
                ", name='" + name + '\'' +
                ", description='" + description + '\'' +
                ", status=" + status +
                ", memberCount=" + memberCount +
                '}';
    }
}
