# A BaseWidget to apply stuff to widgets across
# the board. All widgets should inherit from this
class ApplicationWidget < Apotomo::Widget
  include ActionController::RecordIdentifier # so I can use `dom_id`
  include Devise::Controllers::Helpers # if you use devise
  include ::ActionView::Helpers::JavaScriptHelper

  helper_method :current_user # so I can call current_user in the views of my widgets
  helper_method :current_site # so I can call current_site in the view of my widgets
  helper ::ApplicationHelper

  after_initialize :setup!

  def escape(js)
    escape_javascript(js)
  end

  private

  def setup!(*)
  end

  def current_ability
    ::Ability.new current_user
  end

  def authorize! *args
    parent_controller.authorize! *args
  end

  def can?(action, object)
    current_ability.can? action, object
  end
  helper_method :can?

  def cannot?(action, object)
    current_ability.cannot? action, object
  end
  helper_method :cannot?

  #
  # View building helpers
  #

  #
  # This is equivalent to defining
  # a widget and rendering it in one pass.
  # Really only usefull in event callbacks
  # where you need to generate a new
  # item to add to a list.
  #
  #
  def render_widget!(type, id, *args)
    self << widget(type, id, *args)
    render_widget id, :display
  end

  def render_widget_for_js!(type, id, *args)
    escape render_widget!(type, id, *args)
  end

end
