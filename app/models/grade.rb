class Grade

  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :dingtalk_id # 钉钉返回的id，唯一
  field :grade, type: Integer # 评分
  field :description # 描述
  field :status #状态

  STATUS_APPROVING = 'approving'
  STATUS_APPROVED = 'approved'
  STATUS_DECLINE = 'decline'

  # 构造
  def initialize(dingtalk_id, grade, description)
    super()
    self.dingtalk_id = dingtalk_id
    self.grade = grade
    self.description = description
    self.status = STATUS_APPROVING
  end

  # 拒绝
  def decline()
    self.status = STATUS_DECLINE
    save
  end

  # 同意
  def appove()
    self.status = STATUS_APPROVED
    save
    user = User.find_user_by_dingtalk_id(self.dingtalk_id)
    user.alter_score(self.grade) unless user.nil?
  end
end