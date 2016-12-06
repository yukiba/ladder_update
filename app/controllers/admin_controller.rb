class AdminController < ApplicationController

  # 同步钉钉用户
  def sync_dingtalk_users
    head :ok

    server = Dingtalk::Server.new(Dingtalk.corpid, Dingtalk.corpsecret)
    all_users = server.query_all_users
    User.update_all(all_users)
  end

  # 获取jsapi_ticket用于加密
  # def query_jsapi_ticket
  #   server = Dingtalk::Server.new(Dingtalk.corpid, Dingtalk.corpsecret)
  #   ticket = server.query_jsapi_ticket
  #   result = {}
  #   if ticket.nil?
  #     result[:status] = 'error'
  #   else
  #     result[:status] = 'ok'
  #     result[:ticket] = ticket
  #   end
  #   render json: result
  # end
end
