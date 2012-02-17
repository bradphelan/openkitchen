class ProfilesController < ApplicationController
   

  def edit
    @user = User.find(params[:user_id])
    @profile = @user.profile
    authorize! :edit, @profile
  end
  
  def show
  end

  def update
    @user = User.find(params[:user_id])
    @profile = @user.profile
    authorize! :update, @profile
    @profile.update_attributes(params[:profile])
    redirect_to edit_user_profile_path(@user)
    
  end

end
