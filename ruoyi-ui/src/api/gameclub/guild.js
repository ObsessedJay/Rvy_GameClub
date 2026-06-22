import request from '@/utils/request'

// 查询工会列表（管理后台，带分页）
export function listGuild(query) {
  return request({
    url: "/system/guild/list",
    method: "get",
    params: query
  });
}

// 查询工会详细（管理后台）
export function getGuild(id) {
  return request({
    url: "/system/guild/" + id,
    method: "get"
  });
}

// 新增工会
export function addGuild(data) {
  return request({
    url: "/system/guild",
    method: "post",
    data: data
  });
}

// 修改工会
export function updateGuild(data) {
  return request({
    url: "/system/guild",
    method: "put",
    data: data
  });
}

// 删除工会
export function delGuild(id) {
  return request({
    url: "/system/guild/" + id,
    method: "delete"
  });
}

// 修改工会状态
export function changeGuildStatus(id, status) {
  return request({
    url: "/system/guild/changeStatus",
    method: "put",
    params: { id, status }
  });
}

// 获取我管理的工会
export function getMyGuilds() {
  return request({
    url: "/system/guild/myGuilds",
    method: "get"
  });
}

// 导出工会
export function exportGuild(query) {
  return request({
    url: "/system/guild/export",
    method: "post",
    params: query
  });
}

// 获取公开工会列表（主页热门工会）
export function listPublicGuilds() {
  return request({
    url: "/system/gameclub/public/guilds",
    method: "get"
  });
}

// 获取公开工会详情
export function getPublicGuild(id) {
  return request({
    url: "/system/gameclub/public/guild/" + id,
    method: "get"
  });
}

// 申请创建工会
export function createGuildApply(data) {
  return request({
    url: "/system/gameclub/public/createGuild",
    method: "post",
    data: data
  });
}
