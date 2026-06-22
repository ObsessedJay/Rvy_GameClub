package com.ruoyi.web.controller.common;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 前端路由转发控制器
 * 用于支持Vue history模式，将所有前端路由重定向到index.html
 */
@Controller
@RequestMapping("/")
public class ForwardController {

    /**
     * GameClub前台门户路由转发
     */
    @GetMapping("/gameclub-portal/**")
    public String forwardGameClubPortal() {
        return "forward:/index.html";
    }

    /**
     * GameClub用户工作台路由转发
     */
    @GetMapping("/gameclub-workspace/**")
    public String forwardGameClubWorkspace() {
        return "forward:/index.html";
    }
}