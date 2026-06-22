package com.ruoyi.system.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 游戏分区对象 game_partition
 * 
 * @author ruoyi
 */
public class GamePartition extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /** 分区ID */
    private Long id;

    /** 对应部门ID（与sys_dept表关联，用于用户部门归属） */
    private Long deptId;

    /** 游戏名称 */
    private String gameName;

    /** 游戏编码 */
    private String gameCode;

    /** 游戏图标 */
    private String icon;

    /** 游戏简介 */
    private String description;

    /** 排序 */
    private Integer sortOrder;

    /** 状态：0-禁用 1-正常 */
    private Integer status;

    /** 创建时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createdAt;

    /** 更新时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date updatedAt;

    /** 工会数（非数据库字段，用于展示） */
    private Integer guildCount;

    /** 成员数（非数据库字段，用于展示） */
    private Integer memberCount;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getDeptId() {
        return deptId;
    }

    public void setDeptId(Long deptId) {
        this.deptId = deptId;
    }

    public String getGameName() {
        return gameName;
    }

    public void setGameName(String gameName) {
        this.gameName = gameName;
    }

    public String getGameCode() {
        return gameCode;
    }

    public void setGameCode(String gameCode) {
        this.gameCode = gameCode;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(Integer sortOrder) {
        this.sortOrder = sortOrder;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
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

    public Integer getGuildCount() { return guildCount; }
    public void setGuildCount(Integer guildCount) { this.guildCount = guildCount; }

    public Integer getMemberCount() { return memberCount; }
    public void setMemberCount(Integer memberCount) { this.memberCount = memberCount; }

    @Override
    public String toString() {
        return "GamePartition{" +
                "id=" + id +
                ", gameName='" + gameName + '\'' +
                ", gameCode='" + gameCode + '\'' +
                ", icon='" + icon + '\'' +
                ", description='" + description + '\'' +
                ", sortOrder=" + sortOrder +
                ", status=" + status +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
}
