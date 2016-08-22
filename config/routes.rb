Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :users, path: 'account', controllers: {
      sessions: 'users/sessions', registrations: 'users/registrations',
      confirmations: 'users/confirmations',
      passwords: 'users/passwords'
  }
  mount RuCaptcha::Engine => '/rucaptcha'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
