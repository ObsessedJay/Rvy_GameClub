package com.ruoyi.web.controller.system;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.GuildMessage;
import com.ruoyi.system.service.IGuildMessageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 工会消息Controller
 * 
 * @author ruoyi
 */
@RestController
@RequestMapping("/system/guildMessage")
public class GuildMessageController extends BaseController {

    @Autowired
    private IGuildMessageService guildMessageService;

    /**
     * 获取工会消息列表
     */
    @PreAuthorize("@ss.hasPermi('gameclub:message:list')")
    @GetMapping("/list")
    public TableDataInfo list(GuildMessage message) {
        startPage();
        List<GuildMessage> list = guildMessageService.selectGuildMessageList(message);
        return getDataTable(list);
    }

    /**
     * 根据消息ID获取详细信息
     */
    @PreAuthorize("@ss.hasPermi('gameclub:message:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id) {
        return success(guildMessageService.selectGuildMessageById(id));
    }

    /**
     * 新增工会消息
     */
    @PreAuthorize("@ss.hasPermi('gameclub:message:add')")
    @Log(title = "工会消息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody GuildMessage message) {
        return toAjax(guildMessageService.insertGuildMessage(message));
    }

    /**
     * 修改工会消息
     */
    @PreAuthorize("@ss.hasPermi('gameclub:message:edit')")
    @Log(title = "工会消息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody GuildMessage message) {
        return toAjax(guildMessageService.updateGuildMessage(message));
    }

    /**
     * 删除工会消息
     */
    @PreAuthorize("@ss.hasPermi('gameclub:message:remove')")
    @Log(title = "工会消息", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids) {
        return toAjax(guildMessageService.deleteGuildMessageById(ids[0]));
    }

    /**
     * 标记为已读
     */
    @PutMapping("/read/{id}")
    public AjaxResult markAsRead(@PathVariable("id") Long id) {
        return toAjax(guildMessageService.markAsRead(id));
    }

    /**
     * 批量标记为已读
     */
    @PutMapping("/readAll")
    public AjaxResult markAllAsRead() {
        return toAjax(guildMessageService.markAllAsRead(getUserId()));
    }

    /**
     * 查询未读消息数量
     */
    @GetMapping("/unreadCount")
    public AjaxResult unreadCount() {
        int count = guildMessageService.countUnread(getUserId());
        return success(count);
    }

    /**
     * 查询我的消息列表
     */
    @GetMapping("/myMessages")
    public TableDataInfo myMessages(GuildMessage message) {
        startPage();
        message.setReceiverId(getUserId());
        List<GuildMessage> list = guildMessageService.selectGuildMessageList(message);
        return getDataTable(list);
    }
}
