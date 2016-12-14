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

# 请求数据成功
@onRequestGradesDataSuccess = (data) ->
  if data.length == 0
    $('#no-result-div').css('display', 'block')
    $('#new-request-button').css('display', 'block')
    $('#results-div').css('display', 'none')
  else
    $('#no-result-div').css('display', 'none')
    $('#results-div').css('display', 'block')
    displayData(data)
  return

# 显示服务器返回的数据
displayData = (data) ->
  for d in data
    do (d) ->
      newDom = $('#data-sample').clone()
      newDom.css('display', 'block')
      newDom.children('div.data-left').children('label.data-title').html(d.title)
      newDom.children('div.data-left').children('label.data-name').html(d.name + ' 创建于 ' + d.created_at)
      newDom.children('div.data-right').children('label.data-grade').html(d.grade + '分')
      newDom.children('div.data-right').children('label.data-status').html(d.status)
      newDom.children('label.data-grade-id').html(d.id)
      newDom.click((target) -> onGradeDivClick(target))
      newDom.appendTo($('#results-div'))
  return

# 响应每个grade div点击事件
onGradeDivClick = (target) ->
  grade_id = $(target.currentTarget).children('label.data-grade-id').text()
  grade_id = '0' unless grade_id?
  window.location.href = '/user/' + grade_id + '/details'
  return