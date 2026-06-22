package com.ruoyi.system.service;

import com.ruoyi.system.domain.GuildApplication;

import java.util.List;

/**
 * 工会申请 Service 接口
 */
public interface IGuildApplicationService {

    /**
     * 查询工会申请列表
     *
     * @param application 申请信息
     * @return 申请列表
     */
    List<GuildApplication> selectGuildApplicationList(GuildApplication application);

    /**
     * 查询工会申请详细
     *
     * @param id 申请ID
     * @return 申请信息
     */
    GuildApplication selectGuildApplicationById(Long id);

    /**
     * 新增工会申请
     *
     * @param application 申请信息
     * @return 结果
     */
    int insertGuildApplication(GuildApplication application);

    /**
     * 修改工会申请
     *
     * @param application 申请信息
     * @return 结果
     */
    int updateGuildApplication(GuildApplication application);

    /**
     * 删除工会申请
     *
     * @param id 申请ID
     * @return 结果
     */
    int deleteGuildApplicationById(Long id);

    /**
     * 批量删除工会申请
     *
     * @param ids 需要删除的数据ID
     * @return 结果
     */
    int deleteGuildApplicationByIds(Long[] ids);

    /**
     * 审批申请
     *
     * @param id        申请ID
     * @param status    审批状态
     * @param remark    审批备注
     * @return 结果
     */
    int approveGuildApplication(Long id, Integer status, String remark);

    /**
     * 批量审批申请
     *
     * @param ids    申请ID列表
     * @param status 审批状态
     * @return 结果
     */
    int batchApproveGuildApplication(Long[] ids, Integer status);
}