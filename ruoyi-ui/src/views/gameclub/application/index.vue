<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="default" :inline="true" v-show="showSearch" label-width="68px">
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
      <el-form-item label="申请人" prop="applicantName">
        <el-input
          v-model="queryParams.applicantName"
          placeholder="请输入申请人"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="申请状态" clearable>
          <el-option label="待审批" :value="0" />
          <el-option label="已通过" :value="1" />
          <el-option label="已拒绝" :value="2" />
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
          type="success"
          plain
          icon="Check"
          :disabled="multiple"
          @click="handleBatchApprove(1)"
          v-hasPermi="['gameclub:application:approve']"
        >批量通过</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="Close"
          :disabled="multiple"
          @click="handleBatchApprove(2)"
          v-hasPermi="['gameclub:application:approve']"
        >批量拒绝</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="applicationList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="申请ID" align="center" prop="id" width="80" />
      <el-table-column label="工会" align="center" prop="guildName" width="120" />
      <el-table-column label="申请人" align="center" prop="applicantName" width="100" />
      <el-table-column label="申请理由" align="center" prop="reason" :show-overflow-tooltip="true" />
      <el-table-column label="状态" align="center" prop="status" width="100">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.status === 0" type="warning">待审批</el-tag>
          <el-tag v-else-if="scope.row.status === 1" type="success">已通过</el-tag>
          <el-tag v-else type="danger">已拒绝</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="审批人" align="center" prop="approverName" width="100" />
      <el-table-column label="审批时间" align="center" prop="approvedAt" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.approvedAt) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="申请时间" align="center" prop="createdAt" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.createdAt) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="200">
        <template slot-scope="scope">
          <el-button
            v-if="scope.row.status === 0"
            size="mini"
            type="text"
            icon="Check"
            @click="handleApprove(scope.row, 1)"
            v-hasPermi="['gameclub:application:approve']"
          >通过</el-button>
          <el-button
            v-if="scope.row.status === 0"
            size="mini"
            type="text"
            icon="Close"
            @click="handleApprove(scope.row, 2)"
            v-hasPermi="['gameclub:application:approve']"
          >拒绝</el-button>
          <el-button
            size="mini"
            type="text"
            icon="Delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['gameclub:application:remove']"
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

    <!-- 审批对话框 -->
    <el-dialog :title="approveTitle" :visible.sync="approveOpen" width="500px" append-to-body>
      <el-form ref="approveForm" :model="approveForm" label-width="80px">
        <el-form-item label="审批结果">
          <el-radio-group v-model="approveForm.status">
            <el-radio :label="1">通过</el-radio>
            <el-radio :label="2">拒绝</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="审批备注">
          <el-input
            v-model="approveForm.remark"
            type="textarea"
            placeholder="请输入审批备注"
            :rows="3"
          />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitApprove">确 定</el-button>
        <el-button @click="approveOpen = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listApplication, delApplication, approveApplication, batchApprove } from "@/api/gameclub/application";
import { listGuild } from "@/api/gameclub/guild";

export default {
  name: "GuildApplication",
  data() {
    return {
      loading: true,
      showSearch: true,
      total: 0,
      applicationList: [],
      guildOptions: [],
      ids: [],
      single: true,
      multiple: true,
      approveTitle: "",
      approveOpen: false,
      approveForm: {
        id: null,
        status: 1,
        remark: null
      },
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        guildId: null,
        applicantName: null,
        status: null
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
      listApplication(this.queryParams).then(response => {
        this.applicationList = response.rows;
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
      this.resetForm("queryForm");
      this.handleQuery();
    },
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.id);
      this.single = selection.length !== 1;
      this.multiple = !selection.length;
    },
    handleApprove(row, status) {
      this.approveForm = {
        id: row.id,
        status: status,
        remark: null
      };
      this.approveTitle = status === 1 ? "通过申请" : "拒绝申请";
      this.approveOpen = true;
    },
    handleBatchApprove(status) {
      const title = status === 1 ? "批量通过" : "批量拒绝";
      this.$modal.confirm('确认要' + title + '选中的' + this.ids.length + '条申请吗？').then(() => {
        return batchApprove(this.ids, status);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess(title + "成功");
      }).catch(() => {});
    },
    submitApprove() {
      approveApplication(this.approveForm.id, this.approveForm.status, this.approveForm.remark).then(() => {
        this.$modal.msgSuccess("审批成功");
        this.approveOpen = false;
        this.getList();
      });
    },
    handleDelete(row) {
      const id = row.id;
      this.$modal.confirm('是否确认删除申请编号为"' + id + '"的数据项？').then(function() {
        return delApplication(id);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    }
  }
};
</script>