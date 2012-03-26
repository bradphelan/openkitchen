class VenuesController < ApplicationController
  load_and_authorize_resource
  respond_to :html

  skip_authorize_resource :only => :render_event_response

  has_widgets do |root|
    if params[:id]
      root << widget(:image_carousel, :venue_images, :assetable => @venue, :resource => :venue_images)
    end
  end

  def create
    @venue = current_user.venues.create params[:venue]
    authorize! :create, @venue
    @venue.save
    respond_with @venue, :location => edit_venue_path(@venue)
  end

  def edit
    @map = GoogleStaticMap.new(:zoom => 13, :center => @venue.map_location)
    @map.markers << MapMarker.new(:color => "blue", :location => @venue.map_location)

    # We only want one image at the moment in the nested form
    @venue.venue_images.build
  end

  def update
    @venue.update_attributes params[:venue]
    respond_with @venue, :location => edit_venue_path(@venue)
  end

  def show
    @map = GoogleStaticMap.new(:zoom => 13, :center => @venue.map_location)
    @map.markers << MapMarker.new(:color => "blue", :location => @venue.map_location)
  end

end
