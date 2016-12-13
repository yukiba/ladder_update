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
    creator = cookies['current-user-id'] || ''
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

  # 查询指定用户正在等待批准的grades
  def waiting_grades_data
    user_id = params[:user_id] || ''
    grades = Grade.find_waiting_by_dingtalk_id(user_id)
    render json: grades
  end

  def waiting_grades
    render 'grades'
  end

  def grade_details
  end

  # 查询指定grade的详细信息
  def grade_details_data
    grade_id = params[:grade_id]
    details = Grade.find_grade_details(grade_id)
    render json: details
  end
end
