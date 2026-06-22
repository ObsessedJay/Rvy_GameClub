package com.ruoyi.system.domain;

import java.util.Date;

public class GuildChatMessage {
    private Long id;
    private Long guildId;
    private Long senderId;
    private String senderName;
    private String content;
    private Integer type; // 1-文本 2-系统通知 3-@提醒
    private Date createdAt;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getGuildId() { return guildId; }
    public void setGuildId(Long guildId) { this.guildId = guildId; }
    public Long getSenderId() { return senderId; }
    public void setSenderId(Long senderId) { this.senderId = senderId; }
    public String getSenderName() { return senderName; }
    public void setSenderName(String senderName) { this.senderName = senderName; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public Integer getType() { return type; }
    public void setType(Integer type) { this.type = type; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}
