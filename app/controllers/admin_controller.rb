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

  # 请求jsapi_config
  # def request_jsapi_config
  #   params_url = params[:url] || ''
  #   url = Base64.decode64(params_url)
  #   server = Dingtalk::Server.new(Dingtalk.corpid, Dingtalk.corpsecret)
  #   config = server.create_jsapi_config(url)
  #   result = {}
  #   if config.nil?
  #     result[:status] = 'error'
  #     result[:config] = {}
  #   else
  #     result[:status] = 'OK'
  #     result[:config] = config
  #   end
  #   render json: result
  # end

  # 返回grade所有可能的状态
  def grade_all_status
    render json: Grade.all_status
  end
end
