import request from '@/utils/request'

// 查询工会成员列表
export function listGuildMember(query) {
  return request({
    url: "/system/guildMember/list",
    method: "get",
    params: query
  });
}

// 查询工会成员详细
export function getGuildMember(id) {
  return request({
    url: "/system/guildMember/" + id,
    method: "get"
  });
}

// 新增工会成员
export function addGuildMember(data) {
  return request({
    url: "/system/guildMember",
    method: "post",
    data: data
  });
}

// 修改工会成员
export function updateGuildMember(data) {
  return request({
    url: "/system/guildMember",
    method: "put",
    data: data
  });
}

// 删除工会成员
export function delGuildMember(id) {
  return request({
    url: "/system/guildMember/" + id,
    method: "delete"
  });
}

// 修改成员角色
export function changeMemberRole(id, role) {
  return request({
    url: "/system/guildMember/changeRole",
    method: "put",
    params: { id, role }
  });
}

// 退出工会
export function quitGuild(id) {
  return request({
    url: "/system/guildMember/quit/" + id,
    method: "put"
  });
}

// ===== 会员自助接口（免 @PreAuthorize，基于工会角色校验） =====

export function listMemberGuildMember(query) {
  return request({
    url: "/system/gameclub/member/member/list",
    method: "get",
    params: query
  });
}

export function changeMemberRoleByGuild(id, role) {
  return request({
    url: "/system/gameclub/member/member/changeRole",
    method: "put",
    params: { id, role }
  });
}

export function delMemberByGuild(id) {
  return request({
    url: "/system/gameclub/member/member/" + id,
    method: "delete"
  });
}

// 查询用户在指定游戏分区的工会成员信息
export function getMyGuild(gamePartitionId) {
  return request({
    url: "/system/guildMember/myGuild",
    method: "get",
    params: { gamePartitionId }
  });
}

// 获取当前用户的所有工会成员身份
export function getMyGuilds() {
  return request({
    url: "/system/guildMember/myGuilds",
    method: "get"
  });
}

// 获取当前用户的GameClub身份信息（名称+角色）
export function getMyRole() {
  return request({
    url: "/system/guildMember/myRole",
    method: "get"
  });
}
