require 'spec_helper'
require_relative '../config/environment'

describe 'appove and decline' do

  User.delete_all
  Grade.delete_all
  name = 'test_name'
  dingtalk_id = 'test_dingtalk_id'
  u = User.new(name, dingtalk_id)
  u.save
  g = Grade.new(dingtalk_id, -10, 'test_grade')
  g.save

  it 'grade init' do

    expect(g.status).to eql(Grade::STATUS_APPROVING)
  end

  it 'decline correct' do

    u.score = 100
    g.decline
    expect(g.status).to eql(Grade::STATUS_DECLINE)
    expect(u.score).to eql(100)
  end

  it 'appove correct' do
    
    u.score = 100
    g.appove
    expect(g.status).to eql(Grade::STATUS_APPROVED)
    expect(u.score).to eql(100)
  end
end