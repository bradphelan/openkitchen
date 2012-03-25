class PublicEventsWidget < ApplicationWidget

  responds_to_event :refresh
  responds_to_event :refresh_html5_geolocation

  has_widgets do
    @require_html5_geolocate = true
    @public = options[:public]
    @geolocate = options[:geolocate]
    @title = t("public_events.display.#{options[:title]}")

    # Create default relation
    @events = ::Event.where{}

    @past = params[:past]

    if @geolocate
      if params[:latitude] and params[:longitude]
        @address = Geocoder.search([params[:latitude], params[:longitude]]).first
        @require_html5_geolocate = false
      elsif @city = params[:city] || session[:city]
        @address = Geocoder.search(@city).first
        @require_html5_geolocate = false
      else
        unless @address = request.location
          @address = Geocoder.search "Vienna"
        end
      end

      @radius = params[:radius] || session[:radius] || 100


      if @address
        @events = @events.near([@address.latitude, @address.longitude], @radius)
        
        # For some reason a search on Tokyo return a result object
        # with city => nil, state => 'tokyo'
        @city = @address.city || @address.state || @address.country
      end

      session[:city]=@city
      session[:radius]=@radius
    end

    @events = self.instance_exec @events, &options[:filter] if options[:filter]
    if @past
      @events = @events.where{datetime < Time.zone.now  }
    else
      # Events might run for a day
      @events = @events.where{datetime > (Time.zone.now - 1.day) }
    end

  end
  
  def setup_geolocate
  end

  def display
    render
  end

  def refresh_html5_geolocation
    authorize! :refresh, PublicEventsWidget
    session[:city]=nil
    @require_html5_geolocate=true
    @city = nil
    @events = []
    replace "##{widget_id}", :view => :display
  end

  def refresh
    authorize! :refresh, PublicEventsWidget
    replace "##{widget_id}", :view => :display
  end

end
