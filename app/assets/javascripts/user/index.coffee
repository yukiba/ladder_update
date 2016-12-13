# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# 修改标题
$ ->
  dd.config()
  dd.ready(() ->
    dd.biz.navigation.setTitle({
      title: '天梯'
    })
    dd.biz.navigation.setRight({show: false})
  )
  return

# 响应绩效申请
$ ->
  $('#request-grade').click(() ->
    currentUserId = Cookies.get(COOKIE_CURRENT_USER_ID)
    if currentUserId
      window.location.href = '/user/' + currentUserId + '/grades/waiting'
    else
      window.location.reload
  )
  return