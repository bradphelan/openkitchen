class HomeController < ApplicationController
  skip_before_filter :authenticate_user!

  def show
    @video="26569110"
    #@video="23264180" # openkitchen
  end
end
