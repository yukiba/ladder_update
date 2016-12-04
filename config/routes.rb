Rails.application.routes.draw do
  root 'ladder#index'

  get '/admin/sync', to: 'admin#sync_dingtalk_users'

  get '/ladder/scores', to: 'ladder#realtime_score'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
