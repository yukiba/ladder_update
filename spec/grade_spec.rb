require 'spec_helper'
require 'rails_helper'
require_relative '../config/environment'

describe 'grade create log' do

  it 'log correct' do
    User.delete_all
    u = User.new('name', 'dingtalk_id')
    u.save
    Grade.delete_all
    g = Grade.new('dingtalk_id', 'title', 10, 'description')
    g.save
    log = g.grade_logs[0].to_s
    expect(log).to match(/name/)
    expect(log).to match(/创建/)
  end
end