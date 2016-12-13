class User

  include Mongoid::Document

  field :name # 姓名
  field :dingtalk_id # 钉钉返回的id，唯一

  field :valid_in_dingtalk, type: Boolean, default: true # 在钉钉中是否有效，存在-有效，不存在-无效
  field :visible, type: Boolean, default: true # 是否可见
  field :score, type: Integer, default: 0 # 量化考核评分

  index({dingtalk_id: 1}, {unique: true}) # 基于dingtalk_id的unique索引

  ALL_USER_CACHE_KEY = 'User::ALL_USER_CACHE_KEY'

  # 构造
  def initialize(name, dingtalk_id)
    super()
    self.name = name
    self.dingtalk_id = dingtalk_id
  end

  # 重载save，如果是新user就刷新缓存
  # @return nothing
  def save
    new = new_record?
    super
    if new
      self.class.find_all_users_with_cache(true)
    end
  end

  class << self

    # 根据钉钉返回的结果更新所有user
    # @param [Array[Dingtalk::UserInfo]] data 钉钉返回的user结果
    def update_all(data)
      dingtalk_results = data.dup

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

    # 查找所有用于显示在天梯展示页面的数据
    # @return [Array[Hash{name:, score:}]]
    def find_all_users_for_main_page
      find_all_users_with_cache.select{|user| user.valid_in_dingtalk && user.visible}.map do |user|
        {name: user.name, score: user.score}
      end
    end

    # 根据dingtalk_id查询用户
    # @param [String] id dingtalk id
    # @return [User] 未找到返回nil
    def find_user_by_dingtalk_id(id)
      users = find_all_users_with_cache
      results = users.select do |user|
        user.dingtalk_id == id
      end
      if results.empty?
        users = find_all_users_with_cache(true)
        results = users.select do |user|
          user.dingtalk_id == id
        end
      end
      return nil if results.empty?
      results[0]
    end

    # 根据dingtalk_id查询用户名
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

  private

  class << self

    # 直接查找所有用户，不使用缓存
    # @return [Array[User]] 不会返回nil
    def find_all_users_directly
      User.all.map do |user|
        user
      end
    end

    # 使用缓存查找所有用户
    # @param [TrueClass/FalseClass] 默认false，如果需要强制刷新就传true
    # @return [Array[User]] 不会返回nil
    def find_all_users_with_cache(force = false)
      Rails.cache.fetch(ALL_USER_CACHE_KEY, expires_in: 1.days, force: force) do
        find_all_users_directly
      end
    end
  end
end