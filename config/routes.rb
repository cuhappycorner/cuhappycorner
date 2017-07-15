Rails.application.routes.draw do
  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  use_doorkeeper

  namespace :api do
    namespace :v1 do
      get '/me' => 'credentials#me'
      get '/account_number' => 'account#account_number'
      get '/account_balance' => 'account#account_balance'
      get '/account_number/:cuid' => 'account#account_number_from_cuid'
      post '/create_payment' => 'account#create_payment'
      get '/check_payment_paid/:id' => 'account#check_payment_paid'
    end
  end

  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions', passwords: 'users/passwords' }

  get 'payment/:id' => 'bank/third_party_payment#show'
  post 'payment/:id' => 'bank/third_party_payment#pay'

  get 'intranet/sso' => 'api/intranet_sso#sso'
  get 'users/check_email' => 'user#check_email'
  get 'users/check_email2' => 'user#check_email2'
  get 'users/check_cuid' => 'user#check_cuid'
  get 'users/check_cu_link_id' => 'user#check_cu_link_id'
  get 'users/check_activated' => 'user#check_activated'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'bank/account#index'

  get 'corner/account/project' => 'corner/account/project#index'

  get 'bank/transfer' => 'bank/transfer#index'
  post 'bank/transfer/transfer' => 'bank/transfer#transfer'
  match 'bank/transfer/get_sender_info' => 'bank/transfer#get_sender_info', via: [:get, :put, :post]
  match 'bank/transfer/get_recipient_info' => 'bank/transfer#get_recipient_info', via: [:get, :put, :post]

  get 'corner/users/shopkeeper' => 'corner/users/shopkeeper#index'
  post 'corner/users/shopkeeper/distribute' => 'corner/users/shopkeeper#distribute'
  post 'corner/users/shopkeeper/distribute/export' => 'corner/users/shopkeeper#export_data'
  match 'corner/users/shopkeeper/get_user_info' => 'corner/users/shopkeeper#get_user_info', via: [:get, :put, :post]

  get 'corner/account/payment' => 'corner/account/payment#index'
  post 'corner/account/payment/pay' => 'corner/account/payment#pay'
  match 'corner/account/payment/get_user_info' => 'corner/account/payment#get_user_info', via: [:get, :put, :post]
  match 'corner/account/payment/get_project_info' => 'corner/account/payment#get_project_info', via: [:get, :put, :post]

  get 'corner/account/collection' => 'corner/account/collection#index'
  post 'corner/account/collection/collect' => 'corner/account/collection#collect'
  match 'corner/account/collection/get_info' => 'corner/account/collection#get_info', via: [:get, :put, :post]

  get 'corner/users/change_card' => 'corner/users/change_card#index'
  put 'corner/users/change_card/update' => 'corner/users/change_card#update'
  match 'corner/users/change_card/get_info' => 'corner/users/change_card#get_info', via: [:get, :put, :post]

  get 'corner/users/management' => 'corner/users/management#index'
  get 'corner/users/management/:id/edit' => 'corner/users/management#edit'
  put 'corner/users/management/:id/edit' => 'corner/users/management#update'

  get 'corner/users/activations' => 'corner/users/activations#index'
  post 'corner/users/activations' => 'corner/users/activations#show'
  put 'corner/users/activations' => 'corner/users/activations#update'

  get 'bank/organizational_loan' => 'bank/organizational_loan#index'
  match 'bank/organizational_loan/new' => 'bank/organizational_loan#new', via: [:get, :post]
  post 'bank/organizational_loan/create' => 'bank/organizational_loan#create'

  get 'banker/organizational_loan' => 'banker/organizational_loan#index'
  get 'banker/organizational_loan/view' => 'banker/organizational_loan#show'
  match 'banker/organizational_loan/update' => 'banker/organizational_loan#update', via: [:put, :post]

  get 'corner/pos/sem_start_market' => 'corner/pos/sem_start_market#index'
  post 'corner/pos/sem_start_market/create' => 'corner/pos/sem_start_market#create'
  match 'corner/pos/sem_start_market/get_user_status' => 'corner/pos/sem_start_market#get_user_status', via: [:get, :put, :post]


  get 'corner/pos/second_hand_good' => 'corner/pos/second_hand_good#index'
  get 'corner/pos/second_hand_good/c/new' => 'corner/pos/second_hand_good#c_new'
  post 'corner/pos/second_hand_good/c/new' => 'corner/pos/second_hand_good#c_create'
  get 'corner/pos/second_hand_good/c/:category/edit' => 'corner/pos/second_hand_good#c_edit'
  put 'corner/pos/second_hand_good/c/:category/edit' => 'corner/pos/second_hand_good#c_update'
  get 'corner/pos/second_hand_good/c/:category/show' => 'corner/pos/second_hand_good#c_show'
  get 'corner/pos/second_hand_good/g/new' => 'corner/pos/second_hand_good#g_new'
  post 'corner/pos/second_hand_good/g/new' => 'corner/pos/second_hand_good#g_create'
  get 'corner/pos/second_hand_good/g/:good/edit' => 'corner/pos/second_hand_good#g_edit'
  put 'corner/pos/second_hand_good/g/:good/edit' => 'corner/pos/second_hand_good#g_update'

  get 'corner/pos/second_hand_good_transaction' => 'corner/pos/second_hand_good_transaction#index'
  post 'corner/pos/second_hand_good_transaction/new' => 'corner/pos/second_hand_good_transaction#new'
  post 'corner/pos/second_hand_good_transaction/create' => 'corner/pos/second_hand_good_transaction#create'
  match 'corner/pos/second_hand_good_transaction/get_price' => 'corner/pos/second_hand_good_transaction#get_price', via: [:get, :put, :post]

  get 'corner/pos/second_hand_good_stat' => 'corner/pos/second_hand_good_stat#index'
  post 'corner/pos/second_hand_good_stat/show' => 'corner/pos/second_hand_good_stat#show'
  post 'corner/pos/second_hand_good_stat/export' => 'corner/pos/second_hand_good_stat#export_data'

  match 'corner/loan' => 'corner/loan/loan#index', via: [:get, :put, :post]
  match 'corner/loan/show' => 'corner/loan/loan#show', via: [:get, :put, :post]
  match 'corner/loan/create' => 'corner/loan/loan#create', via: [:get, :put, :post]
  match 'corner/loan/update' => 'corner/loan/loan#update', via: [:get, :put, :post]
  match 'corner/loan/kill' => 'corner/loan/loan#kill_debt', via: [:get, :put, :post]
  match 'corner/loan/export' => 'corner/loan/loan#export_data', via: [:get, :put, :post]

  get 'corner/users/new_guest' => 'corner/users/new_guest#index'
  post 'corner/users/new_guest/create' => 'corner/users/new_guest#create'

  authenticate :user, lambda { |u| u.role.include? Role.find_by(name:"admin")} do
    mount Sidekiq::Web => '/sidekiq'
  end
end
