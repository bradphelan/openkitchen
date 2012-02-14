require 'openkitchen/authorizable_widget'

class Comments::CommentWidget < OpenKitchen::AuthorizableWidget

  responds_to_event :destroy

  #
  # Events
  #
  
  # Destroy a comment
  def destroy(evt)
    @comment = Comment.find params[:comment_id]
    @event = @comment.commentable
    authorize! :destroy, @comment
    @comment.destroy

    replace "#comment-#{@comment.id}", :text => '', 
  end

  #
  # States
  #
  
  def display(comment=options[:comment])
    render locals: { comment: comment }
  end

end
