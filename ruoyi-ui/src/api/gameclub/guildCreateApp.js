import request from '@/utils/request'

export function listGuildCreateApp(query) {
  return request({ url: "/system/guildCreateApp/list", method: "get", params: query })
}
export function getGuildCreateApp(id) {
  return request({ url: "/system/guildCreateApp/" + id, method: "get" })
}
export function approveGuildCreateApp(data) {
  return request({ url: "/system/guildCreateApp/approve", method: "put", data: data })
}
export function delGuildCreateApp(id) {
  return request({ url: "/system/guildCreateApp/" + id, method: "delete" })
}
