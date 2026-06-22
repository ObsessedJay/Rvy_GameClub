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
      <el-form-item label="公告标题" prop="title">
        <el-input
          v-model="queryParams.title"
          placeholder="请输入公告标题"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="公告状态" clearable>
          <el-option label="草稿" :value="0" />
          <el-option label="已发布" :value="1" />
          <el-option label="已撤回" :value="2" />
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
          v-hasPermi="['gameclub:announcement:add']"
        >新增</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="announcementList">
      <el-table-column label="公告ID" align="center" prop="id" width="80" />
      <el-table-column label="工会" align="center" prop="guildName" width="120" />
      <el-table-column label="公告标题" align="center" prop="title" :show-overflow-tooltip="true" />
      <el-table-column label="公告类型" align="center" prop="type" width="100">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.type === 1" type="success">普通</el-tag>
          <el-tag v-else-if="scope.row.type === 2" type="warning">重要</el-tag>
          <el-tag v-else type="danger">紧急</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="状态" align="center" prop="status" width="100">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.status === 0" type="info">草稿</el-tag>
          <el-tag v-else-if="scope.row.status === 1" type="success">已发布</el-tag>
          <el-tag v-else type="danger">已撤回</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="发布人" align="center" prop="publisherName" width="100" />
      <el-table-column label="发布时间" align="center" prop="publishedAt" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.publishedAt) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="创建时间" align="center" prop="createdAt" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.createdAt) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="200">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="View"
            @click="handleView(scope.row)"
          >查看</el-button>
          <el-button
            v-if="scope.row.status === 0"
            size="mini"
            type="text"
            icon="Edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['gameclub:announcement:edit']"
          >编辑</el-button>
          <el-button
            v-if="scope.row.status === 0"
            size="mini"
            type="text"
            icon="Promotion"
            @click="handlePublish(scope.row)"
            v-hasPermi="['gameclub:announcement:publish']"
          >发布</el-button>
          <el-button
            v-if="scope.row.status === 1"
            size="mini"
            type="text"
            icon="RefreshLeft"
            @click="handleWithdraw(scope.row)"
            v-hasPermi="['gameclub:announcement:withdraw']"
          >撤回</el-button>
          <el-button
            size="mini"
            type="text"
            icon="Delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['gameclub:announcement:remove']"
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

    <!-- 添加或修改公告对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="700px" append-to-body>
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
        <el-form-item label="公告标题" prop="title">
          <el-input v-model="form.title" placeholder="请输入公告标题" maxlength="100" show-word-limit />
        </el-form-item>
        <el-form-item label="公告类型" prop="type">
          <el-radio-group v-model="form.type">
            <el-radio :label="1">普通</el-radio>
            <el-radio :label="2">重要</el-radio>
            <el-radio :label="3">紧急</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="公告内容" prop="content">
          <el-input
            v-model="form.content"
            type="textarea"
            placeholder="请输入公告内容"
            :rows="8"
            maxlength="2000"
            show-word-limit
          />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 查看公告对话框 -->
    <el-dialog title="公告详情" :visible.sync="viewOpen" width="700px" append-to-body>
      <el-descriptions :column="1" border>
        <el-descriptions-item label="工会">{{ viewData.guildName }}</el-descriptions-item>
        <el-descriptions-item label="公告标题">{{ viewData.title }}</el-descriptions-item>
        <el-descriptions-item label="公告类型">
          <el-tag v-if="viewData.type === 1" type="success">普通</el-tag>
          <el-tag v-else-if="viewData.type === 2" type="warning">重要</el-tag>
          <el-tag v-else type="danger">紧急</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="状态">
          <el-tag v-if="viewData.status === 0" type="info">草稿</el-tag>
          <el-tag v-else-if="viewData.status === 1" type="success">已发布</el-tag>
          <el-tag v-else type="danger">已撤回</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="发布人">{{ viewData.publisherName }}</el-descriptions-item>
        <el-descriptions-item label="发布时间">{{ parseTime(viewData.publishedAt) }}</el-descriptions-item>
        <el-descriptions-item label="公告内容">{{ viewData.content }}</el-descriptions-item>
      </el-descriptions>
      <div slot="footer" class="dialog-footer">
        <el-button @click="viewOpen = false">关 闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listAnnouncement, getAnnouncement, delAnnouncement, addAnnouncement, updateAnnouncement, publishAnnouncement, withdrawAnnouncement } from "@/api/gameclub/announcement";
import { listGuild } from "@/api/gameclub/guild";

export default {
  name: "GuildAnnouncement",
  data() {
    return {
      loading: true,
      showSearch: true,
      total: 0,
      announcementList: [],
      guildOptions: [],
      title: "",
      open: false,
      viewOpen: false,
      viewData: {},
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        guildId: null,
        title: null,
        status: null
      },
      form: {},
      rules: {
        guildId: [
          { required: true, message: "请选择工会", trigger: "change" }
        ],
        title: [
          { required: true, message: "公告标题不能为空", trigger: "blur" }
        ],
        type: [
          { required: true, message: "请选择公告类型", trigger: "change" }
        ],
        content: [
          { required: true, message: "公告内容不能为空", trigger: "blur" }
        ]
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
      listAnnouncement(this.queryParams).then(response => {
        this.announcementList = response.rows;
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
    reset() {
      this.form = {
        id: null,
        guildId: null,
        title: null,
        type: 1,
        content: null,
        status: 0
      };
      this.resetForm("form");
    },
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加公告";
    },
    handleUpdate(row) {
      this.reset();
      const id = row.id;
      getAnnouncement(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改公告";
      });
    },
    handleView(row) {
      this.viewData = row;
      this.viewOpen = true;
    },
    handlePublish(row) {
      this.$modal.confirm('确认要发布公告"' + row.title + '"吗？').then(function() {
        return publishAnnouncement(row.id);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("发布成功");
      }).catch(() => {});
    },
    handleWithdraw(row) {
      this.$modal.confirm('确认要撤回公告"' + row.title + '"吗？').then(function() {
        return withdrawAnnouncement(row.id);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("撤回成功");
      }).catch(() => {});
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            updateAnnouncement(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addAnnouncement(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    handleDelete(row) {
      const id = row.id;
      this.$modal.confirm('是否确认删除公告编号为"' + id + '"的数据项？').then(function() {
        return delAnnouncement(id);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    cancel() {
      this.open = false;
      this.reset();
    }
  }
};
</script>