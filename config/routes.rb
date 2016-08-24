Rails.application.routes.draw do

  root to: 'home#index'

  devise_for :users, skip: [:sessions], controllers: {cas_sessions: 'our_cas_sessions'}
  devise_scope :user do
    get "sign_in", to: "devise/cas_sessions#new"
    delete "sign_out", to: "devise/cas_sessions#destroy"
  end

  mount RuCaptcha::Engine => '/rucaptcha'

  # -----------------------------------------------------------
  # Admin
  # -----------------------------------------------------------

  get '/admin/' => 'admin#index'

  namespace :admin do |admin|

    resources :accounts, only: [:new, :index, :create, :destroy] do
      collection do
        get :change_password
        post :change_password_post
      end
    end
    resources :admins
  end

  get 'user' => redirect('/user/preview')

end
