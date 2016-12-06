Rails.application.routes.draw do
  root 'ladder#index'

  get '/admin/sync', to: 'admin#sync_dingtalk_users'
  # post '/admin/ticket', to: 'admin#query_jsapi_ticket'

  get '/ladder/scores', to: 'ladder#realtime_score'

  get '/user', to: 'user#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
