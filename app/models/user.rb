class User

  include Mongoid::Document

  field :name # 姓名
  field :dingtalk_id # 钉钉返回的id，唯一

  field :valid_in_dingtalk, type: Boolean, default: true # 在钉钉中是否有效，存在-有效，不存在-无效
  field :visible, type: Boolean, default: true # 是否可见
  field :score, type: Integer, default: 0 # 量化考核评分

  index({dingtalk_id: 1}, {unique: true})

  # 构造
  def initialize(name, dingtalk_id)
    super()
    self.name = name
    self.dingtalk_id = dingtalk_id
  end

  # 更改评分
  # @param [Fixnum] grade 更改评分
  def alter_score(grade)
    self.score += grade
    self.save
  end

  class << self

    # 根据钉钉返回的结果更新所有user
    # @param [Array[Dingtalk::UserInfo]] dingtalk_results 钉钉返回的user结果
    def update_all(dingtalk_results)

      # 根据是否存在于钉钉的结果，更新数据库里面的用户有效性
      self.all.each do |db_user|
        find = false
        dingtalk_results.each_index do |index|
          if db_user.dingtalk_id == dingtalk_results[index].userid
            db_user.valid_in_dingtalk = true
            db_user.save
            dingtalk_results.delete_at(index)
            find = true
            break
          end
        end
        unless find
          db_user.valid_in_dingtalk = false
          db_user.save
        end
      end

      # 将新增的用户插入数据库
      dingtalk_results.each do |dingtalk_user|
        user = User.new(dingtalk_user.name, dingtalk_user.userid)
        user.save
      end
    end

    # 根据dingtalk_id查找用户
    # @param [String] dingtalk_id
    # @return [User] 查询结果或nil
    def find_user_by_dingtalk_id(dingtalk_id)
      self.where(dingtalk_id: dingtalk_id).first
    end

    # 查找所有用于显示在天梯展示页面的数据
    # @return [Array[Hash{name:, score:}]]
    def find_all_users_for_main_page()
      User.where(valid_in_dingtalk: true, visible: true).map do |user|
        {name: user.name, score: user.score}
      end
    end
  end
end