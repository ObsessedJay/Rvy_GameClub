package com.ruoyi.web.controller.system;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.system.domain.GuildApplication;
import com.ruoyi.system.service.IGuildApplicationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 工会申请 Controller
 */
@Controller
@RequestMapping("/system/guildApplication")
public class GuildApplicationController extends BaseController {

    private String prefix = "gameclub/application";

    @Autowired
    private IGuildApplicationService guildApplicationService;

    @PreAuthorize("@ss.hasPermi('gameclub:application:view')")
    @GetMapping()
    public String application() {
        return prefix + "/index";
    }

    @PreAuthorize("@ss.hasPermi('gameclub:application:list')")
    @GetMapping("/list")
    @ResponseBody
    public TableDataInfo list(GuildApplication application) {
        startPage();
        List<GuildApplication> list = guildApplicationService.selectGuildApplicationList(application);
        return getDataTable(list);
    }

    @Log(title = "工会申请", businessType = BusinessType.EXPORT)
    @PreAuthorize("@ss.hasPermi('gameclub:application:export')")
    @PostMapping("/export")
    @ResponseBody
    public AjaxResult export(GuildApplication application) {
        List<GuildApplication> list = guildApplicationService.selectGuildApplicationList(application);
        ExcelUtil<GuildApplication> util = new ExcelUtil<GuildApplication>(GuildApplication.class);
        return util.exportExcel(list, "工会申请数据");
    }

    @PreAuthorize("@ss.hasPermi('gameclub:application:add')")
    @GetMapping("/add")
    public String add() {
        return prefix + "/add";
    }

    @Log(title = "工会申请", businessType = BusinessType.INSERT)
    @PreAuthorize("@ss.hasPermi('gameclub:application:add')")
    @PostMapping("/add")
    @ResponseBody
    public AjaxResult addSave(GuildApplication application) {
        return toAjax(guildApplicationService.insertGuildApplication(application));
    }

    @PreAuthorize("@ss.hasPermi('gameclub:application:edit')")
    @GetMapping("/edit/{id}")
    public String edit(@PathVariable("id") Long id, ModelMap mmap) {
        GuildApplication application = guildApplicationService.selectGuildApplicationById(id);
        mmap.put("application", application);
        return prefix + "/edit";
    }

    @PreAuthorize("@ss.hasPermi('gameclub:application:list')")
    @GetMapping("/{id}")
    @ResponseBody
    public AjaxResult getInfo(@PathVariable("id") Long id) {
        return AjaxResult.success(guildApplicationService.selectGuildApplicationById(id));
    }

    @Log(title = "工会申请", businessType = BusinessType.UPDATE)
    @PreAuthorize("@ss.hasPermi('gameclub:application:edit')")
    @PutMapping
    @ResponseBody
    public AjaxResult editSave(@RequestBody GuildApplication application) {
        return toAjax(guildApplicationService.updateGuildApplication(application));
    }

    @Log(title = "工会申请", businessType = BusinessType.DELETE)
    @PreAuthorize("@ss.hasPermi('gameclub:application:remove')")
    @DeleteMapping("/{ids}")
    @ResponseBody
    public AjaxResult remove(@PathVariable Long[] ids) {
        return toAjax(guildApplicationService.deleteGuildApplicationByIds(ids));
    }

    @Log(title = "工会申请", businessType = BusinessType.UPDATE)
    @PreAuthorize("@ss.hasPermi('gameclub:application:approve')")
    @PutMapping("/approve")
    @ResponseBody
    public AjaxResult approve(@RequestBody GuildApplication application) {
        return toAjax(guildApplicationService.approveGuildApplication(application.getId(), application.getStatus(), application.getRejectReason()));
    }

    @Log(title = "工会申请", businessType = BusinessType.UPDATE)
    @PreAuthorize("@ss.hasPermi('gameclub:application:approve')")
    @PutMapping("/batchApprove")
    @ResponseBody
    public AjaxResult batchApprove(@RequestBody java.util.Map<String, Object> params) {
        Long[] ids = ((java.util.List<Long>) params.get("ids")).toArray(new Long[0]);
        Integer status = (Integer) params.get("status");
        return toAjax(guildApplicationService.batchApproveGuildApplication(ids, status));
    }
}