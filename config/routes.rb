Rails.application.routes.draw do

  root to: 'home#index'

  devise_for :users, skip: [:sessions], controllers: {cas_sessions: 'our_cas_sessions'}
  devise_scope :user do
    get "sign_in", to: "auth/cas_sessions#new"
    delete "sign_out", to: "auth/cas_sessions#destroy"
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

  # -----------------------------------------------------------
  # User
  # -----------------------------------------------------------

  get 'user' => redirect('/user/index')
  get 'user/preview' => 'user#preview', as: 'user_preview'
  match 'user/profile' => 'user#profile', as: 'user_profile', via: [:get, :post]
  match 'user/passwd' => 'user#passwd', as: 'user_passwd', via: [:get, :post]
  match 'user/mobile' => 'user#mobile', as: 'user_mobile', via: [:get, :post]
  match 'user/email' => 'user#email', as: 'user_email', via: [:get, :post]
  match 'user/reset_mobile' => 'user#reset_mobile', as: 'user_reset_mobile', via: [:get, :post]
  match 'user/reset_email' => 'user#reset_email', as: 'user_reset_email', via: [:get, :post]

  match '*path', via: :all, to: 'home#error_404'

end
