import request from '@/utils/request'

// 查询工会公告列表（公开接口）
export function listAnnouncement() {
  return request({
    url: "/system/gameclub/public/announcements",
    method: "get"
  });
}

// 查询工会公告详细（公开接口）
export function getAnnouncement(id) {
  return request({
    url: "/system/gameclub/public/announcement/" + id,
    method: "get"
  });
}

// 新增工会公告
export function addAnnouncement(data) {
  return request({
    url: "/system/guildAnnouncement",
    method: "post",
    data: data
  });
}

// 修改工会公告
export function updateAnnouncement(data) {
  return request({
    url: "/system/guildAnnouncement",
    method: "put",
    data: data
  });
}

// 删除工会公告
export function delAnnouncement(id) {
  return request({
    url: "/system/guildAnnouncement/" + id,
    method: "delete"
  });
}

// 发布公告
export function publishAnnouncement(id) {
  return request({
    url: "/system/guildAnnouncement/publish/" + id,
    method: "put"
  });
}

// 撤回公告
export function withdrawAnnouncement(id) {
  return request({
    url: "/system/guildAnnouncement/withdraw/" + id,
    method: "put"
  });
}