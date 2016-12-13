# 会在钉钉初始化成功后被调用
@afterDingtalkInitedInGradePage = () ->
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
  dd.biz.navigation.setTitle({
    title: '我的绩效申请'
  })
  return

# 向服务器请求数据
$ ->
  $.ajax window.location.pathname + '/post',
    type: 'POST'
    error: (jqXHR, textStatus, errorThrown) ->
      dd.device.notification.toast({
        text: "请求绩效数据失败！"
      })
    success: (data, textStatus, jqXHR) ->
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
      newDom.children('div.data-left').children('label.data-name').html('创建于 ' + d.created_at)
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