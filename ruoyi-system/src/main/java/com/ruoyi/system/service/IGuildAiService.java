package com.ruoyi.system.service;

public interface IGuildAiService {
    /** 向 AI 提问并获取回复 */
    String chat(String question, Long guildId);
}
