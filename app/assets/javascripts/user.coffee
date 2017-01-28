# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@COOKIE_CURRENT_USER_ID = 'current-user-id'

$ ->
  $('body').hide() # 隐藏body，等待钉钉那边信息获取结束之后再显示
  startInitDingtalk(afterDingtalkInited)

# 钉钉初始化结束之后
afterDingtalkInited = () ->
  queryCurrentUserInfo()
#  dd.ui.webViewBounce.disable() # 禁用下拉效果
  afterDingtalkInitedInUserPage() if afterDingtalkInitedInUserPage?
  return

# 开始钉钉的初始化
startInitDingtalk = (callback) ->
  queryDingtalkConfig(
    (config) -> initDingtalk(config, callback),
    () -> dd.device.notification.alert({
      title: "访问天梯服务器失败",
      message: "点击确定返回上一页",
      onSuccess: () -> dd.biz.navigation.close()
    }))
  return

# 初始化钉钉
initDingtalk = (config, callback) ->
  config.agentId = agentId
  config.jsApiList = ['biz.user.get']
  dd.config(config)
  dd.ready(() ->
    callback() if callback
  )
  dd.error((err) ->
    dd.device.notification.alert({
      title: "访问钉钉服务器失败",
      message: "点击确定返回上一页",
      onSuccess: () -> dd.biz.navigation.close()
    }))
  return

# 向自己部署的签名服务器请求相关的钉钉配置信息
queryDingtalkConfig = (successfulCallback, failedCallback) ->
  $.ajax 'http://dingtalk.sjtudoit.com/admin/jsapiconfig?fresh=' + Math.random(),
    type: 'POST'
    data: {url: $.base64.encode(window.location.href)}
    error: (jqXHR, textStatus, errorThrown) ->
      failedCallback() if failedCallback
    success: (data, textStatus, jqXHR) ->
      successfulCallback(data.config) if successfulCallback
  return

# 向钉钉服务器当前用户信息
queryCurrentUserInfo = () ->
  dd.biz.user.get({
    onSuccess: (info) ->
      Cookies.set(COOKIE_CURRENT_USER_ID, info.emplId, { path:'/', expires: 1 })
      $('body').show()
    onFail: (err) ->
      dd.device.notification.alert({
        title: "访问钉钉服务器失败",
        message: "点击确定返回上一页",
        onSuccess: () -> dd.biz.navigation.close()
    })
  })
  return