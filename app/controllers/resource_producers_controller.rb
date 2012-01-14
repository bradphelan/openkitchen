class ResourceProducersController < ApplicationController

  respond_to :html, :js

  check_authorization

  def create

    @resource_producer = ResourceProducer.where{
      invitation_id==my{params[:resource_producer][:invitation_id]} && 
      resource_id==my{params[:resource_producer][:resource_id]}
    }.first

    case params[:commit]
    when "+ 5"
      delta = 5
    when "+ 1"
      delta = 1
    when "- 1"
      delta = -1
    when "- 5"
      delta = -5
    end

    unless @resource_producer
      @resource_producer = ResourceProducer.create params[:resource_producer]
    end

    authorize! :create, @resource_producer

    @invitation = @resource_producer.invitation
    @resource = @resource_producer.resource

    if @resource.quantity_remaining_to_be_allocated - delta >= 0 || delta < 0

      @resource_producer.quantity ||= 0
      @resource_producer.quantity += delta
      # TODO move to model
      @resource_producer.quantity = [0, @resource_producer.quantity].max
      @resource_producer.save!

      # This needs to be reloaded because
      # @resource.quantity_remaining_to_be_allocated gets
      # cached
      @resource.reload
    end

    respond_to do |format|
      format.js do |format|
        render "resources/resource", :layout => false, :content_type => 'text/javascript'
      end
    end
  end
end
