package com.ruoyi.system.service.impl;

import com.ruoyi.common.core.domain.entity.SysDept;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.GamePartition;
import com.ruoyi.system.domain.Guild;
import com.ruoyi.system.mapper.GamePartitionMapper;
import com.ruoyi.system.mapper.GuildMapper;
import com.ruoyi.system.mapper.SysDeptMapper;
import com.ruoyi.system.service.IGuildService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 工会Service业务层处理
 * 
 * @author ruoyi
 */
@Service
public class GuildServiceImpl implements IGuildService {

    @Autowired
    private GuildMapper guildMapper;

    @Autowired
    private GamePartitionMapper gamePartitionMapper;

    @Autowired
    private SysDeptMapper deptMapper;

    /**
     * 查询工会
     * 
     * @param id 工会ID
     * @return 工会
     */
    @Override
    public Guild selectGuildById(Long id) {
        return guildMapper.selectGuildById(id);
    }

    /**
     * 查询工会列表
     * 
     * @param guild 查询条件
     * @return 工会列表
     */
    @Override
    public List<Guild> selectGuildList(Guild guild) {
        return guildMapper.selectGuildList(guild.getGamePartitionId(), guild.getName(), guild.getStatus());
    }

    /**
     * 新增工会
     * 
     * @param guild 工会
     * @return 结果
     */
    @Override
    public int insertGuild(Guild guild) {
        // 校验工会名称唯一性
        if (!checkNameUnique(guild.getGamePartitionId(), guild.getName(), null)) {
            throw new ServiceException("该游戏分区下工会名称已存在，请重新输入！");
        }
        // 初始化成员数量
        if (guild.getMemberCount() == null) {
            guild.setMemberCount(0);
        }
        // 初始化状态
        if (guild.getStatus() == null) {
            guild.setStatus(1);
        }
        
        // 自动创建对应部门并设置 dept_id
        Long deptId = createDeptForGuild(guild);
        if (deptId != null) {
            guild.setDeptId(deptId);
        }
        
        return guildMapper.insertGuild(guild);
    }
    
    /**
     * 创建工会对应的部门
     * 父部门为工会所属游戏分区的部门
     * @param guild 工会
     * @return 新创建的部门ID
     */
    private Long createDeptForGuild(Guild guild) {
        if (guild.getGamePartitionId() == null) {
            return null;
        }
        
        // 获取游戏分区信息
        GamePartition partition = gamePartitionMapper.selectGamePartitionById(guild.getGamePartitionId());
        if (partition == null || partition.getDeptId() == null) {
            return null;
        }
        
        // 获取游戏分区的部门信息
        Long partitionDeptId = partition.getDeptId();
        SysDept parentDept = deptMapper.selectDeptById(partitionDeptId);
        if (parentDept == null) {
            return null;
        }
        
        // 创建新部门
        SysDept dept = new SysDept();
        dept.setParentId(partitionDeptId);
        dept.setAncestors(parentDept.getAncestors() + "," + partitionDeptId);
        dept.setDeptName(guild.getName());
        dept.setOrderNum(0);
        dept.setStatus("0");
        dept.setCreateBy("system");
        
        deptMapper.insertDept(dept);
        return dept.getDeptId();
    }

    /**
     * 修改工会
     * 
     * @param guild 工会
     * @return 结果
     */
    @Override
    public int updateGuild(Guild guild) {
        // 校验工会名称唯一性
        if (StringUtils.isNotEmpty(guild.getName())) {
            if (!checkNameUnique(guild.getGamePartitionId(), guild.getName(), guild.getId())) {
                throw new ServiceException("该游戏分区下工会名称已存在，请重新输入！");
            }
        }
        return guildMapper.updateGuild(guild);
    }

    /**
     * 删除工会
     * 
     * @param id 工会ID
     * @return 结果
     */
    @Override
    public int deleteGuildById(Long id) {
        // 先获取工会信息，获取对应的部门ID
        Guild guild = guildMapper.selectGuildById(id);
        if (guild != null && guild.getDeptId() != null) {
            // 删除对应的部门
            deptMapper.deleteDeptById(guild.getDeptId());
        }
        return guildMapper.deleteGuildById(id);
    }

    /**
     * 查询用户管理的工会
     * 
     * @param userId 用户ID
     * @return 工会列表
     */
    @Override
    public List<Guild> selectGuildsByPresidentId(Long userId) {
        return guildMapper.selectGuildsByPresidentId(userId);
    }

    /**
     * 校验工会名称是否唯一
     * 
     * @param gamePartitionId 游戏分区ID
     * @param name 工会名称
     * @param id 工会ID
     * @return 结果
     */
    @Override
    public boolean checkNameUnique(Long gamePartitionId, String name, Long id) {
        if (gamePartitionId == null || StringUtils.isEmpty(name)) {
            return true;
        }
        int count = guildMapper.checkNameUnique(gamePartitionId, name, id);
        return count == 0;
    }

    /**
     * 修改工会状态
     * 
     * @param id 工会ID
     * @param status 状态
     * @return 结果
     */
    @Override
    public int changeStatus(Long id, Integer status) {
        Guild guild = new Guild();
        guild.setId(id);
        guild.setStatus(status);
        return guildMapper.updateGuild(guild);
    }

    /**
     * 更新成员数量
     * 
     * @param id 工会ID
     * @param count 变化数量
     * @return 结果
     */
    @Override
    public int updateMemberCount(Long id, int count) {
        return guildMapper.updateMemberCount(id, count);
    }
}
