module EventsHelper
  def small_gmap data
    gmaps("markers" => {"data" => data}, 
          "map_options" => {:id => "small_map", 
            :container_class=> "small_map_container", 
            "processing" => "json", 
            "auto_adjust" => true, 
            "auto_zoom" => false, 
            "zoom" => 13, 
            "maxZoom" => 13, 
            "minZoom" => 13, 
            "draggable" => false, 
            "scrollwheel" => false,
            "mapTypeControl" => false, 
            "disableDoubleClickZoom" => true, 
            "disableDefaultUI" => true})
  end


  def email_typeahead form
    form.input :email, :label => 'email',  :as => :email, :input_html => { :value => "", :placeholder => "email address", "data-provide" => "typeahead", "data-source"=> current_user.friends_emails.to_json, :autocomplete => 'off' }
  end

end
