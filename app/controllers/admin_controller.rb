class AdminController < ApplicationController

  # 同步钉钉用户
  def sync_dingtalk_users
    head :ok

    server = Dingtalk::Server.new(Dingtalk.corpid, Dingtalk.corpsecret)
    all_users = server.query_all_users
    User.update_all(all_users)
  end
end
