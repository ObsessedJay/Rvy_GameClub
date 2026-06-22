package com.ruoyi.web.controller.system;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.GuildMember;
import com.ruoyi.system.service.IGuildMemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 工会成员Controller
 * 
 * @author ruoyi
 */
@RestController
@RequestMapping("/system/guildMember")
public class GuildMemberController extends BaseController {

    @Autowired
    private IGuildMemberService guildMemberService;

    /**
     * 获取工会成员列表
     */
    @PreAuthorize("@ss.hasPermi('gameclub:member:list')")
    @GetMapping("/list")
    public TableDataInfo list(GuildMember member) {
        startPage();
        List<GuildMember> list = guildMemberService.selectGuildMemberList(member);
        return getDataTable(list);
    }

    /**
     * 根据成员ID获取详细信息
     */
    @PreAuthorize("@ss.hasPermi('gameclub:member:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id) {
        return success(guildMemberService.selectGuildMemberById(id));
    }

    /**
     * 新增工会成员
     */
    @PreAuthorize("@ss.hasPermi('gameclub:member:add')")
    @Log(title = "工会成员", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody GuildMember member) {
        return toAjax(guildMemberService.insertGuildMember(member));
    }

    /**
     * 修改工会成员
     */
    @PreAuthorize("@ss.hasPermi('gameclub:member:edit')")
    @Log(title = "工会成员", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody GuildMember member) {
        return toAjax(guildMemberService.updateGuildMember(member));
    }

    /**
     * 修改成员角色
     */
    @PreAuthorize("@ss.hasPermi('gameclub:member:edit')")
    @Log(title = "工会成员", businessType = BusinessType.UPDATE)
    @PutMapping("/changeRole")
    public AjaxResult changeRole(@RequestParam("id") Long id, @RequestParam("role") Integer role) {
        return toAjax(guildMemberService.changeRole(id, role));
    }

    /**
     * 退出工会
     */
    @PreAuthorize("@ss.hasPermi('gameclub:member:quit')")
    @Log(title = "工会成员", businessType = BusinessType.UPDATE)
    @PutMapping("/quit/{id}")
    public AjaxResult quit(@PathVariable("id") Long id) {
        return toAjax(guildMemberService.quitGuild(id));
    }

    /**
     * 删除工会成员
     */
    @PreAuthorize("@ss.hasPermi('gameclub:member:remove')")
    @Log(title = "工会成员", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids) {
        return toAjax(guildMemberService.deleteGuildMemberById(ids[0]));
    }

    /**
     * 查询用户在指定游戏分区的工会成员信息
     */
    @GetMapping("/myGuild")
    public AjaxResult myGuild(@RequestParam("gamePartitionId") Long gamePartitionId) {
        GuildMember member = guildMemberService.selectByPartitionAndUser(gamePartitionId, getUserId());
        return success(member);
    }

    /**
     * 获取当前用户的所有工会成员身份
     */
    @GetMapping("/myGuilds")
    public AjaxResult myGuilds() {
        GuildMember query = new GuildMember();
        query.setUserId(getUserId());
        List<GuildMember> list = guildMemberService.selectGuildMemberList(query);
        // 只返回正常状态的
        java.util.List<GuildMember> activeList = new java.util.ArrayList<>();
        if (list != null) {
            for (GuildMember m : list) {
                if (m.getStatus() != null && m.getStatus() == 1) {
                    activeList.add(m);
                }
            }
        }
        return success(activeList);
    }

    /**
     * 获取当前用户的GameClub身份信息（名称+角色+第一个工会）
     */
    @GetMapping("/myRole")
    public AjaxResult myRole() {
        // 查询当前用户在当前GameClub下的工会成员身份
        GuildMember query = new GuildMember();
        query.setUserId(getUserId());
        List<GuildMember> list = guildMemberService.selectGuildMemberList(query);
        
        GuildMember activeMember = null;
        if (list != null && !list.isEmpty()) {
            // 优先找status=1（正常）的成员
            for (GuildMember m : list) {
                if (m.getStatus() != null && m.getStatus() == 1) {
                    activeMember = m;
                    break;
                }
            }
        }

        java.util.Map<String, Object> result = new java.util.HashMap<>();
        result.put("userName", getLoginUser().getUser().getUserName());
        result.put("nickName", getLoginUser().getUser().getNickName());
        if (activeMember != null) {
            result.put("role", activeMember.getRole());
            result.put("guildId", activeMember.getGuildId());
            result.put("guildName", activeMember.getGuildName());
        } else {
            result.put("role", 4); // 无工会用户
            result.put("guildId", null);
            result.put("guildName", null);
        }
        return success(result);
    }
}
