class VenuesController < ApplicationController
  load_and_authorize_resource
  respond_to :html

  def create
    @venue = current_user.venues.create params[:venue]
    authorize! :create, @venue
    @venue.save
    respond_with @venue, :location => edit_venue_path(@venue)
  end

  def edit
    @map = GoogleStaticMap.new(:zoom => 13, :center => @venue.map_location)
    @map.markers << MapMarker.new(:color => "blue", :location => @venue.map_location)
  end

  def update
    @venue.update_attributes params[:venue]
    respond_with @venue
  end

  def show
    @map = GoogleStaticMap.new(:zoom => 13, :center => @venue.map_location)
    @map.markers << MapMarker.new(:color => "blue", :location => @venue.map_location)
  end

end
