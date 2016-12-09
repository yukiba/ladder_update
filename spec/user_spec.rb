require 'spec_helper'
require 'rails_helper'
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
    s.save rescue nil
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

describe 'all users cache' do

  dingtalk_users = [Dingtalk::UserInfo.new({"name" => "xxx", "userid" => "1"}),
                    Dingtalk::UserInfo.new({"name" => "yyy", "userid" => "2"}),
                    Dingtalk::UserInfo.new({"name" => "zzz", "userid" => "3"})]

  it 'cache correct' do
    User.delete_all
    User.update_all(dingtalk_users)
    expect(User.send(:find_all_users_with_cache).length).to eql(dingtalk_users.length)
    new_users = User.new("aaa", "4")
    new_users.save
    expect(User.send(:find_all_users_with_cache).length).to eql(dingtalk_users.length + 1)
    new_users.delete
    expect(User.send(:find_all_users_with_cache).length).to eql(dingtalk_users.length + 1)
    expect(User.send(:find_all_users_with_cache, true).length).to eql(dingtalk_users.length)
  end
end

describe 'main page' do

  User.delete_all
  aaa = User.new("aaa", "1")
  aaa.valid_in_dingtalk = false
  aaa.save
  bbb = User.new("bbb", "2")
  bbb.visible = false
  bbb.save
  ccc = User.new("ccc", "3")
  ccc.save
  ddd = User.new("ddd", "4")
  ddd.save
  users = User.find_all_users_for_main_page

  it 'count correct' do
    expect(users.length).to eql(2)
  end

  it 'property correct' do
    users.each do |u|
      expect(u).to have_key(:name)
      expect(u).to have_key(:score)
    end
  end
end

describe 'find user' do

  it 'find correct user' do
    User.delete_all
    u = User.new('aaa', '123')
    u.save
    s = User.find_user_by_dingtalk_id(u.dingtalk_id)
    expect(s.dingtalk_id).to eql(u.dingtalk_id)
    t = User.find_user_by_dingtalk_id(u.dingtalk_id + '123')
    expect(t).to be nil
  end
end