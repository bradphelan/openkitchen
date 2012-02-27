class ConfirmationsController < Devise::ConfirmationsController
  def show
    @user = User.find_by_confirmation_token(params[:confirmation_token])
    if !@user.present?
      self.resource = @user
      render :action => "new"
    end
  end

  # This method is called from the button where the user
  # can force another email to confirm the account
  #
  def complete_registration
    User.send_confirmation_instructions(params[:user])
    flash[:info] = t 'devise.confirmations.send_instructions'
    redirect_to :back
  end

  def confirm_user
    @user = User.find_by_confirmation_token(params[:user][:confirmation_token])
    if @user.update_attributes(params[:user]) and @user.password_match?
      @user = User.confirm_by_token(@user.confirmation_token)
      set_flash_message :notice, :confirmed      
      sign_in_and_redirect("user", @user)
    else
      render :action => "show"
    end
  end

end

