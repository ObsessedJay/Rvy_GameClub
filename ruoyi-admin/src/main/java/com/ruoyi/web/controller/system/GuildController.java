package com.ruoyi.web.controller.system;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.system.domain.Guild;
import com.ruoyi.system.service.IGuildService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 工会Controller
 * 
 * @author ruoyi
 */
@RestController
@RequestMapping("/system/guild")
public class GuildController extends BaseController {

    @Autowired
    private IGuildService guildService;

    /**
     * 获取工会列表
     */
    @PreAuthorize("@ss.hasPermi('gameclub:guild:list')")
    @GetMapping("/list")
    public TableDataInfo list(Guild guild) {
        startPage();
        List<Guild> list = guildService.selectGuildList(guild);
        return getDataTable(list);
    }

    /**
     * 导出工会列表
     */
    @PreAuthorize("@ss.hasPermi('gameclub:guild:export')")
    @Log(title = "工会", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Guild guild) {
        List<Guild> list = guildService.selectGuildList(guild);
        ExcelUtil<Guild> util = new ExcelUtil<>(Guild.class);
        util.exportExcel(response, list, "工会数据");
    }

    /**
     * 根据工会ID获取详细信息
     */
    @PreAuthorize("@ss.hasPermi('gameclub:guild:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id) {
        return success(guildService.selectGuildById(id));
    }

    /**
     * 新增工会
     */
    @PreAuthorize("@ss.hasPermi('gameclub:guild:add')")
    @Log(title = "工会", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody Guild guild) {
        guild.setCreateBy(getUsername());
        return toAjax(guildService.insertGuild(guild));
    }

    /**
     * 修改工会
     */
    @PreAuthorize("@ss.hasPermi('gameclub:guild:edit')")
    @Log(title = "工会", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody Guild guild) {
        guild.setUpdateBy(getUsername());
        return toAjax(guildService.updateGuild(guild));
    }

    /**
     * 修改工会状态
     */
    @PreAuthorize("@ss.hasPermi('gameclub:guild:edit')")
    @Log(title = "工会", businessType = BusinessType.UPDATE)
    @PutMapping("/changeStatus")
    public AjaxResult changeStatus(@RequestParam("id") Long id, @RequestParam("status") Integer status) {
        return toAjax(guildService.changeStatus(id, status));
    }

    /**
     * 删除工会
     */
    @PreAuthorize("@ss.hasPermi('gameclub:guild:remove')")
    @Log(title = "工会", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids) {
        return toAjax(guildService.deleteGuildById(ids[0]));
    }

    /**
     * 获取用户管理的工会列表
     */
    @GetMapping("/myGuilds")
    public AjaxResult myGuilds() {
        List<Guild> list = guildService.selectGuildsByPresidentId(getUserId());
        return success(list);
    }
}
