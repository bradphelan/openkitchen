require 'apotomo/stateful_option'

class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!

  before_filter :set_locale


  def set_locale
    I18n.locale = params[:locale] || session[:locale] || I18n.default_locale
    session[:locale] = I18n.locale
  end

  # Don't let controllers get away with 
  # any monkey business
  check_authorization :unless => :devise_controller?

  include SessionsHelper
  # Customize the Devise after_sign_in_path_for() for redirecct to previous page after login
  def after_sign_in_path_for(resource_or_scope)
    case resource_or_scope
    when :user, User
      store_location = session[:return_to]
      clear_stored_location
      (store_location.nil?) ? "/" : store_location.to_s
    else
      super
    end
  end


  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.error exception
    redirect_to root_url, :alert => exception.message
  end

end
