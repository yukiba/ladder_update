Rails.application.routes.draw do
  root 'ladder#index'

  get '/admin/sync', to: 'admin#sync_dingtalk_users'
  # post '/admin/ticket', to: 'admin#query_jsapi_ticket'
  post '/admin/jsapiconfig', to: 'admin#request_jsapi_config'

  get '/ladder/scores', to: 'ladder#realtime_score'

  get '/user', to: 'user#index'
  get '/user/:user_id', to: 'user#request_grade'
  post '/user/:user_id/post', to: 'user#add_grade'
  get '/user/:user_id/grades/waiting', to: 'user#waiting_grades'
  post '/user/:user_id/grades/waiting/post', to: 'user#waiting_grades_data'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
