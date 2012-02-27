class UsersController < ApplicationController

  def register
    authorize! :register, current_user
    current_user.send_reset_password_instructions
    sign_out current_user
    flash[:info] = t('controllers.register.info') 
    flash.keep
    redirect_to :root
  end
end
