package com.ruoyi.web.controller.system;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.system.domain.*;
import com.ruoyi.system.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * GameClub 会员自主管理接口
 */
@RestController
@RequestMapping("/system/gameclub/member")
public class GameClubMemberController extends BaseController {

    @Autowired
    private IGuildMemberService guildMemberService;

    @Autowired
    private IGuildTaskService guildTaskService;

    @Autowired
    private IGuildApplicationService guildApplicationService;

    @Autowired
    private ITaskParticipantService taskParticipantService;

    private GuildMember checkGuildRole(Long guildId) {
        GuildMember query = new GuildMember();
        query.setUserId(getUserId());
        List<GuildMember> list = guildMemberService.selectGuildMemberList(query);
        GuildMember active = null;
        for (GuildMember m : list) {
            if (m.getStatus() == 1) {
                active = m;
                break;
            }
        }
        if (active == null) throw new ServiceException("您尚未加入任何工会");
        if (!active.getGuildId().equals(guildId)) throw new ServiceException("您不属于该工会");
        if (active.getRole() != 1 && active.getRole() != 2) throw new ServiceException("无权操作");
        return active;
    }

    /** 校验当前用户属于该工会（任一角色） */
    private void checkInGuild(Long guildId) {
        GuildMember query = new GuildMember();
        query.setUserId(getUserId());
        List<GuildMember> list = guildMemberService.selectGuildMemberList(query);
        for (GuildMember m : list) {
            if (m.getStatus() == 1 && m.getGuildId().equals(guildId)) return;
        }
        throw new ServiceException("您不属于该工会");
    }

    // ==================== 任务管理（会长/管理员） ====================

    @GetMapping("/task/list")
    public TableDataInfo listTask(GuildTask task) {
        startPage();
        List<GuildTask> list = guildTaskService.selectGuildTaskList(task);
        return getDataTable(list);
    }

    @PostMapping("/task")
    public AjaxResult addTask(@RequestBody GuildTask task) {
        checkGuildRole(task.getGuildId());
        task.setPublisherId(getUserId());
        return toAjax(guildTaskService.insertGuildTask(task));
    }

    @PutMapping("/task")
    public AjaxResult editTask(@RequestBody GuildTask task) {
        GuildTask existing = guildTaskService.selectGuildTaskById(task.getId());
        if (existing == null) return error("任务不存在");
        checkGuildRole(existing.getGuildId());
        return toAjax(guildTaskService.updateGuildTask(task));
    }

    @DeleteMapping("/task/{id}")
    public AjaxResult delTask(@PathVariable("id") Long id) {
        GuildTask existing = guildTaskService.selectGuildTaskById(id);
        if (existing == null) return error("任务不存在");
        checkGuildRole(existing.getGuildId());
        return toAjax(guildTaskService.deleteGuildTaskById(id));
    }

    // ==================== 任务参与者操作（所有成员） ====================

    /** 查看任务参与者列表 */
    @GetMapping("/task/{id}/participants")
    public AjaxResult participants(@PathVariable("id") Long id) {
        GuildTask task = guildTaskService.selectGuildTaskById(id);
        if (task == null) return error("任务不存在");
        List<TaskParticipant> list = taskParticipantService.selectByTaskId(id);
        return success(list);
    }

    /** 接取任务 */
    @PostMapping("/task/{id}/join")
    public AjaxResult joinTask(@PathVariable("id") Long id) {
        GuildTask task = guildTaskService.selectGuildTaskById(id);
        if (task == null) return error("任务不存在");
        if (task.getStatus() != 1) return error("任务当前不可接取");
        checkInGuild(task.getGuildId());
        return toAjax(taskParticipantService.joinTask(id, getUserId()));
    }

    /** 取消接取任务（可接取/进行中状态下） */
    @PostMapping("/task/{id}/cancel")
    public AjaxResult cancelTask(@PathVariable("id") Long id) {
        GuildTask task = guildTaskService.selectGuildTaskById(id);
        if (task == null) return error("任务不存在");
        return toAjax(taskParticipantService.cancelTask(id, getUserId()));
    }

    /** 参与者标记任务完成 */
    @PostMapping("/task/{id}/complete")
    public AjaxResult markTaskComplete(@PathVariable("id") Long id) {
        GuildTask task = guildTaskService.selectGuildTaskById(id);
        if (task == null) return error("任务不存在");
        return toAjax(taskParticipantService.markComplete(id, getUserId()));
    }

    /** 参与者取消完成标记 */
    @PostMapping("/task/{id}/incomplete")
    public AjaxResult markTaskIncomplete(@PathVariable("id") Long id) {
        return toAjax(taskParticipantService.markIncomplete(id, getUserId()));
    }

    // ==================== 我的任务 ====================

    /** 查询当前用户参与的任务 */
    @GetMapping("/task/my")
    public TableDataInfo myTasks(@RequestParam(required = false) Long guildId) {
        startPage();
        List<GuildTask> list = guildTaskService.selectTasksByUserId(getUserId(), guildId);
        return getDataTable(list);
    }

    // ==================== 申请审批 ====================

    @GetMapping("/application/list")
    public TableDataInfo listApplication(GuildApplication application) {
        startPage();
        checkGuildRole(application.getGuildId());
        List<GuildApplication> list = guildApplicationService.selectGuildApplicationList(application);
        return getDataTable(list);
    }

    @PutMapping("/application/approve")
    public AjaxResult approveApplication(@RequestBody GuildApplication app) {
        GuildApplication existing = guildApplicationService.selectGuildApplicationById(app.getId());
        if (existing == null) return error("申请不存在");
        checkGuildRole(existing.getGuildId());
        return toAjax(guildApplicationService.approveGuildApplication(app.getId(), app.getStatus(), app.getRejectReason()));
    }

    // ==================== 成员管理 ====================

    @GetMapping("/member/list")
    public TableDataInfo listMember(GuildMember member) {
        startPage();
        List<GuildMember> list = guildMemberService.selectGuildMemberList(member);
        return getDataTable(list);
    }

    @PutMapping("/member/changeRole")
    public AjaxResult changeMemberRole(@RequestParam("id") Long id, @RequestParam("role") Integer role) {
        GuildMember member = guildMemberService.selectGuildMemberById(id);
        if (member == null) return error("成员不存在");
        GuildMember operator = checkGuildRole(member.getGuildId());
        if (operator.getRole() != 1) throw new ServiceException("仅会长可修改成员角色");
        if (member.getRole() == 1) throw new ServiceException("不能修改会长的角色");
        return toAjax(guildMemberService.changeRole(id, role));
    }

    @DeleteMapping("/member/{id}")
    public AjaxResult delMember(@PathVariable("id") Long id) {
        GuildMember member = guildMemberService.selectGuildMemberById(id);
        if (member == null) return error("成员不存在");
        GuildMember operator = checkGuildRole(member.getGuildId());
        if (operator.getRole() == 2 && member.getRole() != 3) throw new ServiceException("管理员只能移除普通成员");
        if (member.getRole() == 1) throw new ServiceException("不能移除会长");
        return toAjax(guildMemberService.deleteGuildMemberById(id));
    }
}
