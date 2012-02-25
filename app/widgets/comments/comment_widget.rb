class Comments::CommentWidget < ApplicationWidget

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

    render :text => <<-EOF
      var w = $("##{widget_id}");
      $(".tooltip").remove();
      w.fadeOut(500).remove();
    EOF
  end

  #
  # States
  #
  
  def display(comment=options[:comment])
    render locals: { event: @event, comment: comment }
  end

end
