class ProfilesController < ApplicationController
   
  respond_to :html
  


  def edit
    @user = User.find(params[:user_id])
    authorize! :edit, @user
  end
  
  def show
    @user = User.find(params[:user_id])
    authorize! :show, @user
  end

  def update
    @user = User.find(params[:user_id])

    authorize! :update, @user
    @user.transaction do
      @user.update_attributes(params[:user])
#       if avatar_params = params[:user][:avatar]
#         @user.build_assetable_asset do |aa|
#           aa.asset = ImageAsset.new avatar_params        
#         end
#         @user.save!
#       end
    end
    respond_with @user, :location => edit_user_profile_path(@user)
    
  end

end
