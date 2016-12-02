require 'spec_helper'
require_relative '../config/environment'

require 'dingtalk'

describe 'users' do

  let(:server) { Dingtalk::Server.new(Dingtalk.corpid, Dingtalk.corpsecret) }

  it 'query all users' do
    all_users = server.query_all_users
    expect(all_users).not_to be nil
  end
end