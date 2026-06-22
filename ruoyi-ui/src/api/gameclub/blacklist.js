import request from '@/utils/request'

// 查询工会黑名单列表
export function listBlacklist(query) {
  return request({
    url: "/system/guildBlacklist/list",
    method: "get",
    params: query
  });
}

// 查询工会黑名单详细
export function getBlacklist(id) {
  return request({
    url: "/system/guildBlacklist/" + id,
    method: "get"
  });
}

// 新增工会黑名单
export function addBlacklist(data) {
  return request({
    url: "/system/guildBlacklist",
    method: "post",
    data: data
  });
}

// 修改工会黑名单
export function updateBlacklist(data) {
  return request({
    url: "/system/guildBlacklist",
    method: "put",
    data: data
  });
}

// 删除工会黑名单
export function delBlacklist(id) {
  return request({
    url: "/system/guildBlacklist/" + id,
    method: "delete"
  });
}

// 解除黑名单
export function removeBlacklist(id) {
  return request({
    url: "/system/guildBlacklist/remove/" + id,
    method: "put"
  });
}