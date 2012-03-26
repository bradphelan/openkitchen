class ImageCarouselWidget < ApplicationWidget

  responds_to_event :delete_image

  has_widgets do |root|
    @images = options[:images]
    @assetable = options[:assetable]
    @resource = options[:resource]
    @images = @assetable.send @resource
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
    @image.destroy
    @images.reload

    @assetable.send(@resource).build
    render_buffer do |b|
      b.replace "##{widget_id} .carousel_nav", :view => :carousel
      b.replace "##{widget_id} .form", :view => :form
    end
  end

end
