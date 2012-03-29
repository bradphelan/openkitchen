# A BaseWidget to apply stuff to widgets across
# the board. All widgets should inherit from this
class ApplicationWidget < Apotomo::Widget
  include ActionController::RecordIdentifier # so I can use `dom_id`
  include Devise::Controllers::Helpers # if you use devise
  include ::ActionView::Helpers::JavaScriptHelper

  helper_method :current_user # so I can call current_user in the views of my widgets
  helper_method :signed_in?

  helper_method :current_site # so I can call current_site in the view of my widgets
  helper ::ApplicationHelper

  after_initialize :setup!

  def escape(js)
    escape_javascript(js)
  end

  private

  def setup!(*)
  end


  def stateful_options
    options.select do |k,v|
      v.is_a? Apotomo::StatefulOption 
    end
  end
  helper_method :stateful_options

  def options
    unless @options_with_state
      @options_with_state = super
      if params[:state]
        if params[:state][widget_id]
          @state = params[:state][widget_id].each do |k,v|
            # The stateful options need to be marked as stateful
            @options_with_state[k.to_sym] = Apotomo::StatefulOption.new(v)
          end
        end
      end
    end
    @options_with_state
  end

  # Make sure that all id or *_id parameters
  # are forwarded to the event URL so that 
  # resources are recovered correctly when 
  # the event is executed.
  def url_for_event type, opts={}
    p = HashWithIndifferentAccess.new
    parent_controller.request.parameters.each do |k,v|
      if k.end_with? "_id" or k == "id"
        p[k] = v
      end
    end

    super type, p.merge(opts)
  end

  def current_ability
    parent_controller.current_ability
  end

  def flash
    parent_controller.flash
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

  def redirect_to path
    render :text => "window.location = '#{path}'"
  end


  class WidgetRenderBuffer
    def initialize w
      @widget = w
      @buffer = ""
    end

    def method_missing *args
      @buffer << @widget.send(*args)
    end

    def to_s
      @buffer
    end
  end

  def render_buffer
    buffer = WidgetRenderBuffer.new self
    yield buffer
    buffer.to_s
  end


end

module Apotomo::Rails::ViewHelper
  def widget_tag(tag, options={}, &block)
    if options[:class]
      options[:class] = "#{options[:class]} widget"
      options['data-state'] = stateful_options.to_json
    else
      options[:class] = "widget"
    end

    options.reverse_merge!(:id => widget_id) 
    content_tag(tag, options, &block)
  end

  def widget_div(options={}, &block)
    widget_tag "div", options, &block
  end

end


module Apotomo
  module JavascriptMethods
    def append(*args)
      wrap_in_javascript_for(:append, *args)
    end
    def prepend(*args)
      wrap_in_javascript_for(:prepend, *args)
    end
  end
  class JavascriptGenerator
    module Jquery
      def append(id, markup)
        %Q%
        #{element(id)}.append("#{escape(markup)}");
        %
      end
      def prepend(id, markup)
        %Q%
        #{element(id)}.prepend("#{escape(markup)}");
        %
      end
    end
  end
end
