class Grade

  include Mongoid::Document
  include Mongoid::Timestamps

  field :dingtalk_id # 钉钉返回的id，唯一
  field :title # 任务标题
  field :grade, type: Float # 评分
  field :description # 描述
  field :status #状态

  embeds_many :grade_logs, after_add: :sort_grade_logs_by_time # 操作日志

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

  class << self

    # 基于用户ID查找等待审批的grade
    # @param [String] dingtalk_id
    # @return [Array[Grade]] 未找到就返回一个空Array
    def find_waiting_by_dingtalk_id(dingtalk_id)
      Grade.where(dingtalk_id: dingtalk_id, status: STATUS_WAITING).order_by(created_at: :desc).map do |x|
        {
            id: x._id.to_s,
            title: x.title,
            grade: x.grade,
            status: x.status,
            name: User.username_to_s(x.dingtalk_id),
            created_at: Timeable::time_to_s(x.created_at)
        }
      end
    end

    # 根据grade的id查找grade信息
    # @param [String] id _id
    # @return [Hash]
    def find_grade_details(id)
      result = {}
      grade = Grade.where(_id: id).first
      unless grade.nil?
        details = {}
        details[:id] = grade._id.to_s
        details[:title] = grade.title
        details[:name] = User.username_to_s(grade.dingtalk_id)
        details[:status] = grade.status
        details[:description] = grade.description
        details[:log] = grade.grade_logs.map { |log| log.to_s }
        result[:details] = details
      end
      result
    end
  end

  private

  # 根据时间排序grade_logs
  # @param [Array] logs 仅仅是为了满足回调函数的格式，实际不使用这个参数
  def sort_grade_logs_by_time(logs)
    self.grade_logs.sort! { |x, y| x.created_at <=> y.created_at }
  end
end