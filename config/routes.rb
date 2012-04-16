Hsm::Application.routes.draw do

  namespace :admin do
    root :to => 'home#admin'
    resources :roles
    resources :users
    resource :settings
  end

  devise_for :users #, :controllers => {:registrations => "registrations"}

  match 'users',     :to => 'users#index'
  match 'users/:id', :to => 'users#show', :as => "user"

  resource :home

  root :to => 'home#index'

  match 'newsfeed', :to => 'newsfeed#index'

end
