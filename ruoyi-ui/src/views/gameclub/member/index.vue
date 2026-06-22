<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="工会" prop="guildId">
        <el-select v-model="queryParams.guildId" placeholder="请选择工会" clearable filterable>
          <el-option
            v-for="item in guildOptions"
            :key="item.id"
            :label="item.name"
            :value="item.id"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="角色" prop="role">
        <el-select v-model="queryParams.role" placeholder="请选择角色" clearable>
          <el-option :key="1" label="会长" :value="1" />
          <el-option :key="2" label="管理员" :value="2" />
          <el-option :key="3" label="普通成员" :value="3" />
          <el-option :key="4" label="无工会用户" :value="4" />
        </el-select>
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable>
          <el-option :key="1" label="正常" :value="1" />
          <el-option :key="0" label="已退出" :value="0" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="el-icon-plus"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['gameclub:member:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          @click="handleDelete"
          v-hasPermi="['gameclub:member:remove']"
        >删除</el-button>
      </el-col>
      <right-toolbar @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="memberList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="记录ID" align="center" prop="id" />
      <el-table-column label="工会名称" align="center" prop="guildName" :show-overflow-tooltip="true" />
      <el-table-column label="游戏分区" align="center" prop="gamePartitionName" />
      <el-table-column label="用户名" align="center" prop="userName" />
      <el-table-column label="昵称" align="center" prop="nickName" />
      <el-table-column label="角色" align="center" prop="role">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.role === 1" type="danger">会长</el-tag>
          <el-tag v-else-if="scope.row.role === 2" type="warning">管理员</el-tag>
          <el-tag v-else-if="scope.row.role === 4" type="info">无工会用户</el-tag>
          <el-tag v-else type="">普通成员</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="入会时间" align="center" prop="joinTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.joinTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="状态" align="center" prop="status">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.status === 1" type="success">正常</el-tag>
          <el-tag v-else type="info">已退出</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['gameclub:member:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['gameclub:member:remove']"
          >删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total>0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />

    <!-- 添加或修改工会成员对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="600px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="工会" prop="guildId">
          <el-select v-model="form.guildId" placeholder="请选择工会" filterable @change="handleGuildChange">
            <el-option
              v-for="item in guildOptions"
              :key="item.id"
              :label="item.name"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="用户" prop="userId">
          <el-select v-model="form.userId" placeholder="请选择用户" filterable>
            <el-option
              v-for="item in userOptions"
              :key="item.userId"
              :label="item.nickName + '(' + item.userName + ')'"
              :value="item.userId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="角色" prop="role">
          <el-select v-model="form.role" placeholder="请选择角色">
            <el-option :key="1" label="会长" :value="1" />
            <el-option :key="2" label="管理员" :value="2" />
            <el-option :key="3" label="普通成员" :value="3" />
            <el-option :key="4" label="无工会用户" :value="4" />
          </el-select>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listGuildMember, getGuildMember, delGuildMember, addGuildMember, updateGuildMember } from "@/api/gameclub/member";
import { listGuild } from "@/api/gameclub/guild";
import { listUser } from "@/api/system/user";

export default {
  name: "GuildMember",
  data() {
    return {
      // 遮罩层
      loading: true,
      // 选中数组
      ids: [],
      // 非单个禁用
      single: true,
      // 非多个禁用
      multiple: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 工会成员表格数据
      memberList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 工会选项
      guildOptions: [],
      // 用户选项
      userOptions: [],
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        guildId: null,
        role: null,
        status: null
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        guildId: [
          { required: true, message: "工会不能为空", trigger: "blur" }
        ],
        userId: [
          { required: true, message: "用户不能为空", trigger: "blur" }
        ],
        role: [
          { required: true, message: "角色不能为空", trigger: "blur" }
        ]
      }
    };
  },
  created() {
    this.getList();
    this.getGuildOptions();
    this.getUserOptions();
  },
  methods: {
    /** 查询工会成员列表 */
    getList() {
      this.loading = true;
      listGuildMember(this.queryParams).then(response => {
        this.memberList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    /** 查询工会选项 */
    getGuildOptions() {
      listGuild({}).then(response => {
        this.guildOptions = response.rows;
      });
    },
    /** 查询用户选项 */
    getUserOptions() {
      listUser({}).then(response => {
        this.userOptions = response.rows;
      });
    },
    /** 工会选择变化 */
    handleGuildChange(guildId) {
      const guild = this.guildOptions.find(item => item.id === guildId);
      if (guild) {
        this.form.gamePartitionId = guild.gamePartitionId;
      }
    },
    // 取消按钮
    cancel() {
      this.open = false;
      this.reset();
    },
    // 表单重置
    reset() {
      this.form = {
        id: null,
        guildId: null,
        gamePartitionId: null,
        userId: null,
        role: 3,
        status: 1
      };
      this.resetForm("form");
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.id);
      this.single = selection.length !== 1;
      this.multiple = !selection.length;
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加工会成员";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids;
      getGuildMember(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改工会成员";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            updateGuildMember(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addGuildMember(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const ids = row.id || this.ids;
      this.$modal.confirm('是否确认删除工会成员编号为"' + ids + '"的数据项？').then(function() {
        return delGuildMember(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    }
  }
};
</script>
