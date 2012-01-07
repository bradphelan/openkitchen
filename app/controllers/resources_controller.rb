class ResourcesController < ApplicationController
  def create
    @resource = Resource.create! params[:resource]
    redirect_to :back
  end

  def show
    @resource = Resource.find params[:id]
  end
end
