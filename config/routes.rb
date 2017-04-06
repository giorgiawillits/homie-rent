Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'expenses#index'

  resources :houses
  get '/houses/:id/add_landlord' => 'houses#add_landlord', as: :add_landlord
  get '/houses/:id/invite_user' => 'houses#invite_user', as: :invite_user
  post '/houses/join' => 'houses#join', as: :join_house

  resources :charges
  get '/charges/update_status/:id' => 'charges#update_status', as: :update_charge_status

  resources :expenses

  resources :users

  post '/twilio/reply'  => 'twilio#reply', as: :twilio_reply
  get '/twilio/send_reminders/:expense_id'  => 'twilio#send_reminders', as: :twilio_send_reminders

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]

  # FB messenger Bot
  mount Facebook::Messenger::Server, at: 'bot'
end
