# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# 测试数据
data = [
  {"name": "aaa", "score": 83},
  {"name": "bbb", "score": 43},
  {"name": "ccc", "score": 74},
  {"name": "ddd", "score": 14},
  {"name": "eee", "score": 98},
  {"name": "fff", "score": 32},
  {"name": "ggg", "score": 67},
  {"name": "hhh", "score": 45},
  {"name": "iii", "score": 39},
  {"name": "jjj", "score": 52},
  {"name": "kkk", "score": 59},
  {"name": "lll", "score": 12},
  {"name": "mmm", "score": 98},
  {"name": "nnn", "score": 57},
  {"name": "ooo", "score": 36},
  {"name": "ppp", "score": 84},
  {"name": "qqq", "score": 72},
  {"name": "rrr", "score": 94},
  {"name": "sss", "score": 53},
  {"name": "ttt", "score": 62},
  {"name": "uuu", "score": 38},
  {"name": "vvv", "score": 67},
  {"name": "www", "score": 18},
  {"name": "xxx", "score": 66},
  {"name": "yyy", "score": 77},
  {"name": "zzz", "score": 30}
]

# 测试用button
$ ->
  $('#test').on 'click', ->
    draw(pretreatData(data))
    return

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
draw = (data) ->
  data = data.reverse()
  myChart = echarts.init(document.getElementById('main'));
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
          formatter: '{b}: {c}',
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
  myChart.setOption(option)
  return