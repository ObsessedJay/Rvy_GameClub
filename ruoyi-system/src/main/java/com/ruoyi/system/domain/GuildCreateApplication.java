package com.ruoyi.system.domain;

import java.util.Date;

public class GuildCreateApplication {
    private Long id;
    private Long gamePartitionId;
    private String guildName;
    private String description;
    private String recruitRequirement;
    private Long applicantId;
    private Integer status;
    private String rejectReason;
    private Long reviewerId;
    private Date reviewTime;
    private Date createdAt;

    // 扩展字段
    private String gamePartitionName;
    private String applicantName;
    private String reviewerName;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getGamePartitionId() { return gamePartitionId; }
    public void setGamePartitionId(Long gamePartitionId) { this.gamePartitionId = gamePartitionId; }
    public String getGuildName() { return guildName; }
    public void setGuildName(String guildName) { this.guildName = guildName; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getRecruitRequirement() { return recruitRequirement; }
    public void setRecruitRequirement(String recruitRequirement) { this.recruitRequirement = recruitRequirement; }
    public Long getApplicantId() { return applicantId; }
    public void setApplicantId(Long applicantId) { this.applicantId = applicantId; }
    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }
    public String getRejectReason() { return rejectReason; }
    public void setRejectReason(String rejectReason) { this.rejectReason = rejectReason; }
    public Long getReviewerId() { return reviewerId; }
    public void setReviewerId(Long reviewerId) { this.reviewerId = reviewerId; }
    public Date getReviewTime() { return reviewTime; }
    public void setReviewTime(Date reviewTime) { this.reviewTime = reviewTime; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    public String getGamePartitionName() { return gamePartitionName; }
    public void setGamePartitionName(String gamePartitionName) { this.gamePartitionName = gamePartitionName; }
    public String getApplicantName() { return applicantName; }
    public void setApplicantName(String applicantName) { this.applicantName = applicantName; }
    public String getReviewerName() { return reviewerName; }
    public void setReviewerName(String reviewerName) { this.reviewerName = reviewerName; }
}
