class ImageCarouselWidget < ApplicationWidget

  responds_to_event :delete_image
  responds_to_event :upload

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

  def upload(evt)
    authorize! :edit, @assetable
    @assetable.send(@resource).create evt[@resource.to_sym]
    render_buffer do |b|
      b.replace "##{widget_id} .carousel_nav", :view => :carousel
      b.replace "##{widget_id} .form", :view => :form
    end
  end

end
