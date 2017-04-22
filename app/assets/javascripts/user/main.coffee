# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# 响应新申请
$ ->
  $('#new-grade').click(() ->
    currentUserId = Cookies.get(COOKIE_CURRENT_USER_ID)
    if currentUserId
      window.location.href = '/user/' + currentUserId
    else
      window.location.reload
  )
  return

# 响应待审批
$ ->
  $('#request-grade').click(() ->
    currentUserId = Cookies.get(COOKIE_CURRENT_USER_ID)
    if currentUserId
      window.location.href = '/user/' + currentUserId + '/grades/waiting'
    else
      window.location.reload
  )
  return

# 响应已审批
$ ->
  $('#proved-grade').click(() ->
    currentUserId = Cookies.get(COOKIE_CURRENT_USER_ID)
    if currentUserId
      window.location.href = '/user/' + currentUserId + '/grades/proved'
    else
      window.location.reload
  )
  return

# 响应待我审批
$ ->
  if $('#admin-all-waiting')?
    $('#admin-all-waiting').click(() ->
      window.location.href = '/admin/grades/waiting'
    )
  return

# 会在钉钉初始化成功之后被调用
@afterDingtalkInitedInUserPage = () ->
  dd.biz.navigation.setRight({
    show: true,
    control: true,
    text: '新申请',
    onSuccess: (() ->
      currentUserId = Cookies.get(COOKIE_CURRENT_USER_ID)
      if currentUserId
        window.location.href = '/user/' + currentUserId
      else
        window.location.reload
    )
  })
  return