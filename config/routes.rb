Gobbq::Application.routes.draw do

  root :to => 'home#show'

  resources :resource_producers

  resources :resources

  resources :events

  resources :invitations do
    collection do
      get 'token/:id', :action => :token, :as => :token
    end
    member do
      post 'mail', :action => :mail, :as => :mail
    end
  end

  resources :events do
    member do
      post :invite, :controller => :events, :action => :invite
    end
  end

  match "home" => "home#show"


  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", 
    :passwords => "passwords"
  }
  

  # Complete the registration
  match "/users/register", :method => :post, :controller => :users, :action => :register

end
