Rails.application.routes.draw do
  devise_for :users, skip: [:sessions], controllers: { cas_sessions: 'our_cas_sessions' }
  devise_scope :user do
    get "sign_in", to: "devise/cas_sessions#new"
    delete "sign_out", to: "devise/cas_sessions#destroy"
  end

  root to: 'home#index'

  mount RuCaptcha::Engine => '/rucaptcha'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
