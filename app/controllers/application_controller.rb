class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!

  before_filter :configure_default_url_options!

  protected
  def configure_default_url_options!
    DefaultUrlOptions.configure!(request)
  end
  public


  before_filter :set_locale


  def set_locale
    I18n.locale = params[:locale] || session[:locale] || I18n.default_locale
    session[:locale] = I18n.locale
  end

  # Don't let controllers get away with 
  # any monkey business
  check_authorization :unless => :devise_controller?


  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.error exception
    redirect_to root_url, :alert => exception.message
  end

end
