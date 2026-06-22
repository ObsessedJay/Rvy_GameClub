import request from '@/utils/request'

export function listGuildTask(query) {
  return request({ url: "/system/guildTask/list", method: "get", params: query });
}

export function getGuildTask(id) {
  return request({ url: "/system/guildTask/" + id, method: "get" });
}

export function addGuildTask(data) {
  return request({ url: "/system/guildTask", method: "post", data: data });
}

export function updateGuildTask(data) {
  return request({ url: "/system/guildTask", method: "put", data: data });
}

export function delGuildTask(id) {
  return request({ url: "/system/guildTask/" + id, method: "delete" });
}

export function changeTaskStatus(id, status) {
  return request({ url: "/system/guildTask/changeStatus", method: "put", params: { id, status } });
}

// ===== 会员自助接口 =====

export function listMemberTask(query) {
  return request({ url: "/system/gameclub/member/task/list", method: "get", params: query });
}

export function addMemberTask(data) {
  return request({ url: "/system/gameclub/member/task", method: "post", data: data });
}

export function updateMemberTask(data) {
  return request({ url: "/system/gameclub/member/task", method: "put", data: data });
}

export function delMemberTask(id) {
  return request({ url: "/system/gameclub/member/task/" + id, method: "delete" });
}

// 任务参与者
export function getTaskParticipants(id) {
  return request({ url: "/system/gameclub/member/task/" + id + "/participants", method: "get" });
}

export function joinTask(taskId) {
  return request({ url: "/system/gameclub/member/task/" + taskId + "/join", method: "post" });
}

export function cancelTask(taskId) {
  return request({ url: "/system/gameclub/member/task/" + taskId + "/cancel", method: "post" });
}

export function completeMemberTask(taskId) {
  return request({ url: "/system/gameclub/member/task/" + taskId + "/complete", method: "post" });
}

export function incompleteMemberTask(taskId) {
  return request({ url: "/system/gameclub/member/task/" + taskId + "/incomplete", method: "post" });
}

// 我的任务
export function listMyTasks(params) {
  return request({ url: "/system/gameclub/member/task/my", method: "get", params: params });
}

// 原参与者接口（保留兼容）
export function getTaskParticipants2(taskId) {
  return request({ url: "/system/guildTask/" + taskId + "/participants", method: "get" });
}

export function quitTask(taskId) {
  return request({ url: "/system/guildTask/" + taskId + "/quit", method: "post" });
}

export function readyTask(taskId) {
  return request({ url: "/system/guildTask/" + taskId + "/ready", method: "post" });
}

export function completeTask(taskId) {
  return request({ url: "/system/guildTask/" + taskId + "/complete", method: "post" });
}

// ===== 聊天 =====

export function getChatHistory(guildId, limit) {
  return request({ url: "/system/gameclub/member/chat/" + guildId + "/history", method: "get", params: { limit } });
}

export function sendChatMessage(guildId, content) {
  return request({ url: "/system/gameclub/member/chat/" + guildId + "/send", method: "post", data: { content } });
}

export function pollChatMessages(guildId, sinceId) {
  return request({ url: "/system/gameclub/member/chat/" + guildId + "/poll", method: "get", params: { sinceId } });
}
