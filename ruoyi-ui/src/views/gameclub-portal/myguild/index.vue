<template>
  <div class="myguild-page">
    <!-- 工会头部 -->
    <div class="guild-header" v-if="guildInfo">
      <div class="header-left">
        <div class="guild-avatar">{{ guildAvatar }}</div>
        <div class="guild-meta">
          <h1 class="guild-name">{{ guildInfo.name }}</h1>
          <span class="guild-partition">{{ guildInfo.partitionName || '' }}</span>
        </div>
        <el-tag class="my-role-tag" :type="roleTagType">{{ roleText }}</el-tag>
      </div>
      <div class="header-right">
        <span class="member-count">成员 {{ members.length }} 人</span>
      </div>
    </div>

    <div class="guild-body">
      <div class="guild-main">
        <el-tabs v-model="activeTab" class="guild-tabs">
          <el-tab-pane label="工会聊天" name="chat">
            <div class="chat-area">
              <div class="chat-messages" ref="chatMessages">
                <div v-if="chatMessages.length === 0" class="chat-empty">
                  <span class="placeholder-icon">💬</span>
                  <p>暂无消息，来打个招呼吧</p>
                </div>
                <div v-for="msg in chatMessages" :key="msg.id" class="chat-msg" :class="{ mine: isMyMsg(msg), ai: msg.type === 2 }">
                  <div class="chat-msg-avatar">{{ msg.type === 2 ? '🤖' : '👤' }}</div>
                  <div class="chat-msg-body">
                    <div class="chat-msg-header">
                      <span class="chat-msg-name">{{ msg.senderName }}</span>
                      <span class="chat-msg-time">{{ parseChatTime(msg.createdAt) }}</span>
                    </div>
                    <div class="chat-msg-content">{{ msg.content }}</div>
                  </div>
                </div>
              </div>
              <div class="chat-input-bar">
                <el-input v-model="chatInput" placeholder="输入消息...（/ai 开头可与AI助手对话）" @keyup.enter.native="sendChat" :disabled="!chatConnected">
                  <el-button slot="append" icon="el-icon-s-promotion" @click="sendChat" :disabled="!chatConnected"></el-button>
                </el-input>
                <span v-if="!chatConnected" class="chat-status">正在连接...</span>
              </div>
            </div>
          </el-tab-pane>

          <!-- 工会任务 -->
          <el-tab-pane label="工会任务" name="tasks">
            <div class="tasks-area">
              <div class="tasks-toolbar" v-if="canManageTask">
                <el-button type="primary" size="small" icon="el-icon-plus" @click="handleAddTask">新建任务</el-button>
              </div>
              <el-tabs v-model="taskTab" type="card" class="task-subtabs">
                <el-tab-pane label="可接取" name="available">
                  <div class="task-list" v-if="availableTasks.length > 0">
                    <div class="task-card" v-for="task in availableTasks" :key="task.id">
                      <div class="task-header">
                        <span class="task-title">{{ task.name }}</span>
                        <el-tag size="mini" type="success">可接取</el-tag>
                        <el-button size="mini" type="text" @click="showParticipants(task)">👥 {{ task.currentPlayers || 0 }}/{{ task.maxPlayers || 0 }}</el-button>
                      </div>
                      <p class="task-desc">{{ task.description || '暂无描述' }}</p>
                      <div class="task-meta">
                        <span> 截止: {{ task.joinDeadline ? parseTime(task.joinDeadline) : '未设' }}</span>
                        <span>⏰ 时限: {{ task.endTime ? parseTime(task.endTime) : '未设' }}</span>
                      </div>
                      <div class="task-actions">
                        <el-button size="mini" type="primary" @click="handleJoinTask(task)">接取</el-button>
                        <el-button v-if="canManageTask" size="mini" @click="handleEditTask(task)">编辑</el-button>
                        <el-button v-if="canManageTask" size="mini" type="danger" @click="handleDelTask(task)">删除</el-button>
                      </div>
                    </div>
                  </div>
                  <div class="empty-placeholder" v-else><span>📋</span><p>暂无可用任务</p></div>
                </el-tab-pane>

                <el-tab-pane label="进行中" name="active">
                  <div class="task-list" v-if="activeTasks.length > 0">
                    <div class="task-card" v-for="task in activeTasks" :key="task.id">
                      <div class="task-header">
                        <span class="task-title">{{ task.name }}</span>
                        <el-tag size="mini" type="warning">进行中</el-tag>
                        <el-button size="mini" type="text" @click="showParticipants(task)">👥 {{ task.currentPlayers || 0 }}/{{ task.maxPlayers || 0 }}</el-button>
                      </div>
                      <p class="task-desc">{{ task.description || '' }}</p>
                      <div class="task-meta">
                        <span>⏰ 截止: {{ task.endTime ? parseTime(task.endTime) : '未设' }}</span>
                      </div>
                      <div class="task-actions">
                        <el-button size="mini" type="warning" @click="handleCancelTask(task)">取消接取</el-button>
                      </div>
                    </div>
                  </div>
                  <div class="empty-placeholder" v-else><span>🔄</span><p>暂无进行中</p></div>
                </el-tab-pane>

                <el-tab-pane label="已完成" name="completed">
                  <div class="task-list" v-if="completedTasks.length > 0">
                    <div class="task-card completed" v-for="task in completedTasks" :key="task.id">
                      <div class="task-header">
                        <span class="task-title">{{ task.name }}</span>
                        <el-tag size="mini" type="info">已完成</el-tag>
                        <el-button size="mini" type="text" @click="showParticipants(task)">👥 查看</el-button>
                      </div>
                      <p class="task-desc">{{ task.description || '' }}</p>
                    </div>
                  </div>
                  <div class="empty-placeholder" v-else><span>✅</span><p>暂无已完成</p></div>
                </el-tab-pane>

                <el-tab-pane label="已过期" name="expired">
                  <div class="task-list" v-if="expiredTasks.length > 0">
                    <div class="task-card expired" v-for="task in expiredTasks" :key="task.id">
                      <div class="task-header">
                        <span class="task-title">{{ task.name }}</span>
                        <el-tag size="mini" type="danger">已过期</el-tag>
                        <el-button size="mini" type="text" @click="showParticipants(task)">👥 查看</el-button>
                      </div>
                      <p class="task-desc">{{ task.description || '' }}</p>
                      <p class="expired-reason" v-if="task.currentPlayers < (task.minPlayers||1)">原因：接取人数不足（{{task.currentPlayers}}/{{task.minPlayers}}）</p>
                      <p class="expired-reason" v-else-if="task.endTime">原因：超过完成时限</p>
                    </div>
                  </div>
                  <div class="empty-placeholder" v-else><span>⏰</span><p>暂无过期</p></div>
                </el-tab-pane>
              </el-tabs>
            </div>
          </el-tab-pane>

          <!-- 我的任务 -->
          <el-tab-pane label="我的任务" name="myTasks">
            <div class="tasks-area">
              <div v-if="myTasks.length > 0" class="task-list">
                <div class="task-card" v-for="task in myTasks" :key="task.id">
                  <div class="task-header">
                    <span class="task-title">{{ task.name }}</span>
                    <el-tag size="mini" :type="getMyTaskStatusTag(task)">{{ getMyTaskStatusText(task) }}</el-tag>
                  </div>
                  <p class="task-desc">{{ task.description || '' }}</p>
                  <div class="task-meta">
                    <span>📅 截止: {{ task.joinDeadline ? parseTime(task.joinDeadline) : '-' }}</span>
                    <span>⏰ 时限: {{ task.endTime ? parseTime(task.endTime) : '-' }}</span>
                    <span>👥 {{ task.currentPlayers || 0 }}/{{ task.maxPlayers || 0 }}</span>
                  </div>
                  <div class="task-actions" v-if="task.status === 2">
                    <el-button v-if="myTaskParticipantStatus(task) === 1" size="mini" type="success" @click="handleMarkComplete(task)">标记完成</el-button>
                    <el-button v-if="myTaskParticipantStatus(task) === 3" size="mini" type="info" @click="handleMarkIncomplete(task)">取消完成</el-button>
                  </div>
                </div>
              </div>
              <div class="empty-placeholder" v-else><span>📭</span><p>你还没有接取任何任务</p></div>
            </div>
          </el-tab-pane>

          <!-- 待审核 -->
          <el-tab-pane label="待审核" name="applications" v-if="canManageTask">
            <div class="applications-area">
              <div v-if="pendingApplications.length > 0" class="application-list">
                <div class="application-card" v-for="app in pendingApplications" :key="app.id">
                  <div class="app-header">
                    <span class="app-applicant">👤 {{ app.applicantName || '未知用户' }}</span>
                    <span class="app-time">{{ parseTime(app.createdAt) }}</span>
                  </div>
                  <p class="app-reason">{{ app.reason || app.message || '无申请理由' }}</p>
                  <div class="app-actions">
                    <el-button size="mini" type="success" @click="handleApprove(app.id, 1)">通过</el-button>
                    <el-button size="mini" type="danger" @click="handleApprove(app.id, 2)">拒绝</el-button>
                  </div>
                </div>
              </div>
              <div class="empty-placeholder" v-else><span>📭</span><p>暂无待审核申请</p></div>
            </div>
          </el-tab-pane>

          <!-- 管理工会 -->
          <el-tab-pane label="管理工会" name="manage" v-if="canManageTask">
            <div class="manage-area">
              <div class="manage-member-list">
                <div class="manage-member-item" v-for="member in members" :key="member.id">
                  <div class="mm-info">
                    <span class="mm-avatar">👤</span>
                    <span class="mm-name">{{ member.nickName || member.userName || '未知' }}</span>
                    <span class="mm-role">
                      <el-tag v-if="member.role === 1" size="mini" type="danger">会长</el-tag>
                      <el-tag v-else-if="member.role === 2" size="mini" type="warning">管理员</el-tag>
                      <el-tag v-else size="mini" type="info">成员</el-tag>
                    </span>
                  </div>
                  <div class="mm-actions">
                    <el-button v-if="myRole === 1 && member.role === 3" size="mini" type="warning" @click="handlePromote(member)">提拔</el-button>
                    <el-button v-if="myRole === 1 && member.role === 2" size="mini" type="info" @click="handleDemote(member)">降级</el-button>
                    <el-button v-if="canKick(member)" size="mini" type="danger" @click="handleKick(member)">踢出</el-button>
                  </div>
                </div>
              </div>
            </div>
          </el-tab-pane>
        </el-tabs>
      </div>

      <!-- 右侧：成员列表 -->
      <div class="guild-sidebar">
        <div class="sidebar-header"><h3>工会成员 ({{ members.length }})</h3></div>
        <div class="member-list">
          <div class="member-item" v-for="member in members" :key="member.id">
            <div class="member-avatar">
              <span class="avatar-icon">👤</span>
              <span class="online-dot" :class="member.online ? 'online' : 'offline'"></span>
            </div>
            <div class="member-info">
              <span class="member-name">{{ member.nickName || member.userName || '未知' }}</span>
              <span class="member-role-tag">
                <el-tag v-if="member.role === 1" size="mini" type="danger">会长</el-tag>
                <el-tag v-else-if="member.role === 2" size="mini" type="warning">管理员</el-tag>
                <el-tag v-else size="mini" type="info">成员</el-tag>
              </span>
            </div>
          </div>
          <div v-if="members.length === 0" class="empty-members"><span>暂无成员</span></div>
        </div>
      </div>
    </div>

    <!-- 参与者弹窗 -->
    <el-dialog title="任务参与者" :visible.sync="participantDialogVisible" width="400px">
      <div class="participant-list" v-if="participants.length > 0">
        <div class="participant-item" v-for="p in participants" :key="p.id">
          <span class="p-avatar">👤</span>
          <span class="p-name">{{ p.nickName || p.userName || '未知' }}</span>
          <el-tag size="mini" :type="p.status === 3 ? 'success' : 'info'">{{ p.status === 3 ? '已完成' : p.status === 1 ? '已接取' : '已准备' }}</el-tag>
        </div>
      </div>
      <div v-else class="empty-placeholder"><span>📭</span><p>暂无参与者</p></div>
    </el-dialog>

    <!-- 任务创建/编辑对话框 -->
    <el-dialog :title="taskDialogTitle" :visible.sync="taskDialogVisible" width="550px">
      <el-form ref="taskForm" :model="taskForm" :rules="taskRules" label-width="110px">
        <el-form-item label="任务名称" prop="name">
          <el-input v-model="taskForm.name" placeholder="请输入任务名称" />
        </el-form-item>
        <el-form-item label="任务类型" prop="type">
          <el-select v-model="taskForm.type" placeholder="请选择">
            <el-option :value="1" label="日常" />
            <el-option :value="2" label="周常" />
            <el-option :value="3" label="活动" />
          </el-select>
        </el-form-item>
        <el-form-item label="任务描述" prop="description">
          <el-input v-model="taskForm.description" type="textarea" :rows="3" placeholder="请输入任务描述" />
        </el-form-item>
        <el-form-item label="最少人数" prop="minPlayers">
          <el-input-number v-model="taskForm.minPlayers" :min="1" :max="99" />
        </el-form-item>
        <el-form-item label="最大人数" prop="maxPlayers">
          <el-input-number v-model="taskForm.maxPlayers" :min="1" :max="99" />
        </el-form-item>
        <el-form-item label="接取截止时间" prop="joinDeadline">
          <el-date-picker v-model="taskForm.joinDeadline" type="datetime" placeholder="必须晚于当前时间"
            value-format="yyyy-MM-dd HH:mm:ss"
            :picker-options="{ disabledDate: time => time.getTime() < Date.now() - 86400000 }" />
        </el-form-item>
        <el-form-item label="任务完成时限" prop="endTime">
          <el-date-picker v-model="taskForm.endTime" type="datetime" placeholder="必须晚于接取截止时间"
            value-format="yyyy-MM-dd HH:mm:ss"
            :picker-options="{ disabledDate: time => taskForm.joinDeadline ? time.getTime() < new Date(taskForm.joinDeadline).getTime() : time.getTime() < Date.now() }" />
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="taskDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitTaskForm">确定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getMyRole, getMyGuilds, listMemberGuildMember, delMemberByGuild, changeMemberRoleByGuild } from '@/api/gameclub/member'
import { getGuild } from '@/api/gameclub/guild'
import { listMemberTask, addMemberTask, updateMemberTask, delMemberTask, joinTask, cancelTask, completeMemberTask, incompleteMemberTask, getTaskParticipants, listMyTasks, getChatHistory } from '@/api/gameclub/task'
import { listMemberApplication, approveMemberApplication } from '@/api/gameclub/application'
import { connectChat, sendChatMessage, disconnectChat, startChat, stopChat } from '@/utils/chat'

