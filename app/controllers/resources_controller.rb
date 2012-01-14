class ResourcesController < ApplicationController

  check_authorization

  def create

    authorize! :create, Resource

    new_resource = params[:new_resource]
    if new_resource[:suggest_something]
      @resource = Resource.new :event_id => params[:new_resource][:event_id]
      match = new_resource[:suggest_something].match(/(\d+)\s*(.*)/)
      if match
        @resource.quantity = match[1].to_i
        @resource.name = match[2]
      else
        @resource.quantity = 1
        @resource.name = new_resource[:suggest_something]
      end
      @resource.save!
    end


    redirect_to :back
  end

  def show
    @resource = Resource.find params[:id]
    authorize! :show, @resource
  end
end
