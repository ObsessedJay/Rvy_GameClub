import request from '@/utils/request'

// 查询工会申请列表
export function listApplication(query) {
  return request({
    url: "/system/guildApplication/list",
    method: "get",
    params: query
  });
}

// 查询工会申请详细
export function getApplication(id) {
  return request({
    url: "/system/guildApplication/" + id,
    method: "get"
  });
}

// 新增工会申请（公开接口）
export function addApplication(data) {
  return request({
    url: "/system/gameclub/public/apply",
    method: "post",
    data: data
  });
}

// 修改工会申请
export function updateApplication(data) {
  return request({
    url: "/system/guildApplication",
    method: "put",
    data: data
  });
}

// 删除工会申请
export function delApplication(id) {
  return request({
    url: "/system/guildApplication/" + id,
    method: "delete"
  });
}

// 审批申请
export function approveApplication(id, status, remark) {
  return request({
    url: "/system/guildApplication/approve",
    method: "put",
    data: { id, status, remark }
  });
}

// 批量审批申请
export function batchApprove(ids, status) {
  return request({
    url: "/system/guildApplication/batchApprove",
    method: "put",
    data: { ids, status }
  });
}

// ===== 会员自助接口（免 @PreAuthorize，基于工会角色校验） =====

export function listMemberApplication(query) {
  return request({
    url: "/system/gameclub/member/application/list",
    method: "get",
    params: query
  });
}

export function approveMemberApplication(id, status, remark) {
  return request({
    url: "/system/gameclub/member/application/approve",
    method: "put",
    data: { id, status, rejectReason: remark }
  });
}