class PublicEventsWidget < ApplicationWidget

  responds_to_event :refresh

  has_widgets do
    @refresh_on_geolocate = true
    @public = options[:public]
    @geolocate = options[:geolocate]
    @title = t("public_events.display.#{options[:title]}")

    # Create default relation
    @events = ::Event.where{}

    if @geolocate
      if params[:latitude] and params[:longitude]
        @address = Geocoder.search([params[:latitude], params[:longitude]]).first
      elsif @city = params[:city] || session[:city]
        @address = Geocoder.search(@city).first
        @refresh_on_geolocate = false
      else
        unless @address = request.location
          @address = Geocoder.search "Vienna"
        end
      end

      @radius = params[:radius] || session[:radius] || 100

      session[:city]=@city
      session[:radius]=@radius

      if @address
        @events = @events.near([@address.latitude, @address.longitude], @radius)
        
        # For some reason a search on Tokyo return a result object
        # with city => nil, state => 'tokyo'
        @city = @address.city || @address.state || @address.country
      end
    end

    @events = self.instance_exec @events, &options[:filter] if options[:filter]

  end

  def display
    render
  end

  def refresh
    authorize! :refresh, PublicEventsWidget
    replace "##{widget_id}", :view => :display
  end

end
