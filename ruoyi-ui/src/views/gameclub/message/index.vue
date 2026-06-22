<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="消息类型" prop="msgType">
        <el-select v-model="queryParams.msgType" placeholder="请选择消息类型" clearable>
          <el-option :key="1" label="系统消息" :value="1" />
          <el-option :key="2" label="工会消息" :value="2" />
        </el-select>
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable>
          <el-option :key="0" label="未读" :value="0" />
          <el-option :key="1" label="已读" :value="1" />
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
          icon="el-icon-check"
          size="mini"
          @click="handleMarkAllRead"
        >全部已读</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          @click="handleDelete"
          v-hasPermi="['gameclub:message:remove']"
        >删除</el-button>
      </el-col>
      <right-toolbar @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="messageList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="消息ID" align="center" prop="id" />
      <el-table-column label="消息标题" align="center" prop="title" :show-overflow-tooltip="true" />
      <el-table-column label="消息类型" align="center" prop="msgType">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.msgType === 1" type="danger">系统消息</el-tag>
          <el-tag v-else type="warning">工会消息</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="发送者" align="center" prop="senderName" />
      <el-table-column label="工会" align="center" prop="guildName" />
      <el-table-column label="状态" align="center" prop="status">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.status === 0" type="danger">未读</el-tag>
          <el-tag v-else type="success">已读</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="发送时间" align="center" prop="createdAt" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.createdAt) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-view"
            @click="handleView(scope.row)"
          >查看</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['gameclub:message:remove']"
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

    <!-- 查看消息详情对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="600px" append-to-body>
      <el-form ref="form" :model="form" label-width="100px">
        <el-form-item label="消息标题">
          <span>{{ form.title }}</span>
        </el-form-item>
        <el-form-item label="消息类型">
          <el-tag v-if="form.msgType === 1" type="danger">系统消息</el-tag>
          <el-tag v-else type="warning">工会消息</el-tag>
        </el-form-item>
        <el-form-item label="发送者">
          <span>{{ form.senderName }}</span>
        </el-form-item>
        <el-form-item label="工会">
          <span>{{ form.guildName || '无' }}</span>
        </el-form-item>
        <el-form-item label="发送时间">
          <span>{{ parseTime(form.createdAt) }}</span>
        </el-form-item>
        <el-form-item label="消息内容">
          <div style="white-space: pre-wrap;">{{ form.content }}</div>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="cancel">关 闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getMyMessages, getGuildMessage, delGuildMessage, markAsRead, markAllAsRead } from "@/api/gameclub/message";

export default {
  name: "GuildMessage",
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
      // 工会消息表格数据
      messageList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        msgType: null,
        status: null
      },
      // 表单参数
      form: {}
    };
  },
  created() {
    this.getList();
  },
  methods: {
    /** 查询工会消息列表 */
    getList() {
      this.loading = true;
      getMyMessages(this.queryParams).then(response => {
        this.messageList = response.rows;
        this.total = response.total;
        this.loading = false;
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
        id: null,
        title: null,
        content: null,
        msgType: null,
        senderName: null,
        guildName: null,
        createdAt: null
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
    /** 查看按钮操作 */
    handleView(row) {
      this.reset();
      getGuildMessage(row.id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "消息详情";
        // 标记为已读
        if (row.status === 0) {
          markAsRead(row.id).then(() => {
            row.status = 1;
          });
        }
      });
    },
    /** 全部已读按钮操作 */
    handleMarkAllRead() {
      this.$modal.confirm('确认将所有消息标记为已读吗？').then(() => {
        return markAllAsRead();
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("操作成功");
      }).catch(() => {});
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const ids = row.id || this.ids;
      this.$modal.confirm('是否确认删除消息编号为"' + ids + '"的数据项？').then(function() {
        return delGuildMessage(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    }
  }
};
</script>
