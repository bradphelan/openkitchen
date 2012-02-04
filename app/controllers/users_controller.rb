class UsersController < ApplicationController

  def register
    authorize! :register, current_user
    current_user.send_reset_password_instructions
    sign_out current_user
    flash[:info] = "(Re)setting your password is required for completing registration. Instructions have been emailed to you. Once you complete the the password (re)set then you will be registered and can add events. You have been signed out to perform this action"
    flash.keep
    redirect_to :root
  end
end
