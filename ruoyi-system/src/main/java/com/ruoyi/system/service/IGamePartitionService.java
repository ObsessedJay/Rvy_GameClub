package com.ruoyi.system.service;

import com.ruoyi.system.domain.GamePartition;

import java.util.List;

/**
 * 游戏分区Service接口
 * 
 * @author ruoyi
 */
public interface IGamePartitionService {

    /**
     * 查询游戏分区
     * 
     * @param id 分区ID
     * @return 游戏分区
     */
    public GamePartition selectGamePartitionById(Long id);

    /**
     * 查询游戏分区列表
     * 
     * @param partition 查询条件
     * @return 游戏分区
     */
    public List<GamePartition> selectGamePartitionList(GamePartition partition);

    /**
     * 新增游戏分区
     * 
     * @param partition 游戏分区
     * @return 结果
     */
    public int insertGamePartition(GamePartition partition);

    /**
     * 修改游戏分区
     * 
     * @param partition 游戏分区
     * @return 结果
     */
    public int updateGamePartition(GamePartition partition);

    /**
     * 删除游戏分区
     * 
     * @param id 分区ID
     * @return 结果
     */
    public int deleteGamePartitionById(Long id);

    /**
     * 获取所有启用的游戏分区
     * 
     * @return 游戏分区列表
     */
    public List<GamePartition> selectEnabledPartitions();

    /**
     * 校验游戏编码是否唯一
     * 
     * @param gameCode 游戏编码
     * @return 结果
     */
    public boolean checkGameCodeUnique(String gameCode);

    /**
     * 修改游戏分区状态
     * 
     * @param id 分区ID
     * @param status 状态
     * @return 结果
     */
    public int changeStatus(Long id, Integer status);
}
