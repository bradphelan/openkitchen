class HomeController < ApplicationController
  skip_before_filter :authenticate_user!

  def show
    if user_signed_in?
      # Push the flash to the next page
      flash.keep
      redirect_to events_path
    end
  end
end
