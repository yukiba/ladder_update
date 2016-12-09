class Grade

  include Mongoid::Document
  include Mongoid::Timestamps

  field :dingtalk_id # 钉钉返回的id，唯一
  field :title  # 任务标题
  field :grade, type: Float # 评分
  field :description # 描述
  field :status #状态

  embeds_many :grade_logs

  # 各种状态
  STATUS_WAITING = '等待审批'
  STATUS_CHECK = '复核中'
  STATUS_A_PLUS_PLUS = 'A++'
  STATUS_A_PLUS = 'A+'
  STATUS_A = 'A'
  STATUS_B = 'B'
  STATUS_C = 'C'
  STATUS_D = 'D'
  STATUS_CANCELLED = '已废弃'

  # 构造
  def initialize(dingtalk_id, title, grade, description, create_id = dingtalk_id)
    super()
    self.dingtalk_id = dingtalk_id
    self.title = title
    self.grade = grade
    self.description = description
    self.status = STATUS_WAITING

    create_log = GradeLog.initialize_create(create_id)
    grade_logs << create_log
  end
end