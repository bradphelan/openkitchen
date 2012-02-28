class VenuesController < ApplicationController
  load_and_authorize_resource
  def edit
    @map = GoogleStaticMap.new(:zoom => 13, :center => @venue.map_location)
    @map.markers << MapMarker.new(:color => "blue", :location => @venue.map_location)
  end

  def update
    @venue.update_attributes params[:venue]
    redirect_to :action => :edit
  end

  def show
    @map = GoogleStaticMap.new(:zoom => 13, :center => @venue.map_location)
    @map.markers << MapMarker.new(:color => "blue", :location => @venue.map_location)
  end

end
