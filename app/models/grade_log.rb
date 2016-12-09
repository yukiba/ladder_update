# 绩效日志
class GradeLog

  include Mongoid::Document

  field :action # 动作类型
  field :creator_id # 创建者ID
  field :created_at, type: Time  # 因为embedded的原因，不会触发save，所以mongoid自带的无效，自己处理一个吧

  embedded_in :grade

  ACTION_CREATE = 'create'

  class << self

    # 初始化创建动作
    # @return [GradeLog]
    def initialize_create(id)
      log = GradeLog.new
      log.creator_id = id
      log.action = ACTION_CREATE
      log.created_at = Time.now
      log
    end
  end

  # 重载to_s，dispatcher
  # @return [String]
  def to_s
    raise Exception, 'unknown log action!' if action.empty?
    send("#{action}_to_s")
  end

  private

  # 创建动作对应的to_s
  # @return [String]
  def create_to_s
    username = self.class.username_to_s(creator_id)
    "#{created_at.localtime.strftime('%F %R:%S')} #{username} 创建"
  end

  class << self
    # 用户名
    # @param [String] id dingtalk_id
    # @return [String]
    def username_to_s(id)
      user = User.find_user_by_dingtalk_id(id)
      if user.nil?
        username = '未知用户'
      else
        username = user.name
      end
      username
    end
  end
end