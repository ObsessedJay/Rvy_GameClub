<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="default" :inline="true" v-show="showSearch" label-width="80px">
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
      <el-form-item label="操作人" prop="operatorName">
        <el-input
          v-model="queryParams.operatorName"
          placeholder="请输入操作人"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="操作类型" prop="operationType">
        <el-select v-model="queryParams.operationType" placeholder="操作类型" clearable>
          <el-option label="新增" value="CREATE" />
          <el-option label="修改" value="UPDATE" />
          <el-option label="删除" value="DELETE" />
          <el-option label="审批" value="APPROVE" />
          <el-option label="其他" value="OTHER" />
        </el-select>
      </el-form-item>
      <el-form-item label="操作时间">
        <el-date-picker
          v-model="dateRange"
          type="daterange"
          range-separator="-"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
          value-format="yyyy-MM-dd"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="Delete"
          @click="handleClear"
          v-hasPermi="['gameclub:operationLog:clear']"
        >清空日志</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="Download"
          @click="handleExport"
          v-hasPermi="['gameclub:operationLog:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="logList">
      <el-table-column label="日志ID" align="center" prop="id" width="80" />
      <el-table-column label="工会" align="center" prop="guildName" width="120" />
      <el-table-column label="操作人" align="center" prop="operatorName" width="100" />
      <el-table-column label="操作类型" align="center" prop="operationType" width="100">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.operationType === 'CREATE'" type="success">新增</el-tag>
          <el-tag v-else-if="scope.row.operationType === 'UPDATE'" type="primary">修改</el-tag>
          <el-tag v-else-if="scope.row.operationType === 'DELETE'" type="danger">删除</el-tag>
          <el-tag v-else-if="scope.row.operationType === 'APPROVE'" type="warning">审批</el-tag>
          <el-tag v-else>其他</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作模块" align="center" prop="module" width="120" />
      <el-table-column label="操作描述" align="center" prop="description" :show-overflow-tooltip="true" />
      <el-table-column label="IP地址" align="center" prop="ipAddress" width="130" />
      <el-table-column label="操作时间" align="center" prop="createdAt" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.createdAt) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="100">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="View"
            @click="handleView(scope.row)"
          >详情</el-button>
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

    <!-- 详情对话框 -->
    <el-dialog title="操作日志详情" :visible.sync="viewOpen" width="700px" append-to-body>
      <el-descriptions :column="2" border>
        <el-descriptions-item label="工会">{{ viewData.guildName }}</el-descriptions-item>
        <el-descriptions-item label="操作人">{{ viewData.operatorName }}</el-descriptions-item>
        <el-descriptions-item label="操作类型">
          <el-tag v-if="viewData.operationType === 'CREATE'" type="success">新增</el-tag>
          <el-tag v-else-if="viewData.operationType === 'UPDATE'" type="primary">修改</el-tag>
          <el-tag v-else-if="viewData.operationType === 'DELETE'" type="danger">删除</el-tag>
          <el-tag v-else-if="viewData.operationType === 'APPROVE'" type="warning">审批</el-tag>
          <el-tag v-else>其他</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="操作模块">{{ viewData.module }}</el-descriptions-item>
        <el-descriptions-item label="IP地址">{{ viewData.ipAddress }}</el-descriptions-item>
        <el-descriptions-item label="操作时间">{{ parseTime(viewData.createdAt) }}</el-descriptions-item>
        <el-descriptions-item label="操作描述" :span="2">{{ viewData.description }}</el-descriptions-item>
        <el-descriptions-item label="请求参数" :span="2">
          <pre style="white-space: pre-wrap; word-wrap: break-word;">{{ viewData.requestParams }}</pre>
        </el-descriptions-item>
        <el-descriptions-item label="响应结果" :span="2">
          <pre style="white-space: pre-wrap; word-wrap: break-word;">{{ viewData.responseData }}</pre>
        </el-descriptions-item>
      </el-descriptions>
      <div slot="footer" class="dialog-footer">
        <el-button @click="viewOpen = false">关 闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listOperationLog, getOperationLog, delOperationLog, clearOperationLog, exportOperationLog } from "@/api/gameclub/operationLog";
import { listGuild } from "@/api/gameclub/guild";
import { download } from "@/utils/request";

export default {
  name: "GuildOperationLog",
  data() {
    return {
      loading: true,
      showSearch: true,
      total: 0,
      logList: [],
      guildOptions: [],
      dateRange: [],
      viewOpen: false,
      viewData: {},
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        guildId: null,
        operatorName: null,
        operationType: null,
        beginTime: null,
        endTime: null
      }
    };
  },
  created() {
    this.getList();
    this.getGuildOptions();
  },
  methods: {
    getList() {
      this.loading = true;
      if (this.dateRange && this.dateRange.length === 2) {
        this.queryParams.beginTime = this.dateRange[0];
        this.queryParams.endTime = this.dateRange[1];
      } else {
        this.queryParams.beginTime = null;
        this.queryParams.endTime = null;
      }
      listOperationLog(this.queryParams).then(response => {
        this.logList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    getGuildOptions() {
      listGuild({}).then(response => {
        this.guildOptions = response.rows;
      });
    },
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    resetQuery() {
      this.dateRange = [];
      this.resetForm("queryForm");
      this.handleQuery();
    },
    handleView(row) {
      getOperationLog(row.id).then(response => {
        this.viewData = response.data;
        this.viewOpen = true;
      });
    },
    handleClear() {
      this.$modal.confirm('确认要清空所有操作日志吗？此操作不可恢复！').then(() => {
        if (!this.queryParams.guildId) {
          this.$modal.msgError("请先选择工会");
          return;
        }
        return clearOperationLog(this.queryParams.guildId);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("清空成功");
      }).catch(() => {});
    },
    handleExport() {
      if (!this.queryParams.guildId) {
        this.$modal.msgError("请先选择工会");
        return;
      }
      this.$modal.confirm('是否确认导出操作日志？').then(() => {
        this.download('system/guildOperationLog/export', this.queryParams, `operation_log_${new Date().getTime()}.xlsx`);
      }).catch(() => {});
    }
  }
};
</script>