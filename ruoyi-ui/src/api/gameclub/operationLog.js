import request from '@/utils/request'

// 查询工会操作日志列表
export function listOperationLog(query) {
  return request({
    url: "/system/guildOperationLog/list",
    method: "get",
    params: query
  });
}

// 查询工会操作日志详细
export function getOperationLog(id) {
  return request({
    url: "/system/guildOperationLog/" + id,
    method: "get"
  });
}

// 删除工会操作日志
export function delOperationLog(id) {
  return request({
    url: "/system/guildOperationLog/" + id,
    method: "delete"
  });
}

// 清空操作日志
export function clearOperationLog(guildId) {
  return request({
    url: "/system/guildOperationLog/clear/" + guildId,
    method: "delete"
  });
}

// 导出操作日志
export function exportOperationLog(query) {
  return request({
    url: "/system/guildOperationLog/export",
    method: "post",
    params: query,
    responseType: "blob"
  });
}