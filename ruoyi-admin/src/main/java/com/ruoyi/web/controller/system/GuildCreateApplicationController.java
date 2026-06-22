package com.ruoyi.web.controller.system;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.system.domain.GuildCreateApplication;
import com.ruoyi.system.service.IGuildCreateApplicationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/system/guildCreateApp")
public class GuildCreateApplicationController extends BaseController {

    @Autowired
    private IGuildCreateApplicationService service;

    @PreAuthorize("@ss.hasPermi('gameclub:guildCreateApp:query')")
    @GetMapping("/list")
    public TableDataInfo list(GuildCreateApplication app) {
        startPage();
        return getDataTable(service.selectList(app));
    }

    @PreAuthorize("@ss.hasPermi('gameclub:guildCreateApp:query')")
    @GetMapping("/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id) {
        return success(service.selectById(id));
    }

    @PreAuthorize("@ss.hasPermi('gameclub:guildCreateApp:approve')")
    @PutMapping("/approve")
    public AjaxResult approve(@RequestBody GuildCreateApplication app) {
        return toAjax(service.approve(app.getId(), app.getStatus(), app.getRejectReason(), getUserId()));
    }

    @PreAuthorize("@ss.hasPermi('gameclub:guildCreateApp:remove')")
    @DeleteMapping("/{id}")
    public AjaxResult remove(@PathVariable("id") Long id) {
        return toAjax(service.deleteById(id));
    }
}
