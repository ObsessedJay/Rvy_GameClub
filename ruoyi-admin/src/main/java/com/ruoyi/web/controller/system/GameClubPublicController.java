package com.ruoyi.web.controller.system;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.system.domain.GamePartition;
import com.ruoyi.system.domain.Guild;
import com.ruoyi.system.domain.GuildAnnouncement;
import com.ruoyi.system.domain.GuildApplication;
import com.ruoyi.system.domain.GuildCreateApplication;
import com.ruoyi.system.service.IGamePartitionService;
import com.ruoyi.system.service.IGuildService;
import com.ruoyi.system.service.IGuildAnnouncementService;
import com.ruoyi.system.service.IGuildApplicationService;
import com.ruoyi.system.service.IGuildCreateApplicationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/system/gameclub/public")
public class GameClubPublicController extends BaseController {

    @Autowired
    private IGamePartitionService gamePartitionService;

    @Autowired
    private IGuildService guildService;

    @Autowired
    private IGuildAnnouncementService guildAnnouncementService;

    @Autowired
    private IGuildApplicationService guildApplicationService;

    @Autowired
    private IGuildCreateApplicationService guildCreateApplicationService;

    @GetMapping("/partitions")
    public AjaxResult getPublicPartitions() {
        GamePartition partition = new GamePartition();
        partition.setStatus(1);
        List<GamePartition> list = gamePartitionService.selectGamePartitionList(partition);
        return success(list);
    }

    @GetMapping("/partition/{id}")
    public AjaxResult getPublicPartition(@PathVariable("id") Long id) {
        GamePartition partition = gamePartitionService.selectGamePartitionById(id);
        if (partition == null) return error("分区不存在");
        return success(partition);
    }

    @GetMapping("/guilds")
    public AjaxResult getPublicGuilds() {
        Guild guild = new Guild();
        guild.setStatus(1);
        List<Guild> list = guildService.selectGuildList(guild);
        return success(list);
    }

    @GetMapping("/guild/{id}")
    public AjaxResult getPublicGuild(@PathVariable("id") Long id) {
        Guild guild = guildService.selectGuildById(id);
        if (guild == null) return error("工会不存在");
        return success(guild);
    }

    @GetMapping("/announcements")
    public AjaxResult getPublicAnnouncements() {
        List<GuildAnnouncement> list = guildAnnouncementService.selectPublishedAnnouncements();
        return success(list);
    }

    @GetMapping("/announcement/{id}")
    public AjaxResult getPublicAnnouncement(@PathVariable("id") Long id) {
        GuildAnnouncement announcement = guildAnnouncementService.selectGuildAnnouncementById(id);
        if (announcement == null) return error("公告不存在");
        return success(announcement);
    }

    @PostMapping("/apply")
    public AjaxResult applyGuild(@Validated @RequestBody GuildApplication application) {
        application.setUserId(getUserId());
        application.setStatus(0);
        return toAjax(guildApplicationService.insertGuildApplication(application));
    }

    /** 申请创建工会（公开接口，需要登录） */
    @PostMapping("/createGuild")
    public AjaxResult createGuild(@Validated @RequestBody GuildCreateApplication application) {
        application.setApplicantId(getUserId());
        return toAjax(guildCreateApplicationService.insert(application));
    }
}
