package com.ruoyi.web.controller.system;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.system.domain.GamePartition;
import com.ruoyi.system.service.IGamePartitionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 游戏分区Controller
 * 
 * @author ruoyi
 */
@RestController
@RequestMapping("/system/gamePartition")
public class GamePartitionController extends BaseController {

    @Autowired
    private IGamePartitionService gamePartitionService;

    /**
     * 获取游戏分区列表
     */
    @PreAuthorize("@ss.hasPermi('gameclub:partition:list')")
    @GetMapping("/list")
    @ResponseBody
    public TableDataInfo list(GamePartition partition) {
        startPage();
        List<GamePartition> list = gamePartitionService.selectGamePartitionList(partition);
        return getDataTable(list);
    }

    /**
     * 导出游戏分区列表
     */
    @PreAuthorize("@ss.hasPermi('gameclub:partition:export')")
    @Log(title = "游戏分区", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, GamePartition partition) {
        List<GamePartition> list = gamePartitionService.selectGamePartitionList(partition);
        ExcelUtil<GamePartition> util = new ExcelUtil<>(GamePartition.class);
        util.exportExcel(response, list, "游戏分区数据");
    }

    /**
     * 获取所有启用的游戏分区（下拉框用）
     */
    @GetMapping("/options")
    @ResponseBody
    public AjaxResult options() {
        List<GamePartition> list = gamePartitionService.selectEnabledPartitions();
        return success(list);
    }

    /**
     * 根据分区ID获取详细信息
     */
    @PreAuthorize("@ss.hasPermi('gameclub:partition:query')")
    @GetMapping(value = "/{id}")
    @ResponseBody
    public AjaxResult getInfo(@PathVariable("id") Long id) {
        return success(gamePartitionService.selectGamePartitionById(id));
    }

    /**
     * 新增游戏分区
     */
    @PreAuthorize("@ss.hasPermi('gameclub:partition:add')")
    @Log(title = "游戏分区", businessType = BusinessType.INSERT)
    @PostMapping
    @ResponseBody
    public AjaxResult add(@Validated @RequestBody GamePartition partition) {
        partition.setCreateBy(getUsername());
        return toAjax(gamePartitionService.insertGamePartition(partition));
    }

    /**
     * 修改游戏分区
     */
    @PreAuthorize("@ss.hasPermi('gameclub:partition:edit')")
    @Log(title = "游戏分区", businessType = BusinessType.UPDATE)
    @PutMapping
    @ResponseBody
    public AjaxResult edit(@Validated @RequestBody GamePartition partition) {
        partition.setUpdateBy(getUsername());
        return toAjax(gamePartitionService.updateGamePartition(partition));
    }

    /**
     * 修改游戏分区状态
     */
    @PreAuthorize("@ss.hasPermi('gameclub:partition:edit')")
    @Log(title = "游戏分区", businessType = BusinessType.UPDATE)
    @PutMapping("/changeStatus")
    @ResponseBody
    public AjaxResult changeStatus(@RequestParam("id") Long id, @RequestParam("status") Integer status) {
        return toAjax(gamePartitionService.changeStatus(id, status));
    }

    /**
     * 删除游戏分区
     */
    @PreAuthorize("@ss.hasPermi('gameclub:partition:remove')")
    @Log(title = "游戏分区", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    @ResponseBody
    public AjaxResult remove(@PathVariable Long[] ids) {
        return toAjax(gamePartitionService.deleteGamePartitionById(ids[0]));
    }
}
