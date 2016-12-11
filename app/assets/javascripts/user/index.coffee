# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# 响应绩效申请
$ ->
  $('#request-grade').click(() ->
    currentUserId = Cookies.get(COOKIE_CURRENT_USER_ID)
    if currentUserId
      window.location.href = '/user/' + currentUserId
    else
      window.location.reload
  )
  return