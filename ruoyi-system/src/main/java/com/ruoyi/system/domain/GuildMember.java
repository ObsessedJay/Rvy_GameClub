package com.ruoyi.system.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 工会成员对象 guild_member
 * 
 * @author ruoyi
 */
public class GuildMember extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /** 记录ID */
    private Long id;

    /** 工会ID */
    private Long guildId;

    /** 工会名称（非数据库字段） */
    private String guildName;

    /** 游戏分区ID */
    private Long gamePartitionId;

    /** 游戏分区名称（非数据库字段） */
    private String gamePartitionName;

    /** 用户ID */
    private Long userId;

    /** 用户名（非数据库字段） */
    private String userName;

    /** 用户昵称（非数据库字段） */
    private String nickName;

    /** 角色：1-会长 2-管理员 3-普通成员 4-无工会用户 */
    private Integer role;

    /** 入会时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date joinTime;

    /** 状态：0-已退出 1-正常 */
    private Integer status;

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

    public Long getGuildId() {
        return guildId;
    }

    public void setGuildId(Long guildId) {
        this.guildId = guildId;
    }

    public String getGuildName() {
        return guildName;
    }

    public void setGuildName(String guildName) {
        this.guildName = guildName;
    }

    public Long getGamePartitionId() {
        return gamePartitionId;
    }

    public void setGamePartitionId(Long gamePartitionId) {
        this.gamePartitionId = gamePartitionId;
    }

    public String getGamePartitionName() {
        return gamePartitionName;
    }

    public void setGamePartitionName(String gamePartitionName) {
        this.gamePartitionName = gamePartitionName;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getNickName() {
        return nickName;
    }

    public void setNickName(String nickName) {
        this.nickName = nickName;
    }

    public Integer getRole() {
        return role;
    }

    public void setRole(Integer role) {
        this.role = role;
    }

    public Date getJoinTime() {
        return joinTime;
    }

    public void setJoinTime(Date joinTime) {
        this.joinTime = joinTime;
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

    @Override
    public String toString() {
        return "GuildMember{" +
                "id=" + id +
                ", guildId=" + guildId +
                ", userId=" + userId +
                ", role=" + role +
                ", status=" + status +
                '}';
    }
}
