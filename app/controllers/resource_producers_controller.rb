class ResourceProducersController < ApplicationController

  respond_to :html, :js

  def create
    @resource_producer = ResourceProducer.where{
      invitation_id==my{params[:resource_producer][:invitation_id]} && 
      resource_id==my{params[:resource_producer][:resource_id]}
    }.first

    if @resource_producer
      @resource_producer.quantity = params[:resource_producer][:quantity]
      @resource_producer.save!
    else
      @resource_producer = ResourceProducer.create params[:resource_producer]
    end

    @resource = @resource_producer.resource
    render "resources/resource"
  end
end
