# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# 根据score来排序
sortByScore = (left, right) ->
  return 1 if left.score < right.score
  return -1 if left.score > right.score
  return 0

# 生成排名
rankByScore = (data) ->
  rank = 1
  length = data.length
  lastScore = 0
  for value, index in data
    rank = index + 1 unless value.score == lastScore
    lastScore = value.score
    value.percent = calcRankPercent(rank, length)
    value.rank = "(排名：#{rank}/#{length}, 前#{value.percent}%)"
  return data

# 计算排名百分比
calcRankPercent = (rank, total) ->
  return Math.ceil(rank * 10.0 / total) * 10

# 根据排名生成颜色
colorByRank = (data) ->
  for hash in data
    if hash.percent <= 20
      hash.color = '#00FF00' # 优，绿色
    else if hash.percent == 100
      hash.color = '#FF0000' # 差，红色
    else
      hash.color = '#CFCFCF'
  return data

# 数据预处理
pretreatData = (data) ->
  data = data.sort(sortByScore)
  data = rankByScore(data)
  return colorByRank(data)

# 绘制图形
draw = (chart, data) ->
  data = data.reverse()
  option = {
    title: {
      text: '天梯——实时量化绩效考核'
    },
    tooltip: {},
    yAxis: {
      data: data.map((hash) -> "#{hash.name}#{hash.rank}"),
      type: 'category',
      axisLabel: {
        show: false,
        inside: true
      },
    },
    xAxis: {
      position: 'top',
      type: 'value',
      splitLine: {
        show: false
      }
    },
    series: {
      type: 'bar',
      data: data.map((hash) -> hash.score),
      label: {
        normal: {
          position: 'insideLeft',
          show: true,
          formatter: '{b}: {c}分',
          textStyle: {
            color: '#000000'
          }
        }
      },
      itemStyle: {
        normal: {
          color: ((params) -> data.map((hash) -> hash.color)[params.dataIndex])
        }
      }
    }
    grid: {
      containLabel: true
    }
  }
  chart.setOption(option)
  return

# 请求天梯数据并绘制图形
refreshChart = () ->
  chart = echarts.init(document.getElementById('chart'))
  chart.showLoading()
  $.ajax '/ladder/scores',
    type: 'GET'
    error: (jqXHR, textStatus, errorThrown) ->
      chart.hideLoading()
      $('#chart').height(0)
      $('body').append "请求天梯数据失败！"
    success: (data, textStatus, jqXHR) ->
      chart.hideLoading()
      data = pretreatData(data)
      alterChartHeightByData(data.length)
      chart = echarts.init(document.getElementById('chart'))
      draw(chart, data)
  return

# 载入完成后立即请求天梯数据
$ ->
  refreshChart()
  return

# 根据返回结果动态调整chart的高度
alterChartHeightByData = (dataLength) ->
  originalHeight = $('#chart').height()
  height = 2 * dataLength
  $('#chart').css('height', "#{height}rem");
  newHeight = $('#chart').height()
  $('#chart').height(originalHeight) if newHeight < originalHeight
  return

# 显示右上角的刷新按钮
$ ->
  $(".refresh").fadeIn("fast")
  return

# 刷新事件
$ ->
  $(".refresh").click(->
    refreshChart()
  )
  return