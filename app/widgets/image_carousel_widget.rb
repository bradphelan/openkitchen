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
    authorize! :upload_image_for, @assetable
    image = @assetable.send(@resource).create evt[@resource.to_sym]
    if image.valid?
      render_buffer do |b|
        b.prepend "##{widget_id} .strip", :view => "thumb", :locals => { :image => image }
        b.prepend "##{widget_id} .carousel-inner", :view => "item", :locals => { :image => image }
        b.render :text => %Q%
          $(".carousel_nav").data("widget").fixCarousel();
        %
      end
    else
      render_buffer do |b|
        js = image.errors.full_messages.map do |msg|
          %Q%
            alert("#{msg}");
          %
        end
        b.render :text => js.join
      end
    end
  end

end
