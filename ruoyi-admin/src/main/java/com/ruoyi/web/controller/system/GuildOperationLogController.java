package com.ruoyi.web.controller.system;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.system.domain.GuildOperationLog;
import com.ruoyi.system.service.IGuildOperationLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 工会操作日志 Controller
 */
@Controller
@RequestMapping("/system/guildOperationLog")
public class GuildOperationLogController extends BaseController {

    private String prefix = "gameclub/operationLog";

    @Autowired
    private IGuildOperationLogService guildOperationLogService;

    @PreAuthorize("@ss.hasPermi('gameclub:operationLog:view')")
    @GetMapping()
    public String operationLog() {
        return prefix + "/index";
    }

    @PreAuthorize("@ss.hasPermi('gameclub:operationLog:list')")
    @PostMapping("/list")
    @ResponseBody
    public TableDataInfo list(GuildOperationLog log) {
        startPage();
        List<GuildOperationLog> list = guildOperationLogService.selectGuildOperationLogList(log);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('gameclub:operationLog:query')")
    @GetMapping("/{id}")
    public String edit(@PathVariable("id") Long id, ModelMap mmap) {
        GuildOperationLog log = guildOperationLogService.selectGuildOperationLogById(id);
        mmap.put("log", log);
        return prefix + "/detail";
    }

    @Log(title = "工会操作日志", businessType = BusinessType.DELETE)
    @PreAuthorize("@ss.hasPermi('gameclub:operationLog:remove')")
    @DeleteMapping("/{ids}")
    @ResponseBody
    public AjaxResult remove(@PathVariable Long[] ids) {
        return toAjax(guildOperationLogService.deleteGuildOperationLogByIds(ids));
    }

    @Log(title = "工会操作日志", businessType = BusinessType.DELETE)
    @PreAuthorize("@ss.hasPermi('gameclub:operationLog:clear')")
    @PostMapping("/clear/{guildId}")
    @ResponseBody
    public AjaxResult clear(@PathVariable("guildId") Long guildId) {
        return toAjax(guildOperationLogService.clearGuildOperationLog(guildId));
    }

    @Log(title = "工会操作日志", businessType = BusinessType.EXPORT)
    @PreAuthorize("@ss.hasPermi('gameclub:operationLog:export')")
    @PostMapping("/export")
    @ResponseBody
    public AjaxResult export(GuildOperationLog log) {
        List<GuildOperationLog> list = guildOperationLogService.selectGuildOperationLogList(log);
        ExcelUtil<GuildOperationLog> util = new ExcelUtil<GuildOperationLog>(GuildOperationLog.class);
        return util.exportExcel(list, "工会操作日志数据");
    }
}