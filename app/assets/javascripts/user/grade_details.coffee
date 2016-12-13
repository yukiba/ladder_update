# 会在钉钉初始化成功之后被调用
@afterDingtalkInitedInUserPage = () ->
  dd.biz.navigation.setTitle({
    title: '绩效详情'
  })
  dd.biz.navigation.setRight({
    show: false
  })
  return

# 请求详情数据
$ ->
  $.ajax window.location.pathname + '/post',
    type: 'POST'
    error: (jqXHR, textStatus, errorThrown) ->
      dd.device.notification.toast({
        text: "请求绩效数据失败！"
      })
    success: (data, textStatus, jqXHR) ->
      if data.details?
        $('#no-result-div').css('display', 'none')
        $('#results-div').css('display', 'block')
        displayData(data.details)
      else
        $('#no-result-div').css('display', 'block')
        $('#results-div').css('display', 'none')
  return

# 展示数据
displayData = (details) ->
  $('#details-title').html(details.title)
  $('#details-name').html(details.name)
  $('#details-status').html('状态： ' + details.status)
  $('#details-description').html(details.description)
  for log in details.log
    do(log) ->
      newDom = $('#log-sample').clone()
      newDom.css('display', 'block')
      newDom.html(log)
      newDom.appendTo($('#logs'))
  return