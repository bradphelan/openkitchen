class HomeController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_authorization_check :only => :show

  def show
    @video="26569110"
    #@video="23264180" # openkitchen
  end
end
