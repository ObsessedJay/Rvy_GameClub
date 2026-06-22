package com.ruoyi.system.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 工会任务对象 guild_task
 * 
 * @author ruoyi
 */
public class GuildTask extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /** 任务ID */
    private Long id;

    /** 工会ID */
    private Long guildId;

    /** 工会名称（非数据库字段） */
    private String guildName;

    /** 游戏分区ID */
    private Long gamePartitionId;

    /** 发布者用户ID */
    private Long publisherId;

    /** 发布者名称（非数据库字段） */
    private String publisherName;

    /** 任务名称 */
    private String name;

    /** 任务类型：1-日常 2-周常 3-活动 */
    private Integer type;

    /** 任务描述 */
    private String description;

    /** 封面图 */
    private String image;

    /** 任务模式：1-组队 2-单人 */
    private Integer taskMode;

    /** 最少参与人数 */
    private Integer minPlayers;

    /** 最大参与人数 */
    private Integer maxPlayers;

    /** 开始时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date startTime;

    /** 接取截止时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date joinDeadline;

    /** 结束时间（任务完成时限） */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date endTime;

    /** 状态：1-可接取 2-进行中 3-已完成 4-已过期 */
    private Integer status;

    /** 当前参与人数 */
    private Integer currentPlayers;

    /** 乐观锁版本 */
    private Integer version;

    /** 创建时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createdAt;

    /** 更新时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date updatedAt;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getGuildId() { return guildId; }
    public void setGuildId(Long guildId) { this.guildId = guildId; }

    public String getGuildName() { return guildName; }
    public void setGuildName(String guildName) { this.guildName = guildName; }

    public Long getGamePartitionId() { return gamePartitionId; }
    public void setGamePartitionId(Long gamePartitionId) { this.gamePartitionId = gamePartitionId; }

    public Long getPublisherId() { return publisherId; }
    public void setPublisherId(Long publisherId) { this.publisherId = publisherId; }

    public String getPublisherName() { return publisherName; }
    public void setPublisherName(String publisherName) { this.publisherName = publisherName; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public Integer getType() { return type; }
    public void setType(Integer type) { this.type = type; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public Integer getTaskMode() { return taskMode; }
    public void setTaskMode(Integer taskMode) { this.taskMode = taskMode; }

    public Integer getMinPlayers() { return minPlayers; }
    public void setMinPlayers(Integer minPlayers) { this.minPlayers = minPlayers; }

    public Integer getMaxPlayers() { return maxPlayers; }
    public void setMaxPlayers(Integer maxPlayers) { this.maxPlayers = maxPlayers; }

    public Date getStartTime() { return startTime; }
    public void setStartTime(Date startTime) { this.startTime = startTime; }

    public Date getJoinDeadline() { return joinDeadline; }
    public void setJoinDeadline(Date joinDeadline) { this.joinDeadline = joinDeadline; }

    public Date getEndTime() { return endTime; }
    public void setEndTime(Date endTime) { this.endTime = endTime; }

    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }

    public Integer getCurrentPlayers() { return currentPlayers; }
    public void setCurrentPlayers(Integer currentPlayers) { this.currentPlayers = currentPlayers; }

    public Integer getVersion() { return version; }
    public void setVersion(Integer version) { this.version = version; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }
}
