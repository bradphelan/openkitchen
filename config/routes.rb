Gobbq::Application.routes.draw do

  root :to => 'home#show'

  # This is here till issue https://github.com/apotonick/apotomo/issues/67 is fixed
  match ":controller/:id/render_event_response", :to => "#render_event_response", :as => "apotomo_event"

  resources :resource_producers

  resources :resources

  resources :users, :only => [] do
    resource :profile, :only => [:edit, :show, :update]
  end

  resources :events do
    member do
      post :invite, :controller => :events, :action => :invite
      get  :ical, :controller => :events, :action => :ical
    end
  end

  resources :invitations do
    collection do
      get 'token/:id', :action => :token, :as => :token
    end
    member do
      post 'mail', :action => :mail, :as => :mail
    end
  end


  match "home" => "home#show"


  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", 
    :passwords => "passwords",
    :registrations => "registrations"
  }
  

  # Complete the registration
  match "/users/register", :method => :post, :controller => :users, :action => :register

end
