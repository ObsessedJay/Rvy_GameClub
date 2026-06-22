package com.ruoyi.web.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * Web MVC配置
 * 配置前端路由重写，支持Vue history模式
 */
@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    /**
     * 配置前端路由重写
     * 将所有非API请求重定向到index.html，支持Vue history模式
     */
    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        // 配置前端路由重写，当访问非API路径时返回index.html
        // Vue会在前端处理路由
        registry.addViewController("/gameclub-portal/**").setViewName("forward:/index.html");
        registry.addViewController("/gameclub-workspace/**").setViewName("forward:/index.html");
    }
}