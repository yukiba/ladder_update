Rails.configuration.to_prepare do

  Dingtalk.corpid = ENV['SJTUDOIT_DINGTALK_CORPID']
  Dingtalk.corpsecret = ENV['SJTUDOIT_DINGTALK_CORPSECRET']

  if Dingtalk.corpid.nil? || Dingtalk.corpsecret.nil?
    raise Exception, 'plz set ding talk key and secret'
  end
end