export default {
  name: "MyGuild",
  data() {
    const validateJoinDeadline = (rule, value, cb) => {
      if (!value) cb(new Error('请选择接取截止时间'))
      else if (new Date(value).getTime() <= Date.now()) cb(new Error('接取截止时间必须晚于当前时间'))
      else cb()
    }
    const validateEndTime = (rule, value, cb) => {
      if (!value) cb(new Error('请选择任务完成时限'))
      else if (this.taskForm.joinDeadline && new Date(value).getTime() <= new Date(this.taskForm.joinDeadline).getTime())
        cb(new Error('完成时限必须晚于接取截止时间'))
      else cb()
    }
    return {
      guildInfo: null, members: [], tasks: [], myTasks: [], myTaskParticipants: {},
      applications: [], participants: [], participantDialogVisible: false,
      activeTab: 'chat', taskTab: 'available', myRole: null, guildId: null, myUserId: null,
      taskDialogVisible: false, taskDialogTitle: '', taskForm: {},
      // 聊天
      chatMessages: [], chatInput: '', chatConnected: false, chatSending: false,
      taskRules: {
        name: [{ required: true, message: '请输入任务名称', trigger: 'blur' }],
        joinDeadline: [{ required: true, validator: validateJoinDeadline, trigger: 'change' }],
        endTime: [{ required: true, validator: validateEndTime, trigger: 'change' }]
      }
    }
  },
  computed: {
    guildAvatar() {
      if (!this.guildInfo) return ''
      const name = this.guildInfo.name || ''
      const avatars = ['�', '⚔️', '🛡️', '⭐', '🔥', '💎']
      let hash = 0; for (let i = 0; i < name.length; i++) hash = name.charCodeAt(i) + ((hash << 5) - hash)
      return avatars[Math.abs(hash) % avatars.length]
    },
    roleText() { const m = { 1: '会长', 2: '管理员', 3: '普通成员' }; return m[this.myRole] || '成员' },
    roleTagType() { const m = { 1: 'danger', 2: 'warning', 3: '' }; return m[this.myRole] || '' },
    canManageTask() { return this.myRole === 1 || this.myRole === 2 },
    pendingApplications() { return this.applications.filter(a => a.status === 0) },
    availableTasks() { return this.tasks.filter(t => t.status === 1) },
    activeTasks() { return this.tasks.filter(t => t.status === 2) },
    completedTasks() { return this.tasks.filter(t => t.status === 3) },
    expiredTasks() { return this.tasks.filter(t => t.status === 4) }
  },
  watch: {
    activeTab(val) {
      if (val === 'chat' && this.guildId) {
        this.initChat()
      } else {
        stopChat()
        this.chatConnected = false
      }
    },
    guildId(val) {
      if (val && this.activeTab === 'chat') {
        this.initChat()
      }
    }
  },
  created() { this.loadMyGuild() },
  beforeDestroy() { stopChat() },
  methods: {
    loadMyGuild() {
      // 支持从路由参数指定 guildId（多工会选择场景）
      const routeGuildId = this.$route.query.guildId
      if (routeGuildId) {
        this.guildId = parseInt(routeGuildId)
        getGuild(this.guildId).then(gRes => { this.guildInfo = gRes.data || {} })
        // 从用户所有工会中查找当前工会的真实角色
        getMyGuilds().then(res => {
          const guilds = res.data || []
          const current = guilds.find(g => g.guildId === this.guildId)
          this.myRole = current ? current.role : 3
          this.myUserId = current ? current.userId : null
          this.loadMembers(); this.loadTasks(); this.loadMyTasks()
          if (this.canManageTask) this.loadApplications()
        }).catch(() => {
          this.loadMembers(); this.loadTasks(); this.loadMyTasks()
        })
        return
      }

      getMyRole().then(res => {
        const data = res.data
        this.myRole = data.role; this.guildId = data.guildId
        if (!data.guildId) { this.$message.warning('您暂未加入任何工会'); this.$router.push('/gameclub-portal'); return }
        getGuild(data.guildId).then(gRes => { this.guildInfo = gRes.data || {} })
        // 同时获取 userId
        getMyGuilds().then(gRes => {
          const guilds = gRes.data || []
          const current = guilds.find(g => g.guildId === this.guildId)
          this.myUserId = current ? current.userId : (this.$store.state.user?.id || null)
        }).catch(() => {
          this.myUserId = this.$store.state.user?.id || null
        })
        this.loadMembers(); this.loadTasks(); this.loadMyTasks()
        if (this.canManageTask) this.loadApplications()
      }).catch(() => { this.$message.error('获取工会信息失败') })
    },
    loadMembers() {
      if (!this.guildId) return
      listMemberGuildMember({ guildId: this.guildId, status: 1 }).then(mRes => {
        this.members = (mRes.rows || []).map(m => ({ ...m, online: false }))
      })
    },
    loadTasks() {
      if (!this.guildId) return
      listMemberTask({ guildId: this.guildId }).then(tRes => { this.tasks = tRes.rows || [] }).catch(() => {})
    },
    loadMyTasks() {
      if (!this.guildId) return
      listMyTasks({ guildId: this.guildId }).then(res => {
        this.myTasks = res.rows || []
        // 获取每个任务的参与者状态
        this.myTaskParticipants = {}
        const promises = this.myTasks.map(task =>
          getTaskParticipants(task.id).then(pRes => {
            const myP = (pRes.data || []).find(p => p.userId === this.$store?.state?.user?.userId)
            if (myP) this.myTaskParticipants[task.id] = myP
          }).catch(() => {})
        )
        Promise.all(promises)
      }).catch(() => {})
    },
    loadApplications() {
      if (!this.guildId) return
      listMemberApplication({ guildId: this.guildId, status: 0 }).then(res => { this.applications = res.rows || [] })
    },
    canKick(member) {
      if (this.myRole === 1) return member.role === 2 || member.role === 3
      if (this.myRole === 2) return member.role === 3
      return false
    },

    // 参与者弹窗
    showParticipants(task) {
      this.participants = []
      this.participantDialogVisible = true
      getTaskParticipants(task.id).then(res => { this.participants = res.data || [] }).catch(() => {})
    },

    // 任务操作
    handleJoinTask(task) {
      this.$confirm('确认接取任务「' + task.name + '」？').then(() => {
        return joinTask(task.id)
      }).then(() => {
        this.$message.success('接取成功')
        this.loadTasks(); this.loadMyTasks()
      }).catch(() => {})
    },
    handleCancelTask(task) {
      this.$confirm('确认取消接取任务「' + task.name + '」？').then(() => {
        return cancelTask(task.id)
      }).then(() => {
        this.$message.success('已取消接取')
        this.loadTasks(); this.loadMyTasks()
      }).catch(() => {})
    },
    handleMarkComplete(task) {
      this.$confirm('确认标记任务「' + task.name + '」为已完成？').then(() => {
        return completeMemberTask(task.id)
      }).then(() => {
        this.$message.success('已标记完成')
        this.loadTasks(); this.loadMyTasks()
      }).catch(() => {})
    },
    handleMarkIncomplete(task) {
      this.$confirm('确认重置任务「' + task.name + '」为未完成？').then(() => {
        return incompleteMemberTask(task.id)
      }).then(() => {
        this.$message.success('已重置')
        this.loadTasks(); this.loadMyTasks()
      }).catch(() => {})
    },

    // 管理任务
    handleAddTask() {
      this.taskForm = { guildId: this.guildId, type: 1, minPlayers: 1, maxPlayers: 3 }
      this.taskDialogTitle = '新建任务'
      this.taskDialogVisible = true
    },
    handleEditTask(task) {
      this.taskForm = { ...task }
      this.taskDialogTitle = '编辑任务'
      this.taskDialogVisible = true
    },
    handleDelTask(task) {
      this.$confirm('确认删除任务「' + task.name + '」？').then(() => {
        return delMemberTask(task.id)
      }).then(() => {
        this.$message.success('删除成功')
        this.loadTasks()
      }).catch(() => {})
    },
    submitTaskForm() {
      this.$refs.taskForm.validate(valid => {
        if (!valid) return
        const data = { ...this.taskForm }
        const fn = data.id ? updateMemberTask(data) : addMemberTask(data)
        fn.then(() => {
          this.$message.success(data.id ? '修改成功' : '创建成功')
          this.taskDialogVisible = false
          this.loadTasks()
        }).catch(() => {})
      })
    },

    // 审批
    handleApprove(id, status) {
      const title = status === 1 ? '通过' : '拒绝'
      this.$confirm('确认' + title + '该申请？').then(() => {
        return approveMemberApplication(id, status)
      }).then(() => {
        this.$message.success('审批成功')
        this.loadApplications(); this.loadMembers()
      }).catch(() => {})
    },

    // 成员管理
    handlePromote(member) {
      this.$confirm('确认提拔为管理员？').then(() => changeMemberRoleByGuild(member.id, 2)).then(() => { this.$message.success('提拔成功'); this.loadMembers() }).catch(() => {})
    },
    handleDemote(member) {
      this.$confirm('确认取消管理员资格？').then(() => changeMemberRoleByGuild(member.id, 3)).then(() => { this.$message.success('已降级'); this.loadMembers() }).catch(() => {})
    },
    handleKick(member) {
      this.$confirm('确认踢出该成员？').then(() => delMemberByGuild(member.id)).then(() => { this.$message.success('踢出成功'); this.loadMembers() }).catch(() => {})
    },

    // 辅助
    myTaskParticipantStatus(task) {
      const p = this.myTaskParticipants[task.id]
      return p ? p.status : null
    },
    getMyTaskStatusTag(task) {
      if (task.status === 1) return 'success'
      if (task.status === 3) return 'info'
      if (task.status === 4) return 'danger'
      if (task.status === 2) {
        const s = this.myTaskParticipantStatus(task)
        return s === 3 ? 'success' : 'warning'
      }
      return 'warning'
    },
    getMyTaskStatusText(task) {
      if (task.status === 1) return '可接取'
      if (task.status === 3) return '已完成'
      if (task.status === 4) return '已过期'
      if (task.status === 2) {
        const s = this.myTaskParticipantStatus(task)
        return s === 3 ? '已完成' : '进行中'
      }
      return '进行中'
    },
    parseTime(time) {
      if (!time) return ''
      return new Date(time).toLocaleString('zh-CN')
    },
    parseChatTime(time) {
      if (!time) return ''
      const d = new Date(time)
      const now = new Date()
      const isToday = d.toDateString() === now.toDateString()
      return isToday ? d.toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' }) : d.toLocaleString('zh-CN')
    },
    // 聊天
    initChat() {
      if (!this.guildId || this.activeTab !== 'chat') return
      stopChat()
      this.chatConnected = true
      startChat(this.guildId, (msgs, isHistory) => {
        if (isHistory) {
          // 替换全部消息（历史加载）
          this.chatMessages = msgs
        } else {
          // 追加新消息
          for (const m of msgs) {
            this.chatMessages.push(m)
          }
        }
        this.$nextTick(() => this.scrollChatToBottom())
      })
    },
    sendChat() {
      if (!this.chatInput.trim() || !this.chatConnected || this.chatSending) return
      this.chatSending = true
      sendChatMessage(this.guildId, this.chatInput.trim()).then(() => {
        this.chatInput = ''
        this.chatSending = false
      }).catch(err => {
        this.chatSending = false
        this.$message.error('发送失败: ' + (err.message || '请先登录'))
      })
    },
    scrollChatToBottom() {
      const el = this.$refs.chatMessages
      if (el) el.scrollTop = el.scrollHeight
    },
    isMyMsg(msg) {
      return !!(this.myUserId && String(msg.senderId) === String(this.myUserId))
    }
  }
}
</script>

