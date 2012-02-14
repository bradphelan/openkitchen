class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!

  # Don't let controllers get away with 
  # any monkey business
  check_authorization :unless => :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.error exception
    redirect_to root_url, :alert => exception.message
  end

end
