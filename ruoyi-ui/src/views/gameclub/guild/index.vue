<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="游戏分区" prop="gamePartitionId">
        <el-select v-model="queryParams.gamePartitionId" placeholder="请选择游戏分区" clearable>
          <el-option
            v-for="item in partitionOptions"
            :key="item.id"
            :label="item.gameName"
            :value="item.id"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="工会名称" prop="name">
        <el-input
          v-model="queryParams.name"
          placeholder="请输入工会名称"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable>
          <el-option :key="1" label="正常" :value="1" />
          <el-option :key="0" label="解散" :value="0" />
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
          v-hasPermi="['gameclub:guild:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          @click="handleDelete"
          v-hasPermi="['gameclub:guild:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['gameclub:guild:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="guildList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="工会ID" align="center" prop="id" width="80" />
      <el-table-column label="游戏分区" align="center" prop="gamePartitionName" />
      <el-table-column label="工会名称" align="center" prop="name" :show-overflow-tooltip="true" />
      <el-table-column label="会长" align="center" prop="presidentName" />
      <el-table-column label="成员数" align="center" prop="memberCount" width="80" />
      <el-table-column label="状态" align="center" prop="status" width="100">
        <template slot-scope="scope">
          <el-switch
            v-model="scope.row.status"
            :active-value="1"
            :inactive-value="0"
            @change="handleStatusChange(scope.row)"
            v-hasPermi="['gameclub:guild:edit']"
          />
        </template>
      </el-table-column>
      <el-table-column label="创建时间" align="center" prop="createdAt" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.createdAt) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['gameclub:guild:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['gameclub:guild:remove']"
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

    <!-- 添加或修改工会对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="600px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="游戏分区" prop="gamePartitionId">
          <el-select v-model="form.gamePartitionId" placeholder="请选择游戏分区">
            <el-option
              v-for="item in partitionOptions"
              :key="item.id"
              :label="item.gameName"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="工会名称" prop="name">
          <el-input v-model="form.name" placeholder="请输入工会名称" />
        </el-form-item>
        <el-form-item label="工会简介" prop="description">
          <el-input v-model="form.description" type="textarea" placeholder="请输入工会简介" />
        </el-form-item>
        <el-form-item label="招募要求" prop="recruitRequirement">
          <el-input v-model="form.recruitRequirement" type="textarea" placeholder="请输入招募要求" />
        </el-form-item>
        <el-form-item label="在线时段" prop="onlineTime">
          <el-input v-model="form.onlineTime" placeholder="请输入常驻在线时段" />
        </el-form-item>
        <el-form-item label="状态">
          <el-radio-group v-model="form.status">
            <el-radio :label="1">正常</el-radio>
            <el-radio :label="0">解散</el-radio>
          </el-radio-group>
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
import { listGuild, getGuild, delGuild, addGuild, updateGuild, changeGuildStatus } from "@/api/gameclub/guild";
import { listGamePartition } from "@/api/gameclub/partition";

export default {
  name: "Guild",
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
      // 工会表格数据
      guildList: [],
      // 游戏分区选项
      partitionOptions: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        gamePartitionId: undefined,
        name: undefined,
        status: undefined
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        gamePartitionId: [
          { required: true, message: "游戏分区不能为空", trigger: "change" }
        ],
        name: [
          { required: true, message: "工会名称不能为空", trigger: "blur" }
        ]
      }
    };
  },
  created() {
    this.getList();
    this.getPartitionOptions();
  },
  methods: {
    /** 查询工会列表 */
    getList() {
      this.loading = true;
      listGuild(this.queryParams).then(response => {
        this.guildList = response.rows;
        this.total = response.total || 0;
        this.loading = false;
      });
    },
    /** 查询游戏分区选项 */
    getPartitionOptions() {
      listGamePartition({}).then(response => {
        this.partitionOptions = response.rows;
      });
    },
    // 取消按钮
    cancel() {
      this.open = false;
      this.reset();
    },
    // 表单重置
    reset() {
      this.form = {
        id: undefined,
        gamePartitionId: undefined,
        name: undefined,
        description: undefined,
        recruitRequirement: undefined,
        onlineTime: undefined,
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
      this.title = "添加工会";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids[0];
      getGuild(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改工会";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != undefined) {
            updateGuild(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addGuild(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除工会编号为"' + ids + '"的数据项？').then(function() {
        return delGuild(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    /** 工会状态修改 */
    handleStatusChange(row) {
      let text = row.status === 1 ? "启用" : "停用";
      this.$modal.confirm('确认要"' + text + '""' + row.name + '"工会吗？').then(function() {
        return changeGuildStatus(row.id, row.status);
      }).then(() => {
        this.$modal.msgSuccess(text + "成功");
      }).catch(function() {
        row.status = row.status === 0 ? 1 : 0;
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/guild/export', {
        ...this.queryParams
      }, `guild_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>
<style scoped>
/* 暗色主题样式 */
.app-container {
  background: #0a0a0f;
  min-height: calc(100vh - 50px);
  padding: 20px;
}
::v-deep .el-table {
  background: rgba(255, 255, 255, 0.03) !important;
  border-color: rgba(255, 255, 255, 0.08) !important;
}
::v-deep .el-table th,
::v-deep .el-table tr {
  background: rgba(255, 255, 255, 0.05) !important;
  color: #fff !important;
  border-color: rgba(255, 255, 255, 0.08) !important;
}
::v-deep .el-table td,
::v-deep .el-table th.is-leaf {
  border-color: rgba(255, 255, 255, 0.08) !important;
}
::v-deep .el-table--striped .el-table__body tr.el-table__row--striped td {
  background: rgba(255, 255, 255, 0.02) !important;
}
::v-deep .el-table--enable-row-hover .el-table__body tr:hover > td {
  background: rgba(0, 212, 255, 0.1) !important;
}
::v-deep .el-table .el-button--text {
  color: #00d4ff;
}
::v-deep .el-form-item__label {
  color: rgba(255, 255, 255, 0.8) !important;
}
::v-deep .el-input__inner {
  background: rgba(255, 255, 255, 0.05) !important;
  border-color: rgba(255, 255, 255, 0.15) !important;
  color: #fff !important;
}
::v-deep .el-input__inner:focus {
  border-color: #00d4ff !important;
}
::v-deep .el-select .el-input__inner {
  background: rgba(255, 255, 255, 0.05) !important;
  border-color: rgba(255, 255, 255, 0.15) !important;
  color: #fff !important;
}
::v-deep .el-select-dropdown {
  background: #1a1a2e !important;
  border-color: rgba(255, 255, 255, 0.1) !important;
}
::v-deep .el-select-dropdown__item {
  color: #fff !important;
}
::v-deep .el-select-dropdown__item.hover,
::v-deep .el-select-dropdown__item:hover {
  background: rgba(0, 212, 255, 0.1) !important;
}
::v-deep .el-dialog {
  background: #1a1a2e !important;
}
::v-deep .el-dialog__title {
  color: #fff !important;
}
::v-deep .el-dialog__body {
  color: rgba(255, 255, 255, 0.8) !important;
}
::v-deep .el-form-item__content {
  color: #fff !important;
}
::v-deep .el-button--primary {
  background: #00d4ff !important;
  border-color: #00d4ff !important;
  color: #000 !important;
}
::v-deep .el-button--primary:hover {
  background: #00b8e6 !important;
  border-color: #00b8e6 !important;
}
::v-deep .el-button--default {
  background: rgba(255, 255, 255, 0.05) !important;
  border-color: rgba(255, 255, 255, 0.15) !important;
  color: #fff !important;
}
::v-deep .el-button--default:hover {
  background: rgba(255, 255, 255, 0.1) !important;
  border-color: #00d4ff !important;
  color: #00d4ff !important;
}
::v-deep .el-switch.is-checked .el-switch__core {
  background-color: #00ff88 !important;
  border-color: #00ff88 !important;
}
</style>
