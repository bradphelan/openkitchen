module EventsHelper
  def small_gmap data
    gmaps("markers" => {"data" => data}, 
          "map_options" => {:id => "small_map", 
            :container_class=> "small_map_container", 
            "processing" => "json", 
            "auto_adjust" => true, 
            "auto_zoom" => false, 
            "scrollwheel" => false,
            "navigationControl" => false,
            "scaleControl" => false,
            "draggable" => false, 
            "zoomControl" => false,

            "zoom" => 13, 
            "maxZoom" => 13, 
            "minZoom" => 13, 
            "mapTypeControl" => false, 
            "disableDoubleClickZoom" => true, 
            "disableDefaultUI" => true})
  end

end
