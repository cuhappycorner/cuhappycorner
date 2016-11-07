Rails.application.routes.draw do
  require 'sidekiq/web'
  require 'sidekiq/cron/web'

  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }

  get 'users/check_email' => 'user#check_email'
  get 'users/check_cuid' => 'user#check_cuid'
  get 'users/check_cu_link_id' => 'user#check_cu_link_id'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'bank/account#index'

  get 'corner/account/collection' => 'corner/account/collection#index'
  post 'corner/account/collection/collect' => 'corner/account/collection#collect'
  match 'corner/account/collection/get_info' => 'corner/account/collection#get_info', via: [:get, :put, :post]

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

  get 'corner/pos/second_hand_good_transaction' => 'corner/pos/second_hand_good_transaction#index'
  post 'corner/pos/second_hand_good_transaction/new' => 'corner/pos/second_hand_good_transaction#new'
  post 'corner/pos/second_hand_good_transaction/create' => 'corner/pos/second_hand_good_transaction#create'
  match 'corner/pos/second_hand_good_transaction/get_price' => 'corner/pos/second_hand_good_transaction#get_price', via: [:get, :put, :post]

  match 'corner/loan' => 'corner/loan/loan#index', via: [:get, :put, :post]
  match 'corner/loan/show' => 'corner/loan/loan#show', via: [:get, :put, :post]
  match 'corner/loan/create' => 'corner/loan/loan#create', via: [:get, :put, :post]
  match 'corner/loan/update' => 'corner/loan/loan#update', via: [:get, :put, :post]

  authenticate :user, lambda { |u| u.role.include? Role.find_by(name:"admin")} do
    mount Sidekiq::Web => '/sidekiq'
  end
end
