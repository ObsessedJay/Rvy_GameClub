<template>
  <div class="dashboard-container">
    <!-- 统计卡片 -->
    <el-row :gutter="20" class="mb20">
      <el-col :xs="24" :sm="12" :lg="6">
        <div class="card-panel">
          <div class="card-panel-icon-wrapper icon-game">
            <i class="el-icon-trophy card-panel-icon"></i>
          </div>
          <div class="card-panel-description">
            <div class="card-panel-text">游戏分区</div>
            <count-to :start-val="0" :end-val="stats.partitionCount" :duration="2600" class="card-panel-num" />
          </div>
        </div>
      </el-col>
      <el-col :xs="24" :sm="12" :lg="6">
        <div class="card-panel">
          <div class="card-panel-icon-wrapper icon-guild">
            <i class="el-icon-s-custom card-panel-icon"></i>
          </div>
          <div class="card-panel-description">
            <div class="card-panel-text">工会总数</div>
            <count-to :start-val="0" :end-val="stats.guildCount" :duration="2600" class="card-panel-num" />
          </div>
        </div>
      </el-col>
      <el-col :xs="24" :sm="12" :lg="6">
        <div class="card-panel">
          <div class="card-panel-icon-wrapper icon-member">
            <i class="el-icon-user card-panel-icon"></i>
          </div>
          <div class="card-panel-description">
            <div class="card-panel-text">成员总数</div>
            <count-to :start-val="0" :end-val="stats.memberCount" :duration="2600" class="card-panel-num" />
          </div>
        </div>
      </el-col>
      <el-col :xs="24" :sm="12" :lg="6">
        <div class="card-panel">
          <div class="card-panel-icon-wrapper icon-pending">
            <i class="el-icon-message-solid card-panel-icon"></i>
          </div>
          <div class="card-panel-description">
            <div class="card-panel-text">待审批申请</div>
            <count-to :start-val="0" :end-val="stats.pendingApplicationCount" :duration="2600" class="card-panel-num" />
          </div>
        </div>
      </el-col>
    </el-row>

    <el-row :gutter="20">
      <!-- 游戏分区列表 -->
      <el-col :xs="24" :sm="24" :lg="12">
        <el-card shadow="hover" class="mb20">
          <div slot="header" class="clearfix">
            <span class="card-header-title">游戏分区</span>
            <el-button style="float: right; padding: 3px 0" type="text" @click="goToPartition">更多</el-button>
          </div>
          <el-table :data="partitionList" style="width: 100%" v-loading="partitionLoading">
            <el-table-column prop="gameName" label="游戏名称" width="120" />
            <el-table-column prop="gameCode" label="游戏编码" width="100" />
            <el-table-column prop="guildCount" label="工会数" width="80" align="center" />
            <el-table-column prop="memberCount" label="成员数" width="80" align="center" />
            <el-table-column prop="status" label="状态" width="80" align="center">
              <template slot-scope="scope">
                <el-tag :type="scope.row.status === 1 ? 'success' : 'info'" size="small">
                  {{ scope.row.status === 1 ? '启用' : '禁用' }}
                </el-tag>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>

      <!-- 最新工会 -->
      <el-col :xs="24" :sm="24" :lg="12">
        <el-card shadow="hover" class="mb20">
          <div slot="header" class="clearfix">
            <span class="card-header-title">最新工会</span>
            <el-button style="float: right; padding: 3px 0" type="text" @click="goToGuild">更多</el-button>
          </div>
          <el-table :data="guildList" style="width: 100%" v-loading="guildLoading">
            <el-table-column prop="name" label="工会名称" width="150" :show-overflow-tooltip="true" />
            <el-table-column prop="partitionName" label="所属分区" width="100" />
            <el-table-column prop="memberCount" label="成员数" width="80" align="center" />
            <el-table-column prop="presidentName" label="会长" width="100" />
            <el-table-column prop="createdAt" label="创建时间" width="110">
              <template slot-scope="scope">
                <span>{{ parseTime(scope.row.createdAt, '{y}-{m}-{d}') }}</span>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20">
      <!-- 待审批申请 -->
      <el-col :xs="24" :sm="24" :lg="12">
        <el-card shadow="hover" class="mb20">
          <div slot="header" class="clearfix">
            <span class="card-header-title">待审批申请</span>
            <el-button style="float: right; padding: 3px 0" type="text" @click="goToApplication">更多</el-button>
          </div>
          <el-table :data="applicationList" style="width: 100%" v-loading="applicationLoading">
            <el-table-column prop="applicantName" label="申请人" width="100" />
            <el-table-column prop="guildName" label="申请工会" width="120" :show-overflow-tooltip="true" />
            <el-table-column prop="reason" label="申请理由" :show-overflow-tooltip="true" />
            <el-table-column prop="createdAt" label="申请时间" width="110">
              <template slot-scope="scope">
                <span>{{ parseTime(scope.row.createdAt, '{y}-{m}-{d}') }}</span>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="100" align="center">
              <template slot-scope="scope">
                <el-button size="mini" type="text" @click="handleApprove(scope.row, 1)">通过</el-button>
                <el-button size="mini" type="text" @click="handleApprove(scope.row, 2)">拒绝</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>

      <!-- 最新公告 -->
      <el-col :xs="24" :sm="24" :lg="12">
        <el-card shadow="hover" class="mb20">
          <div slot="header" class="clearfix">
            <span class="card-header-title">最新公告</span>
            <el-button style="float: right; padding: 3px 0" type="text" @click="goToAnnouncement">更多</el-button>
          </div>
          <el-table :data="announcementList" style="width: 100%" v-loading="announcementLoading">
            <el-table-column prop="guildName" label="工会" width="100" />
            <el-table-column prop="title" label="公告标题" :show-overflow-tooltip="true" />
            <el-table-column prop="type" label="类型" width="70" align="center">
              <template slot-scope="scope">
                <el-tag :type="getAnnouncementTypeTag(scope.row.type)" size="small">
                  {{ getAnnouncementTypeText(scope.row.type) }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="publishedAt" label="发布时间" width="110">
              <template slot-scope="scope">
                <span>{{ parseTime(scope.row.publishedAt, '{y}-{m}-{d}') }}</span>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import { listPartition } from "@/api/gameclub/partition";
import { listGuild } from "@/api/gameclub/guild";
import { listMember } from "@/api/gameclub/member";
import { listApplication, approveApplication } from "@/api/gameclub/application";
import { listAnnouncement } from "@/api/gameclub/announcement";
import { registerToWebsite } from "@/api/system/userDept";
import CountTo from 'vue-count-to';

export default {
  name: "GameClubDashboard",
  components: {
    CountTo
  },
  data() {
    return {
      stats: {
        partitionCount: 0,
        guildCount: 0,
        memberCount: 0,
        pendingApplicationCount: 0
      },
      partitionList: [],
      guildList: [],
      applicationList: [],
      announcementList: [],
      partitionLoading: false,
      guildLoading: false,
      applicationLoading: false,
      announcementLoading: false
    };
  },
  created() {
    // 首次访问GameClub时自动注册到"无工会用户"部门
    this.registerToGameClub();
    this.loadStats();
    this.loadPartitionList();
    this.loadGuildList();
    this.loadApplicationList();
    this.loadAnnouncementList();
  },
  methods: {
    // 注册用户到GameClub网站（首次访问时自动归类到"无工会用户"）
    registerToGameClub() {
      registerToWebsite('GAMECLUB').then(response => {
        // 注册成功，用户已归类到无工会用户部门(dept_id=205)
        console.log('GameClub注册成功:', response.data);
      }).catch(error => {
        // 注册失败不影响页面正常显示
        console.log('GameClub注册:', error);
      });
    },
    loadStats() {
      // 加载统计数据
      listPartition({ status: 1 }).then(response => {
        this.stats.partitionCount = response.total;
      });
      listGuild({}).then(response => {
        this.stats.guildCount = response.total;
      });
      listMember({}).then(response => {
        this.stats.memberCount = response.total;
      });
      listApplication({ status: 0 }).then(response => {
        this.stats.pendingApplicationCount = response.total;
      });
    },
    loadPartitionList() {
      this.partitionLoading = true;
      listPartition({ status: 1, pageNum: 1, pageSize: 5 }).then(response => {
        this.partitionList = response.rows;
        this.partitionLoading = false;
      });
    },
    loadGuildList() {
      this.guildLoading = true;
      listGuild({ pageNum: 1, pageSize: 5 }).then(response => {
        this.guildList = response.rows;
        this.guildLoading = false;
      });
    },
    loadApplicationList() {
      this.applicationLoading = true;
      listApplication({ status: 0, pageNum: 1, pageSize: 5 }).then(response => {
        this.applicationList = response.rows;
        this.applicationLoading = false;
      });
    },
    loadAnnouncementList() {
      this.announcementLoading = true;
      listAnnouncement({ status: 1, pageNum: 1, pageSize: 5 }).then(response => {
        this.announcementList = response.rows;
        this.announcementLoading = false;
      });
    },
    handleApprove(row, status) {
      const title = status === 1 ? "通过申请" : "拒绝申请";
      this.$modal.confirm('确认要' + title + '吗？').then(() => {
        return approveApplication(row.id, status);
      }).then(() => {
        this.loadApplicationList();
        this.loadStats();
        this.$modal.msgSuccess("审批成功");
      }).catch(() => {});
    },
    getAnnouncementTypeTag(type) {
      const map = {
        1: 'success',
        2: 'warning',
        3: 'danger'
      };
      return map[type] || 'info';
    },
    getAnnouncementTypeText(type) {
      const map = {
        1: '普通',
        2: '重要',
        3: '紧急'
      };
      return map[type] || '未知';
    },
    goToPartition() {
      this.$router.push('/gameclub/partition');
    },
    goToGuild() {
      this.$router.push('/gameclub/guild');
    },
    goToApplication() {
      this.$router.push('/gameclub/application');
    },
    goToAnnouncement() {
      this.$router.push('/gameclub/announcement');
    }
  }
};
</script>

<style scoped>
.dashboard-container {
  padding: 20px;
}

.mb20 {
  margin-bottom: 20px;
}

.card-panel {
  height: 108px;
  cursor: pointer;
  font-size: 12px;
  position: relative;
  overflow: hidden;
  color: #666;
  background: #fff;
  box-shadow: 4px 4px 40px rgba(0, 0, 0, .05);
  border-color: rgba(0, 0, 0, .05);
}

.card-panel:hover {
  box-shadow: 4px 4px 40px rgba(0, 0, 0, .15);
}

.card-panel-icon-wrapper {
  float: left;
  margin: 14px 0 0 14px;
  padding: 16px;
  transition: all 0.38s ease-out;
  border-radius: 6px;
}

.card-panel-icon-wrapper.icon-game {
  background: #40c9c6;
}

.card-panel-icon-wrapper.icon-guild {
  background: #36a3f7;
}

.card-panel-icon-wrapper.icon-member {
  background: #f4516c;
}

.card-panel-icon-wrapper.icon-pending {
  background: #34bfa3;
}

.card-panel-icon {
  float: left;
  font-size: 48px;
  color: #fff;
}

.card-panel-description {
  float: right;
  font-weight: bold;
  margin: 26px;
  margin-left: 0px;
}

.card-panel-text {
  line-height: 18px;
  color: rgba(0, 0, 0, 0.45);
  font-size: 16px;
  margin-bottom: 12px;
}

.card-panel-num {
  font-size: 20px;
}

.card-header-title {
  font-size: 16px;
  font-weight: bold;
}
</style>