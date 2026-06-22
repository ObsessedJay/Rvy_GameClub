import request from '@/utils/request'

// 查询工会消息列表
export function listGuildMessage(query) {
  return request({
    url: "/system/guildMessage/list",
    method: "get",
    params: query
  });
}

// 查询工会消息详细
export function getGuildMessage(id) {
  return request({
    url: "/system/guildMessage/" + id,
    method: "get"
  });
}

// 新增工会消息
export function addGuildMessage(data) {
  return request({
    url: "/system/guildMessage",
    method: "post",
    data: data
  });
}

// 修改工会消息
export function updateGuildMessage(data) {
  return request({
    url: "/system/guildMessage",
    method: "put",
    data: data
  });
}

// 删除工会消息
export function delGuildMessage(id) {
  return request({
    url: "/system/guildMessage/" + id,
    method: "delete"
  });
}

// 标记为已读
export function markAsRead(id) {
  return request({
    url: "/system/guildMessage/read/" + id,
    method: "put"
  });
}

// 批量标记为已读
export function markAllAsRead() {
  return request({
    url: "/system/guildMessage/readAll",
    method: "put"
  });
}

// 查询未读消息数量
export function getUnreadCount() {
  return request({
    url: "/system/guildMessage/unreadCount",
    method: "get"
  });
}

// 查询我的消息列表
export function getMyMessages(query) {
  return request({
    url: "/system/guildMessage/myMessages",
    method: "get",
    params: query
  });
}
