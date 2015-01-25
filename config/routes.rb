Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }

  as :user do
    get 'signin' => 'static_pages#root', :as => :new_user_session
    delete 'signout' => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  resources :assignments, except: :delete do
    member do
      post :assign
      post :check
    end
  end

  resources :teams, only: [:index, :show, :new, :create] do
    member do
      post :activate
    end
  end

  get  '/user/access_token' => 'github_access_token#edit'
  post '/user/access_token' => 'github_access_token#update'

  root to: 'static_pages#root'
end
