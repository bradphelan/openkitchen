class VenueImagesController < ApplicationController
  load_and_authorize_resource :only => :destroy
  respond_to :html

  def create
    @venue_image = VenueImage.new params[:venue_image]
    authorize! :create, @venue_image
    if @venue_image.save
      respond_with @venue_image, :location => edit_venue_path(@venue_image.venue)
    else
      flash[:error] = "Error attaching image"
      redirect_to edit_venue_path(@venue_image.venue)
    end
  end

  def destroy
    @venue_image.destroy
    respond_with @venue_image, :location => edit_venue_path(@venue_image.venue)
  end
end
