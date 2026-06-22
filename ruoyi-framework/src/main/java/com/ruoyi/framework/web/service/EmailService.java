package com.ruoyi.framework.web.service;

import jakarta.annotation.Resource;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Component;
import com.ruoyi.common.constant.CacheConstants;
import com.ruoyi.common.core.redis.RedisCache;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;

import java.util.Random;
import java.util.concurrent.TimeUnit;

/**
 * 邮箱服务
 * 
 * @author ruoyi
 */
@Component
public class EmailService
{
    @Resource
    private JavaMailSender mailSender;

    @Resource
    private RedisCache redisCache;

    @Value("${spring.mail.username}")
    private String fromEmail;

    /**
     * 发送邮箱验证码
     * 
     * @param email 目标邮箱
     * @return 是否发送成功
     */
    public boolean sendEmailCode(String email)
    {
        if (StringUtils.isEmpty(email))
        {
            throw new ServiceException("邮箱地址不能为空");
        }
        
        // 生成6位验证码
        String code = generateCode();
        
        // 保存验证码到Redis，有效期60秒
        String key = CacheConstants.EMAIL_CODE_KEY + email;
        redisCache.setCacheObject(key, code, 60, TimeUnit.SECONDS);
        
        // 发送邮件
        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom(fromEmail);
        message.setTo(email);
        message.setSubject("若依系统 - 注册验证码");
        message.setText("您的注册验证码为：" + code + "，有效期60秒，请尽快使用。");
        
        try
        {
            mailSender.send(message);
            return true;
        }
        catch (Exception e)
        {
            throw new ServiceException("发送邮件失败，请稍后重试");
        }
    }

    /**
     * 验证邮箱验证码
     * 
     * @param email 邮箱地址
     * @param code 验证码
     * @return 是否验证成功
     */
    public boolean validateEmailCode(String email, String code)
    {
        if (StringUtils.isEmpty(email) || StringUtils.isEmpty(code))
        {
            return false;
        }
        
        String key = CacheConstants.EMAIL_CODE_KEY + email;
        String cachedCode = redisCache.getCacheObject(key);
        
        if (cachedCode == null)
        {
            return false;
        }
        
        boolean isValid = cachedCode.equals(code);
        
        // 验证成功后删除验证码
        if (isValid)
        {
            redisCache.deleteObject(key);
        }
        
        return isValid;
    }

    /**
     * 生成6位数字验证码
     * 
     * @return 验证码
     */
    private String generateCode()
    {
        Random random = new Random();
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < 6; i++)
        {
            sb.append(random.nextInt(10));
        }
        return sb.toString();
    }
}