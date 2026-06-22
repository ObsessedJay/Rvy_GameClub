package com.ruoyi.system.service.impl;

import com.ruoyi.common.core.domain.entity.SysDept;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.GamePartition;
import com.ruoyi.system.mapper.GamePartitionMapper;
import com.ruoyi.system.mapper.SysDeptMapper;
import com.ruoyi.system.service.IGamePartitionService;
import com.ruoyi.system.service.ISysWebsiteConfigService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 游戏分区Service业务层处理
 * 
 * @author ruoyi
 */
@Service
public class GamePartitionServiceImpl implements IGamePartitionService {

    @Autowired
    private GamePartitionMapper gamePartitionMapper;

    @Autowired
    private SysDeptMapper deptMapper;

    @Autowired
    private ISysWebsiteConfigService websiteConfigService;

    /**
     * 查询游戏分区
     * 
     * @param id 分区ID
     * @return 游戏分区
     */
    @Override
    public GamePartition selectGamePartitionById(Long id) {
        return gamePartitionMapper.selectGamePartitionById(id);
    }

    /**
     * 查询游戏分区列表
     * 
     * @param query 查询条件
     * @return 游戏分区
     */
    @Override
    public List<GamePartition> selectGamePartitionList(GamePartition query) {
        return gamePartitionMapper.selectGamePartitionList(query.getGameCode(), query.getStatus());
    }

    /**
     * 新增游戏分区
     * 
     * @param partition 游戏分区
     * @return 结果
     */
    @Override
    public int insertGamePartition(GamePartition partition) {
        // 校验游戏编码唯一性
        if (!checkGameCodeUnique(partition.getGameCode())) {
            throw new ServiceException("游戏编码已存在，请重新输入！");
        }
        
        // 自动创建对应部门并设置 dept_id
        Long deptId = createDeptForGamePartition(partition);
        if (deptId != null) {
            partition.setDeptId(deptId);
        }
        
        return gamePartitionMapper.insertGamePartition(partition);
    }
    
    /**
     * 创建游戏分区对应的部门
     * 父部门为业务网站(GAMECLUB)的根部门
     * @param partition 游戏分区
     * @return 新创建的部门ID
     */
    private Long createDeptForGamePartition(GamePartition partition) {
        // 获取 GameClub 业务网站的根部门ID
        Long gameClubRootDeptId = websiteConfigService.getRootDeptId("GAMECLUB");
        if (gameClubRootDeptId == null) {
            return null;
        }
        
        // 获取父部门信息，构建 ancestors
        SysDept parentDept = deptMapper.selectDeptById(gameClubRootDeptId);
        if (parentDept == null) {
            return null;
        }
        
        // 创建新部门
        SysDept dept = new SysDept();
        dept.setParentId(gameClubRootDeptId);
        dept.setAncestors(parentDept.getAncestors() + "," + gameClubRootDeptId);
        dept.setDeptName(partition.getGameName());
        dept.setOrderNum(partition.getSortOrder() != null ? partition.getSortOrder() : 0);
        dept.setStatus("0");
        dept.setCreateBy("system");
        
        deptMapper.insertDept(dept);
        return dept.getDeptId();
    }

    /**
     * 修改游戏分区
     * 
     * @param partition 游戏分区
     * @return 结果
     */
    @Override
    public int updateGamePartition(GamePartition partition) {
        // 校验游戏编码唯一性
        if (!checkGameCodeUnique(partition.getGameCode(), partition.getId())) {
            throw new ServiceException("游戏编码已存在，请重新输入！");
        }
        return gamePartitionMapper.updateGamePartition(partition);
    }

    /**
     * 删除游戏分区
     * 
     * @param id 分区ID
     * @return 结果
     */
    @Override
    public int deleteGamePartitionById(Long id) {
        // 先获取游戏分区信息，获取对应的部门ID
        GamePartition partition = gamePartitionMapper.selectGamePartitionById(id);
        if (partition != null && partition.getDeptId() != null) {
            // 删除对应的部门
            deptMapper.deleteDeptById(partition.getDeptId());
        }
        return gamePartitionMapper.deleteGamePartitionById(id);
    }

    /**
     * 获取所有启用的游戏分区
     * 
     * @return 游戏分区列表
     */
    @Override
    public List<GamePartition> selectEnabledPartitions() {
        return gamePartitionMapper.selectEnabledPartitions();
    }

    /**
     * 校验游戏编码是否唯一
     * 
     * @param gameCode 游戏编码
     * @return 结果
     */
    @Override
    public boolean checkGameCodeUnique(String gameCode) {
        return checkGameCodeUnique(gameCode, null);
    }

    /**
     * 校验游戏编码是否唯一（带排除ID）
     * 
     * @param gameCode 游戏编码
     * @param id 分区ID
     * @return 结果
     */
    private boolean checkGameCodeUnique(String gameCode, Long id) {
        if (StringUtils.isEmpty(gameCode)) {
            return true;
        }
        int count = gamePartitionMapper.checkGameCodeUnique(gameCode, id);
        return count == 0;
    }

    /**
     * 修改游戏分区状态
     * 
     * @param id 分区ID
     * @param status 状态
     * @return 结果
     */
    @Override
    public int changeStatus(Long id, Integer status) {
        GamePartition partition = new GamePartition();
        partition.setId(id);
        partition.setStatus(status);
        return gamePartitionMapper.updateGamePartition(partition);
    }
}
