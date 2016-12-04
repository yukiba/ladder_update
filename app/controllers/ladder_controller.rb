class LadderController < ApplicationController

  def index
  end

  # 查询实时绩效考核成绩
  def realtime_score
    data = User.find_all_users_for_main_page || []

    # 试运行阶段，产生个随机数
    data.each do |user|
      user[:score] = rand(100)
    end

    render json: data
  end
end
