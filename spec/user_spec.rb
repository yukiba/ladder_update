require 'spec_helper'
require_relative '../config/environment'

describe 'name & dingtalk_id' do

  it 'save correct' do

    name = 'test_name'
    dingtalk_id = 'test_dingtalk_id'
    u = User.where(dingtalk_id: dingtalk_id).first
    u.delete unless u.nil?

    u = User.new(name, dingtalk_id)
    u.save
    result = User.where(dingtalk_id: dingtalk_id).first
    expect(result).not_to be nil
  end

  it 'unique index valid' do

    name = 'test_name'
    dingtalk_id = 'test_dingtalk_id'
    u = User.where(dingtalk_id: dingtalk_id).first
    u.delete unless u.nil?

    u = User.new(name, dingtalk_id)
    u.save
    s = User.new(name, dingtalk_id)
    s.save
    count = User.where(dingtalk_id: dingtalk_id).count
    expect(count).eql? 1
  end
end

describe 'update all' do

  it 'insert correct when db empty' do

    User.delete_all
    dingtalk_users = [Dingtalk::UserInfo.new({"name" => "xxx", "userid" => "1"}),
                      Dingtalk::UserInfo.new({"name" => "yyy", "userid" => "2"}),
                      Dingtalk::UserInfo.new({"name" => "zzz", "userid" => "3"})]
    User.update_all(dingtalk_users)
    expect(User.all.count).eql?(dingtalk_users.length)
  end

  it 'merge correct when db not empty' do
    User.delete_all
    db_users = [Dingtalk::UserInfo.new({"name" => "xxx", "userid" => "1"}),
                Dingtalk::UserInfo.new({"name" => "yyy", "userid" => "2"}),
                Dingtalk::UserInfo.new({"name" => "zzz", "userid" => "3"}),
                Dingtalk::UserInfo.new({"name" => "zzz", "userid" => "0"})]
    User.update_all(db_users)

    dingtalk_users = [Dingtalk::UserInfo.new({"name" => "xxx", "userid" => "1"}),
                      Dingtalk::UserInfo.new({"name" => "aaa", "userid" => "4"})]
    User.update_all(dingtalk_users)
    expect(User.all.count).to eql(5)
    expect(User.where(valid_in_dingtalk: true).count).to eql(2)
  end
end