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
      <el-form-item label="成员名称" prop="memberName">
        <el-input
          v-model="queryParams.memberName"
          placeholder="请输入成员名称"
          clearable
          @keyup.enter.native="handleQuery"
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
          type="primary"
          plain
          icon="Plus"
          @click="handleAdd"
          v-hasPermi="['gameclub:blacklist:add']"
        >新增</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="blacklistList">
      <el-table-column label="ID" align="center" prop="id" width="80" />
      <el-table-column label="工会" align="center" prop="guildName" width="120" />
      <el-table-column label="成员名称" align="center" prop="memberName" width="120" />
      <el-table-column label="拉黑原因" align="center" prop="reason" :show-overflow-tooltip="true" />
      <el-table-column label="操作人" align="center" prop="operatorName" width="100" />
      <el-table-column label="拉黑时间" align="center" prop="createdAt" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.createdAt) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="150">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="Unlock"
            @click="handleRemove(scope.row)"
            v-hasPermi="['gameclub:blacklist:remove']"
          >解除</el-button>
          <el-button
            size="mini"
            type="text"
            icon="Delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['gameclub:blacklist:delete']"
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

    <!-- 添加黑名单对话框 -->
    <el-dialog title="添加黑名单" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="工会" prop="guildId">
          <el-select v-model="form.guildId" placeholder="请选择工会" filterable>
            <el-option
              v-for="item in guildOptions"
              :key="item.id"
              :label="item.name"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="成员" prop="memberId">
          <el-select v-model="form.memberId" placeholder="请选择成员" filterable>
            <el-option
              v-for="item in memberOptions"
              :key="item.id"
              :label="item.name"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="拉黑原因" prop="reason">
          <el-input
            v-model="form.reason"
            type="textarea"
            placeholder="请输入拉黑原因"
            :rows="3"
            maxlength="500"
            show-word-limit
          />
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
import { listBlacklist, getBlacklist, delBlacklist, addBlacklist, removeBlacklist } from "@/api/gameclub/blacklist";
import { listGuild } from "@/api/gameclub/guild";
import { listMember } from "@/api/gameclub/member";

export default {
  name: "GuildBlacklist",
  data() {
    return {
      loading: true,
      showSearch: true,
      total: 0,
      blacklistList: [],
      guildOptions: [],
      memberOptions: [],
      open: false,
      form: {},
      rules: {
        guildId: [
          { required: true, message: "请选择工会", trigger: "change" }
        ],
        memberId: [
          { required: true, message: "请选择成员", trigger: "change" }
        ],
        reason: [
          { required: true, message: "拉黑原因不能为空", trigger: "blur" }
        ]
      },
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        guildId: null,
        memberName: null
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
      listBlacklist(this.queryParams).then(response => {
        this.blacklistList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    getGuildOptions() {
      listGuild({}).then(response => {
        this.guildOptions = response.rows;
      });
    },
    getMemberOptions(guildId) {
      if (!guildId) {
        this.memberOptions = [];
        return;
      }
      listMember({ guildId: guildId }).then(response => {
        this.memberOptions = response.rows;
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
    reset() {
      this.form = {
        guildId: null,
        memberId: null,
        reason: null
      };
      this.memberOptions = [];
      this.resetForm("form");
    },
    handleAdd() {
      this.reset();
      this.open = true;
    },
    handleRemove(row) {
      this.$modal.confirm('确认要解除"' + row.memberName + '"的黑名单吗？').then(function() {
        return removeBlacklist(row.id);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("解除成功");
      }).catch(() => {});
    },
    handleDelete(row) {
      const id = row.id;
      this.$modal.confirm('是否确认删除黑名单记录"' + id + '"？').then(function() {
        return delBlacklist(id);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          addBlacklist(this.form).then(response => {
            this.$modal.msgSuccess("添加成功");
            this.open = false;
            this.getList();
          });
        }
      });
    },
    cancel() {
      this.open = false;
      this.reset();
    }
  },
  watch: {
    'form.guildId'(val) {
      this.getMemberOptions(val);
    }
  }
};
</script>