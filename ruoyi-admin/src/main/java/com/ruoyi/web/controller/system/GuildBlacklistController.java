package com.ruoyi.web.controller.system;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.system.domain.GuildBlacklist;
import com.ruoyi.system.service.IGuildBlacklistService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 工会黑名单 Controller
 */
@Controller
@RequestMapping("/system/guildBlacklist")
public class GuildBlacklistController extends BaseController {

    private String prefix = "gameclub/blacklist";

    @Autowired
    private IGuildBlacklistService guildBlacklistService;

    @PreAuthorize("@ss.hasPermi('gameclub:blacklist:view')")
    @GetMapping()
    public String blacklist() {
        return prefix + "/index";
    }

    @PreAuthorize("@ss.hasPermi('gameclub:blacklist:list')")
    @PostMapping("/list")
    @ResponseBody
    public TableDataInfo list(GuildBlacklist blacklist) {
        startPage();
        List<GuildBlacklist> list = guildBlacklistService.selectGuildBlacklistList(blacklist);
        return getDataTable(list);
    }

    @Log(title = "工会黑名单", businessType = BusinessType.EXPORT)
    @PreAuthorize("@ss.hasPermi('gameclub:blacklist:export')")
    @PostMapping("/export")
    @ResponseBody
    public AjaxResult export(GuildBlacklist blacklist) {
        List<GuildBlacklist> list = guildBlacklistService.selectGuildBlacklistList(blacklist);
        ExcelUtil<GuildBlacklist> util = new ExcelUtil<GuildBlacklist>(GuildBlacklist.class);
        return util.exportExcel(list, "工会黑名单数据");
    }

    @PreAuthorize("@ss.hasPermi('gameclub:blacklist:add')")
    @GetMapping("/add")
    public String add() {
        return prefix + "/add";
    }

    @Log(title = "工会黑名单", businessType = BusinessType.INSERT)
    @PreAuthorize("@ss.hasPermi('gameclub:blacklist:add')")
    @PostMapping("/add")
    @ResponseBody
    public AjaxResult addSave(GuildBlacklist blacklist) {
        return toAjax(guildBlacklistService.insertGuildBlacklist(blacklist));
    }

    @PreAuthorize("@ss.hasPermi('gameclub:blacklist:edit')")
    @GetMapping("/edit/{id}")
    public String edit(@PathVariable("id") Long id, ModelMap mmap) {
        GuildBlacklist blacklist = guildBlacklistService.selectGuildBlacklistById(id);
        mmap.put("blacklist", blacklist);
        return prefix + "/edit";
    }

    @Log(title = "工会黑名单", businessType = BusinessType.UPDATE)
    @PreAuthorize("@ss.hasPermi('gameclub:blacklist:edit')")
    @PostMapping("/edit")
    @ResponseBody
    public AjaxResult editSave(GuildBlacklist blacklist) {
        return toAjax(guildBlacklistService.updateGuildBlacklist(blacklist));
    }

    @Log(title = "工会黑名单", businessType = BusinessType.DELETE)
    @PreAuthorize("@ss.hasPermi('gameclub:blacklist:remove')")
    @DeleteMapping("/{ids}")
    @ResponseBody
    public AjaxResult remove(@PathVariable Long[] ids) {
        return toAjax(guildBlacklistService.deleteGuildBlacklistByIds(ids));
    }

    @Log(title = "工会黑名单", businessType = BusinessType.UPDATE)
    @PreAuthorize("@ss.hasPermi('gameclub:blacklist:remove')")
    @PostMapping("/remove/{id}")
    @ResponseBody
    public AjaxResult removeBlacklist(@PathVariable("id") Long id) {
        return toAjax(guildBlacklistService.removeGuildBlacklist(id));
    }
}