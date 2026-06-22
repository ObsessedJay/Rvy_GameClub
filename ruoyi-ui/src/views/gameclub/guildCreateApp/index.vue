<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="default" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="游戏分区" prop="gamePartitionId">
        <el-select v-model="queryParams.gamePartitionId" placeholder="请选择" clearable>
          <el-option v-for="p in partitionOptions" :key="p.id" :label="p.gameName" :value="p.id" />
        </el-select>
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="状态" clearable>
          <el-option label="待审核" :value="0" />
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
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="list">
      <el-table-column label="ID" prop="id" width="80" />
      <el-table-column label="游戏分区" prop="gamePartitionName" width="120" />
      <el-table-column label="工会名称" prop="guildName" width="140" />
      <el-table-column label="工会简介" prop="description" show-overflow-tooltip />
      <el-table-column label="招募要求" prop="recruitRequirement" show-overflow-tooltip />
      <el-table-column label="申请人" prop="applicantName" width="100" />
      <el-table-column label="状态" width="90">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.status === 0" type="warning">待审核</el-tag>
          <el-tag v-else-if="scope.row.status === 1" type="success">已通过</el-tag>
          <el-tag v-else type="danger">已拒绝</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="审批人" prop="reviewerName" width="100" />
      <el-table-column label="申请时间" width="160">
        <template slot-scope="scope">{{ parseTime(scope.row.createdAt) }}</template>
      </el-table-column>
      <el-table-column label="操作" width="180">
        <template slot-scope="scope">
          <el-button v-if="scope.row.status === 0" size="mini" type="success"
            icon="Check" @click="handleApprove(scope.row, 1)"
            v-hasPermi="['gameclub:guildCreateApp:approve']">通过</el-button>
          <el-button v-if="scope.row.status === 0" size="mini" type="danger"
            icon="Close" @click="handleApprove(scope.row, 2)"
            v-hasPermi="['gameclub:guildCreateApp:approve']">拒绝</el-button>
          <el-button size="mini" type="text" icon="Delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['gameclub:guildCreateApp:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
  </div>
</template>

<script>
import { listGuildCreateApp, approveGuildCreateApp, delGuildCreateApp } from '@/api/gameclub/guildCreateApp'
import { publicListGamePartition } from '@/api/gameclub/partition'

export default {
  name: "GuildCreateApp",
  data() {
    return {
      loading: false, showSearch: true, total: 0, list: [],
      partitionOptions: [],
      queryParams: { pageNum: 1, pageSize: 10, gamePartitionId: null, status: null }
    }
  },
  created() {
    publicListGamePartition().then(res => { this.partitionOptions = res.data || [] })
    this.getList()
  },
  methods: {
    getList() {
      this.loading = true
      listGuildCreateApp(this.queryParams).then(res => {
        this.list = res.rows || []
        this.total = res.total || 0
      }).finally(() => { this.loading = false })
    },
    handleQuery() { this.queryParams.pageNum = 1; this.getList() },
    resetQuery() {
      this.queryParams = { pageNum: 1, pageSize: 10, gamePartitionId: null, status: null }
      this.getList()
    },
    handleApprove(row, status) {
      const title = status === 1 ? '通过' : '拒绝'
      this.$modal.confirm('确认' + title + '该创建申请吗？').then(() => {
        return approveGuildCreateApp({ id: row.id, status: status })
      }).then(() => {
        this.$modal.msgSuccess('操作成功')
        this.getList()
      }).catch(() => {})
    },
    handleDelete(row) {
      this.$modal.confirm('确认删除该申请吗？').then(() => {
        return delGuildCreateApp(row.id)
      }).then(() => {
        this.$modal.msgSuccess('删除成功')
        this.getList()
      }).catch(() => {})
    },
    parseTime(time) {
      if (!time) return ''
      return new Date(time).toLocaleString('zh-CN')
    }
  }
}
</script>
