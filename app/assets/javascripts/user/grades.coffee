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

# 会在钉钉初始化成功之后被调用
@afterDingtalkInitedInUserPage = () ->
  afterDingtalkInitedInGradePage() if afterDingtalkInitedInGradePage?
  return