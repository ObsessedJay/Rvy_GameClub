package com.ruoyi.web.controller.system;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.system.domain.GuildAnnouncement;
import com.ruoyi.system.service.IGuildAnnouncementService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 工会公告 Controller
 */
@Controller
@RequestMapping("/system/guildAnnouncement")
public class GuildAnnouncementController extends BaseController {

    private String prefix = "gameclub/announcement";

    @Autowired
    private IGuildAnnouncementService guildAnnouncementService;

    @PreAuthorize("@ss.hasPermi('gameclub:announcement:view')")
    @GetMapping()
    public String announcement() {
        return prefix + "/index";
    }

    @PreAuthorize("@ss.hasPermi('gameclub:announcement:list')")
    @PostMapping("/list")
    @ResponseBody
    public TableDataInfo list(GuildAnnouncement announcement) {
        startPage();
        List<GuildAnnouncement> list = guildAnnouncementService.selectGuildAnnouncementList(announcement);
        return getDataTable(list);
    }

    @Log(title = "工会公告", businessType = BusinessType.EXPORT)
    @PreAuthorize("@ss.hasPermi('gameclub:announcement:export')")
    @PostMapping("/export")
    @ResponseBody
    public AjaxResult export(GuildAnnouncement announcement) {
        List<GuildAnnouncement> list = guildAnnouncementService.selectGuildAnnouncementList(announcement);
        ExcelUtil<GuildAnnouncement> util = new ExcelUtil<GuildAnnouncement>(GuildAnnouncement.class);
        return util.exportExcel(list, "工会公告数据");
    }

    @PreAuthorize("@ss.hasPermi('gameclub:announcement:add')")
    @GetMapping("/add")
    public String add() {
        return prefix + "/add";
    }

    @Log(title = "工会公告", businessType = BusinessType.INSERT)
    @PreAuthorize("@ss.hasPermi('gameclub:announcement:add')")
    @PostMapping("/add")
    @ResponseBody
    public AjaxResult addSave(GuildAnnouncement announcement) {
        return toAjax(guildAnnouncementService.insertGuildAnnouncement(announcement));
    }

    @PreAuthorize("@ss.hasPermi('gameclub:announcement:edit')")
    @GetMapping("/edit/{id}")
    public String edit(@PathVariable("id") Long id, ModelMap mmap) {
        GuildAnnouncement announcement = guildAnnouncementService.selectGuildAnnouncementById(id);
        mmap.put("announcement", announcement);
        return prefix + "/edit";
    }

    @Log(title = "工会公告", businessType = BusinessType.UPDATE)
    @PreAuthorize("@ss.hasPermi('gameclub:announcement:edit')")
    @PostMapping("/edit")
    @ResponseBody
    public AjaxResult editSave(GuildAnnouncement announcement) {
        return toAjax(guildAnnouncementService.updateGuildAnnouncement(announcement));
    }

    @Log(title = "工会公告", businessType = BusinessType.DELETE)
    @PreAuthorize("@ss.hasPermi('gameclub:announcement:remove')")
    @DeleteMapping("/{ids}")
    @ResponseBody
    public AjaxResult remove(@PathVariable Long[] ids) {
        return toAjax(guildAnnouncementService.deleteGuildAnnouncementByIds(ids));
    }

    @Log(title = "工会公告", businessType = BusinessType.UPDATE)
    @PreAuthorize("@ss.hasPermi('gameclub:announcement:publish')")
    @PostMapping("/publish/{id}")
    @ResponseBody
    public AjaxResult publish(@PathVariable("id") Long id) {
        return toAjax(guildAnnouncementService.publishGuildAnnouncement(id));
    }

    @Log(title = "工会公告", businessType = BusinessType.UPDATE)
    @PreAuthorize("@ss.hasPermi('gameclub:announcement:withdraw')")
    @PostMapping("/withdraw/{id}")
    @ResponseBody
    public AjaxResult withdraw(@PathVariable("id") Long id) {
        return toAjax(guildAnnouncementService.withdrawGuildAnnouncement(id));
    }
}