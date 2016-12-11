class UserController < ApplicationController

  def index
  end

  def request_grade
  end

  # 接收post请求，添加一个grade
  def add_grade
    user_id = params[:user_id] || ''
    name = params[:name] || ''
    grade = params[:grade].to_f
    description = params[:description] || ''
    creator = params[:creator] || user_id
    result = {}
    if user_id.empty? || name.empty? || grade.zero? || description.empty? || creator.empty?
      result = {status: 'error', msg: '添加绩效请求失败！'}
    else
      save_result = false
      new_grade = Grade.new(user_id, name, grade, description, creator)
      save_result = new_grade.save rescue nil
      if save_result
        result = {status: 'ok', msg: "添加绩效请求成功！"}
      else
        result = {status: 'error', msg: '添加绩效请求失败！'}
      end
    end
    render json: result
  end
end
