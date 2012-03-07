class ProfilesController < ApplicationController
   
  respond_to :html

  def edit
    @user = User.find(params[:user_id])
    authorize! :edit, @user
  end
  
  def show
  end

  def update
    @user = User.find(params[:user_id])
    authorize! :update, @user
    @user.update_attributes(params[:user])
    respond_with @user, :location => edit_user_profile_path(@user)
    
  end

end
