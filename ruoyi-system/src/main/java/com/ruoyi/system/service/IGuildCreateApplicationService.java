package com.ruoyi.system.service;

import com.ruoyi.system.domain.GuildCreateApplication;
import java.util.List;

public interface IGuildCreateApplicationService {
    List<GuildCreateApplication> selectList(GuildCreateApplication application);
    GuildCreateApplication selectById(Long id);
    int insert(GuildCreateApplication application);
    int approve(Long id, Integer status, String rejectReason, Long reviewerId);
    int deleteById(Long id);
}
