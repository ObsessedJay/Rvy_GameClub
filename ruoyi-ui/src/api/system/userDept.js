import request from '@/utils/request'

// 用户注册到业务网站（首次访问时自动归类）
export function registerToWebsite(websiteCode) {
  return request({
    url: '/system/userDept/register/' + websiteCode,
    method: 'post'
  })
}

// 查询用户在某个网站的部门归属
export function getUserDeptByWebsite(websiteCode) {
  return request({
    url: '/system/userDept/myDept',
    method: 'get',
    params: { websiteCode }
  })
}

// 查询所有业务网站配置
export function listWebsiteConfig() {
  return request({
    url: '/system/userDept/websites',
    method: 'get'
  })
}