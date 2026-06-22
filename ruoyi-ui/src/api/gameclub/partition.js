import request from "@/utils/request";

// 查询游戏分区列表（管理后台，带分页）
export function listGamePartition(query) {
  return request({
    url: "/system/gamePartition/list",
    method: "get",
    params: query
  });
}

// 查询游戏分区列表（公开接口，不带分页）
export function publicListGamePartition() {
  return request({
    url: "/system/gameclub/public/partitions",
    method: "get"
  });
}

// 查询游戏分区详细（公开接口）
export function getGamePartition(id) {
  return request({
    url: "/system/gameclub/public/partition/" + id,
    method: "get"
  });
}

// 新增游戏分区
export function addGamePartition(data) {
  return request({
    url: "/system/gamePartition",
    method: "post",
    data: data
  });
}

// 修改游戏分区
export function updateGamePartition(data) {
  return request({
    url: "/system/gamePartition",
    method: "put",
    data: data
  });
}

// 修改游戏分区状态
export function changeStatus(id, status) {
  return request({
    url: "/system/gamePartition/changeStatus",
    method: "put",
    params: { id, status }
  });
}

// 删除游戏分区
export function delGamePartition(id) {
  return request({
    url: "/system/gamePartition/" + id,
    method: "delete"
  });
}

// 导出游戏分区
export function exportGamePartition(query) {
  return request({
    url: "/system/gamePartition/export",
    method: "post",
    params: query,
    responseType: "blob"
  });
}
