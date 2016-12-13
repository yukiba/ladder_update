$ ->
  dd.config()
  dd.ready(() ->
    dd.biz.navigation.setTitle({
      title: '绩效申请'
    })
  )
  return

$ ->
  if $('#new-request-button')
    $('#new-request-button').click (() ->
      currentUserId = Cookies.get(COOKIE_CURRENT_USER_ID)
      if currentUserId
        window.location.href = '/user/' + currentUserId
      else
        window.location.reload
    )
  return