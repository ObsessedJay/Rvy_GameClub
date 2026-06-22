<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="default" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="游戏名称" prop="gameName">
        <el-input
          v-model="queryParams.gameName"
          placeholder="请输入游戏名称"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="游戏编码" prop="gameCode">
        <el-input
          v-model="queryParams.gameCode"
          placeholder="请输入游戏编码"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="游戏分区状态" clearable>
          <el-option label="启用" :value="1" />
          <el-option label="禁用" :value="0" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="Plus"
          @click="handleAdd"
          v-hasPermi="['gameclub:partition:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="Download"
          @click="handleExport"
          v-hasPermi="['gameclub:partition:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="partitionList">
      <el-table-column label="分区ID" align="center" prop="id" />
      <el-table-column label="游戏名称" align="center" prop="gameName" :show-overflow-tooltip="true" />
      <el-table-column label="游戏编码" align="center" prop="gameCode" />
      <el-table-column label="游戏简介" align="center" prop="description" :show-overflow-tooltip="true" />
      <el-table-column label="排序" align="center" prop="sortOrder" width="80" />
      <el-table-column label="状态" align="center" prop="status" width="100">
        <template slot-scope="scope">
          <el-switch
            v-model="scope.row.status"
            :active-value="1"
            :inactive-value="0"
            @change="handleStatusChange(scope.row)"
            v-hasPermi="['gameclub:partition:edit']"
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
            icon="Edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['gameclub:partition:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="Delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['gameclub:partition:remove']"
          >删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total > 0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />

    <!-- 添加或修改游戏分区对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="游戏名称" prop="gameName">
          <el-input v-model="form.gameName" placeholder="请输入游戏名称" />
        </el-form-item>
        <el-form-item label="游戏编码" prop="gameCode">
          <el-input v-model="form.gameCode" placeholder="请输入唯一编码，如: lol" />
        </el-form-item>
        <el-form-item label="游戏简介" prop="description">
          <el-input v-model="form.description" type="textarea" placeholder="请输入游戏简介" />
        </el-form-item>
        <el-form-item label="排序" prop="sortOrder">
          <el-input-number v-model="form.sortOrder" :min="0" controls-position="right" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio :label="1">启用</el-radio>
            <el-radio :label="0">禁用</el-radio>
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
import { listGamePartition, getGamePartition, delGamePartition, addGamePartition, updateGamePartition, changeStatus } from "@/api/gameclub/partition";

export default {
  name: "GamePartition",
  data() {
    return {
      // 遮罩层
      loading: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 游戏分区表格数据
      partitionList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        gameName: null,
        gameCode: null,
        status: null
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        gameName: [
          { required: true, message: "游戏名称不能为空", trigger: "blur" }
        ],
        gameCode: [
          { required: true, message: "游戏编码不能为空", trigger: "blur" },
          { pattern: /^[a-z0-9]+$/, message: "游戏编码只能包含小写字母和数字", trigger: "blur" }
        ]
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    /** 查询游戏分区列表 */
    getList() {
      this.loading = true;
      listGamePartition(this.queryParams).then(response => {
        this.partitionList = response.rows;
        this.total = response.total || 0;
        this.loading = false;
      });
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
    // 表单重置
    reset() {
      this.form = {
        id: null,
        gameName: null,
        gameCode: null,
        icon: null,
        description: null,
        sortOrder: 0,
        status: 1
      };
      this.resetForm("form");
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加游戏分区";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids;
      getGamePartition(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改游戏分区";
      });
    },
    /** 状态修改 */
    handleStatusChange(row) {
      let text = row.status === 1 ? "启用" : "禁用";
      this.$modal.confirm('确认要"' + text + '""' + row.gameName + '"游戏分区吗？').then(function() {
        return changeStatus(row.id, row.status);
      }).then(() => {
        this.$modal.msgSuccess(text + "成功");
      }).catch(function() {
        row.status = row.status === 1 ? 0 : 1;
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            updateGamePartition(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addGamePartition(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    /** 取消按钮 */
    cancel() {
      this.open = false;
      this.reset();
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const ids = row.id || this.ids;
      this.$modal.confirm('是否确认删除游戏分区编号为"' + ids + '"的数据项？').then(function() {
        return delGamePartition(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('gameclub/partition/export', {
        ...this.queryParams
      }, `game_partition_${new Date().getTime()}.xlsx`);
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
</style>
