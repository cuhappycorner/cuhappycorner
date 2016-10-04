Rails.application.routes.draw do

  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'bank/account#index'

  get 'bank/account' => 'bank/account#show'

  # get 'register_success' => 'custom_registration#finish_registration'

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
end
