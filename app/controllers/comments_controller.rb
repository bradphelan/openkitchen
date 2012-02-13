class CommentsController < InheritedResources::Base
  include InheritedResources::DSL
  
  respond_to :html, :js

  defaults :resource_class => Comment, 

    :collection_name => 'comment_threads',
    :instance_name => 'comment'

  belongs_to :event
  actions :create


  def create
    @comment = Comment.build_from parent, 
      current_user.id, 
      params[:comment][:body]
    @comment.save

    create! do |success, failure|
      failure.html { redirect_to edit_event_path(parent) }
      success.html { redirect_to edit_event_path(parent) }
    end
  end

end
