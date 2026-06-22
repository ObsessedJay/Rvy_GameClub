package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.GuildCreateApplication;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface GuildCreateApplicationMapper {

    List<GuildCreateApplication> selectList(GuildCreateApplication application);

    GuildCreateApplication selectById(@Param("id") Long id);

    int insert(GuildCreateApplication application);

    int approve(GuildCreateApplication application);

    int deleteById(@Param("id") Long id);
}
