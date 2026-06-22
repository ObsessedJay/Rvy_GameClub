package com.ruoyi.web.controller.system;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.domain.entity.SysUserDept;
import com.ruoyi.common.core.domain.entity.SysWebsiteConfig;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.service.ISysUserDeptService;
import com.ruoyi.system.service.ISysWebsiteConfigService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 用户-业务网站部门关联 Controller
 * 用于方案C：多对多用户部门归属管理
 * 
 * @author ruoyi
 */
@RestController
@RequestMapping("/system/userDept")
public class SysUserDeptController extends BaseController
{
    @Autowired
    private ISysUserDeptService userDeptService;

    @Autowired
    private ISysWebsiteConfigService websiteConfigService;

    /**
     * 查询当前用户在某个业务网站的部门归属
     * 
     * @param websiteCode 业务网站编码（如 GAMECLUB）
     */
    @GetMapping("/my/{websiteCode}")
    public AjaxResult getMyDept(@PathVariable("websiteCode") String websiteCode)
    {
        SysUserDept userDept = userDeptService.selectByUserAndWebsite(getUserId(), websiteCode);
        return success(userDept);
    }

    /**
     * 查询当前用户的所有业务网站部门归属
     */
    @GetMapping("/myAll")
    public AjaxResult getMyAllDepts()
    {
        List<SysUserDept> list = userDeptService.selectByUserId(getUserId());
        return success(list);
    }

    /**
     * 首次进入业务网站自动登记
     * 用户第一次点击进入某个业务网站（如GameClub）时调用此接口
     * 如果已有记录则不做改动直接返回，如无则创建默认部门归属
     * 
     * @param websiteCode 业务网站编码（如 GAMECLUB）
     */
    @Log(title = "用户业务网站登记", businessType = BusinessType.OTHER)
    @PostMapping("/register/{websiteCode}")
    public AjaxResult registerToWebsite(@PathVariable("websiteCode") String websiteCode)
    {
        SysUserDept userDept = userDeptService.registerUserToWebsite(getUserId(), websiteCode);
        return success(userDept);
    }

    /**
     * 查询所有业务网站配置
     */
    @GetMapping("/websites")
    public AjaxResult getAllWebsiteConfigs()
    {
        List<SysWebsiteConfig> list = websiteConfigService.selectAll();
        return success(list);
    }

    /**
     * 查询指定用户在所有业务网站的部门归属（管理员用）
     */
    @GetMapping("/user/{userId}")
    public AjaxResult getUserDepts(@PathVariable("userId") Long userId)
    {
        List<SysUserDept> list = userDeptService.selectByUserId(userId);
        return success(list);
    }

    /**
     * 查询某个部门下的所有用户关联（管理员用）
     */
    @GetMapping("/dept/{deptId}")
    public AjaxResult getDeptUsers(@PathVariable("deptId") Long deptId)
    {
        List<SysUserDept> list = userDeptService.selectByDeptId(deptId);
        return success(list);
    }
}
