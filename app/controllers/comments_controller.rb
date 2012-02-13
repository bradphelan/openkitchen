class CommentsController < InheritedResources::Base
  
  respond_to :json

  defaults :resource_class => Comment, 
    :collection_name => 'comment_threads',
    :instance_name => 'comment'

  belongs_to :event
  actions :create, :destroy

  load_and_authorize_resource :only => :destroy


  def create
    @event = parent
    @comment = Comment.build_from parent, 
      current_user.id, 
      params[:comment][:body]

    authorize! :create, @comment
    @comment.save



    create! do |format|
      html = render_to_string :partial => "events/comment", :locals => { :event => parent, :comment => @comment }
      format.js { render :js => html, :content_type => "html" }
    end

  end

  def destroy

    authorize! :destroy, @comment
    # Why is this necessary
    destroy! do |format|
      format.json { render :json => @comment }
    end
  end

end
