class ImageCarouselWidget < ApplicationWidget

  responds_to_event :delete_image
  responds_to_event :upload

  has_widgets do |root|
    @assetable = options[:assetable]
    @resource = options[:resource]
    load_images
  end

  def load_images
    @images = @assetable.send(@resource).order("created_at DESC").where{terminated==false}
  end

  def display
    render
  end

  def filmstrip
    render
  end

  def delete_image(evt)
    @image = Asset.find(evt[:asset_id])
    authorize! :edit, @image.assetable
    @image.background_destroy
    load_images

    @assetable.send(@resource).build
    render_buffer do |b|
      b.render :text => %Q%
        $(".carousel_nav").data("widget").rmActive();
      %
    end
  end

  def upload(evt)
    authorize! :edit, @assetable
    image = @assetable.send(@resource).create evt[@resource.to_sym]
    render_buffer do |b|
      b.prepend "##{widget_id} .strip", :view => "thumb", :locals => { :image => image }
      b.prepend "##{widget_id} .carousel-inner", :view => "item", :locals => { :image => image }
      b.render :text => %Q%
        $(".carousel_nav").data("widget").fixCarousel();
      %
    end
  end

end
