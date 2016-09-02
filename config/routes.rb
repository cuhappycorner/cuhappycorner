Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'corner/users/activations' => 'corner/users/activations#index'
  post 'corner/users/activations' => 'corner/users/activations#show'
  put 'corner/users/activations' => 'corner/users/activations#update'
end
