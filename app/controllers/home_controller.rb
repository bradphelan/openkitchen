class HomeController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_authorization_check :only => :show

  def show
    if Rails.env.development? or Rails.env.test?
      @video="26569110"
    else
      @video="23264180" # openkitchen
    end
  end
end
