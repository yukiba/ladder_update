$ ->
  dd.config()
  dd.ready(() ->
    dd.biz.navigation.setTitle({
      title: '绩效申请'
    })
  )
  return