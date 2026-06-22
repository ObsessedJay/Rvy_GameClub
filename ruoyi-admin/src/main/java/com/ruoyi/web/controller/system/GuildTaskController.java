package com.ruoyi.web.controller.system;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.GuildTask;
import com.ruoyi.system.domain.TaskParticipant;
import com.ruoyi.system.service.IGuildTaskService;
import com.ruoyi.system.service.ITaskParticipantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/system/guildTask")
public class GuildTaskController extends BaseController {

    @Autowired
    private IGuildTaskService guildTaskService;

    @Autowired
    private ITaskParticipantService participantService;

    @PreAuthorize("@ss.hasPermi('gameclub:task:list')")
    @GetMapping("/list")
    public TableDataInfo list(GuildTask task) {
        startPage();
        List<GuildTask> list = guildTaskService.selectGuildTaskList(task);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('gameclub:task:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id) {
        return success(guildTaskService.selectGuildTaskById(id));
    }

    @PreAuthorize("@ss.hasPermi('gameclub:task:add')")
    @Log(title = "工会任务", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody GuildTask task) {
        task.setPublisherId(getUserId());
        return toAjax(guildTaskService.insertGuildTask(task));
    }

    @PreAuthorize("@ss.hasPermi('gameclub:task:edit')")
    @Log(title = "工会任务", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody GuildTask task) {
        return toAjax(guildTaskService.updateGuildTask(task));
    }

    @PreAuthorize("@ss.hasPermi('gameclub:task:edit')")
    @PutMapping("/changeStatus")
    public AjaxResult changeStatus(@RequestParam("id") Long id, @RequestParam("status") Integer status) {
        return toAjax(guildTaskService.changeStatus(id, status));
    }

    @PreAuthorize("@ss.hasPermi('gameclub:task:remove')")
    @Log(title = "工会任务", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids) {
        return toAjax(guildTaskService.deleteGuildTaskById(ids[0]));
    }

    // ===== 参与者相关 =====

    @GetMapping("/{id}/participants")
    public AjaxResult participants(@PathVariable("id") Long id) {
        List<TaskParticipant> list = participantService.selectByTaskId(id);
        return success(list);
    }

    @PostMapping("/{id}/join")
    public AjaxResult join(@PathVariable("id") Long id) {
        return toAjax(participantService.joinTask(id, getUserId()));
    }

    @PostMapping("/{id}/quit")
    public AjaxResult quit(@PathVariable("id") Long id) {
        return toAjax(participantService.quitTask(id, getUserId()));
    }

    @PostMapping("/{id}/ready")
    public AjaxResult ready(@PathVariable("id") Long id) {
        return toAjax(participantService.readyUp(id, getUserId()));
    }

    @PostMapping("/{id}/complete")
    public AjaxResult complete(@PathVariable("id") Long id) {
        return toAjax(guildTaskService.completeTask(id));
    }
}
