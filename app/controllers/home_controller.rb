class HomeController < ApplicationController
  def show
    if user_signed_in?
      # Push the flash to the next page
      flash.keep
      redirect_to events_path
    end
  end
end
