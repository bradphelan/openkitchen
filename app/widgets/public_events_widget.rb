class PublicEventsWidget < ApplicationWidget

  responds_to_event :refresh

  has_widgets do
    params = options[:params]

    if params[:latitude] and params[:longitude]
      @address = Geocoder.search([params[:latitude], params[:longitude]]).first
    else
      @address = request.location
    end

    @radius = params[:radius] || 100

    if @address
      @public_events = ::Event.near([@address.latitude, @address.longitude], @radius)
    end
  end

  def display
    render
  end

  def refresh
    authorize! :refresh, PublicEventsWidget
    replace "##{widget_id}", :view => :display
  end

end
