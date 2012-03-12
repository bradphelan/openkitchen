class PublicEventsWidget < ApplicationWidget

  responds_to_event :refresh

  has_widgets do
    params = options[:params]
    @geolocate = true

    if params[:latitude] and params[:longitude]
      @address = Geocoder.search([params[:latitude], params[:longitude]]).first
    elsif @city = params[:city] || session[:city]
      @address = Geocoder.search(@city).first
      @geolocate = false
    else
      @address = request.location
    end

    @radius = params[:radius] || session[:radius] || 100

    session[:city]=@city
    session[:radius]=@radius

    Rails.logger.info [@address.city, @address.country].join(', ')

    if @address
      @public_events = ::Event.near([@address.latitude, @address.longitude], @radius)
    end

    # For some reason a search on Tokyo return a result object
    # with city => nil, state => 'tokyo'
    @city = @address.city || @address.state || @address.country
  end

  def display
    render
  end

  def refresh
    authorize! :refresh, PublicEventsWidget
    replace "##{widget_id}", :view => :display
  end

end
