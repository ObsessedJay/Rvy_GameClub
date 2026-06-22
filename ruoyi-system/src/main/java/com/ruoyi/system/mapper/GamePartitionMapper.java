package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.GamePartition;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 游戏分区Mapper接口
 * 
 * @author ruoyi
 */
public interface GamePartitionMapper {

    /**
     * 查询游戏分区
     * 
     * @param id 分区ID
     * @return 游戏分区
     */
    public GamePartition selectGamePartitionById(@Param("id") Long id);

    /**
     * 查询游戏分区列表
     * 
     * @param partition 查询条件
     * @return 游戏分区集合
     */
    public List<GamePartition> selectGamePartitionList(@Param("gameCode") String gameCode, @Param("status") Integer status);

    /**
     * 根据游戏编码查询游戏分区
     * 
     * @param gameCode 游戏编码
     * @return 游戏分区
     */
    public GamePartition selectByGameCode(@Param("gameCode") String gameCode);

    /**
     * 校验游戏编码是否唯一
     * 
     * @param gameCode 游戏编码
     * @param id 分区ID
     * @return 结果
     */
    public int checkGameCodeUnique(@Param("gameCode") String gameCode, @Param("id") Long id);

    /**
     * 获取所有启用的游戏分区
     * 
     * @return 游戏分区列表
     */
    public List<GamePartition> selectEnabledPartitions();

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
    public int deleteGamePartitionById(@Param("id") Long id);
}