<style scoped>
.myguild-page { min-height: 100vh; background: #0a0a0f; color: #fff; padding: 90px 40px 40px; max-width: 1400px; margin: 0 auto; }
.guild-header { display: flex; justify-content: space-between; align-items: center; background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.08); border-radius: 16px; padding: 24px 32px; margin-bottom: 24px; }
.header-left { display: flex; align-items: center; gap: 16px; }
.guild-avatar { font-size: 48px; }
.guild-meta { display: flex; flex-direction: column; }
.guild-name { font-size: 24px; margin: 0; }
.guild-partition { font-size: 13px; color: rgba(255,255,255,0.5); }
.my-role-tag { margin-left: 12px; }
.header-right .member-count { color: rgba(255,255,255,0.5); font-size: 14px; }
.guild-body { display: flex; gap: 20px; }
.guild-main { flex: 1; min-width: 0; }
.guild-sidebar { width: 280px; flex-shrink: 0; }
.sidebar-header h3 { margin: 0 0 12px; font-size: 16px; }
.member-list { background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.06); border-radius: 12px; padding: 12px; }
.member-item { display: flex; align-items: center; gap: 10px; padding: 8px 0; border-bottom: 1px solid rgba(255,255,255,0.04); }
.member-item:last-child { border-bottom: none; }
.member-avatar { position: relative; font-size: 24px; }
.online-dot { position: absolute; bottom: 0; right: 0; width: 8px; height: 8px; border-radius: 50%; }
.online-dot.online { background: #67C23A; }
.online-dot.offline { background: #909399; }
.member-info { flex: 1; display: flex; flex-direction: column; gap: 2px; }
.member-name { font-size: 13px; }
.guild-tabs >>> .el-tabs__item { color: rgba(255,255,255,0.6) !important; }
.guild-tabs >>> .el-tabs__item.is-active { color: #00ff88 !important; }
.guild-tabs >>> .el-tabs__nav-wrap::after { background-color: rgba(255,255,255,0.08); }
.task-subtabs >>> .el-tabs__item { color: rgba(255,255,255,0.6) !important; border: 1px solid transparent !important; }
.task-subtabs >>> .el-tabs__item.is-active { color: #00ff88 !important; border-color: rgba(255,255,255,0.1) !important; }
.tasks-toolbar { margin-bottom: 12px; }
.task-list { display: flex; flex-direction: column; gap: 12px; }
.task-card { background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.06); border-radius: 12px; padding: 16px; }
.task-card.completed { opacity: 0.6; }
.task-card.expired { opacity: 0.5; border-color: rgba(245,108,108,0.3); }
.task-header { display: flex; align-items: center; gap: 8px; margin-bottom: 6px; }
.task-title { font-size: 15px; font-weight: 600; flex: 1; }
.task-desc { color: rgba(255,255,255,0.5); font-size: 13px; margin: 0 0 8px; }
.task-meta { display: flex; gap: 16px; font-size: 12px; color: rgba(255,255,255,0.4); margin-bottom: 10px; }
.task-actions { display: flex; gap: 8px; }
.expired-reason { color: rgba(245,108,108,0.7); font-size: 12px; margin: 4px 0 0; }
.empty-placeholder { text-align: center; padding: 40px 0; color: rgba(255,255,255,0.2); }
.empty-placeholder span { font-size: 48px; }
.chat-area {
  display: flex; flex-direction: column; height: 450px;
  background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.06); border-radius: 12px; overflow: hidden;
}
.chat-messages {
  flex: 1; overflow-y: auto; padding: 16px;
  display: flex; flex-direction: column; gap: 12px;
}
.chat-empty { text-align: center; padding: 60px 0; color: rgba(255,255,255,0.2); }
.chat-empty span { font-size: 48px; }
.chat-msg { display: flex; gap: 10px; max-width: 85%; }
.chat-msg.mine { align-self: flex-end; flex-direction: row-reverse; }
.chat-msg-avatar {
  width: 34px; height: 34px; border-radius: 50%; background: rgba(0,255,136,0.15);
  display: flex; align-items: center; justify-content: center; font-size: 18px; flex-shrink: 0;
}
.chat-msg-body { display: flex; flex-direction: column; gap: 2px; }
.chat-msg-header { display: flex; gap: 8px; align-items: center; }
.chat-msg-name { font-size: 12px; color: rgba(0,255,136,0.7); }
.chat-msg-time { font-size: 10px; color: rgba(255,255,255,0.2); }
.chat-msg.mine .chat-msg-name { color: rgba(0,212,255,0.7); }
.chat-msg-content {
  padding: 8px 14px; border-radius: 0 12px 12px 12px;
  background: rgba(255,255,255,0.06); font-size: 14px; line-height: 1.5;
  word-break: break-word;
}
.chat-msg.mine .chat-msg-content {
  border-radius: 12px 0 12px 12px;
  background: rgba(0,212,255,0.12);
}
.chat-msg.ai .chat-msg-content {
  background: rgba(168, 85, 247, 0.12);
}
.chat-msg.ai .chat-msg-name {
  color: rgba(168, 85, 247, 0.8);
}
.chat-input-bar {
  display: flex; align-items: center; gap: 8px;
  padding: 10px 12px; border-top: 1px solid rgba(255,255,255,0.06);
  background: rgba(255,255,255,0.02);
}
.chat-input-bar >>> .el-input__inner { background: rgba(255,255,255,0.06); border-color: rgba(255,255,255,0.1); color: #fff; }
.chat-status { font-size: 11px; color: rgba(255,255,255,0.3); white-space: nowrap; }
.application-list { display: flex; flex-direction: column; gap: 12px; }
.application-card { background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.06); border-radius: 12px; padding: 16px; }
.app-header { display: flex; justify-content: space-between; margin-bottom: 6px; }
.app-time { color: rgba(255,255,255,0.3); font-size: 12px; }
.app-reason { color: rgba(255,255,255,0.5); font-size: 13px; margin-bottom: 10px; }
.app-actions { display: flex; gap: 8px; }
.manage-member-list { display: flex; flex-direction: column; gap: 8px; }
.manage-member-item { display: flex; align-items: center; justify-content: space-between; padding: 10px 14px; background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.05); border-radius: 8px; }
.mm-info { display: flex; align-items: center; gap: 10px; }
.mm-actions { display: flex; gap: 8px; }
.participant-list { display: flex; flex-direction: column; gap: 8px; }
.participant-item { display: flex; align-items: center; gap: 10px; padding: 8px 12px; background: rgba(255,255,255,0.03); border-radius: 8px; }
.p-avatar { font-size: 20px; }
.p-name { flex: 1; }
</style>
