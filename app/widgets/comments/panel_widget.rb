class Comments::PanelWidget < ApplicationWidget

  responds_to_event :comment

  has_widgets do
    @event = options[:event]
    @comments = @event.root_comments
    @comments.each do |comment|
      self << widget("comments/comment", "comment-#{comment.id}", :comment => comment)
    end
  end
  
  #
  # Events
  #

  # Add a comment
  def comment(evt)
    commentable_type = case params[:comment][:commentable_type]
                        when 'Event'
                          ::Event
                        else
                          raise "nice try!"
                        end

    @event = commentable_type.find(params[:comment][:commentable_id])

    @comment = Comment.build_from @event, 
      current_user.id, 
      params[:comment][:body]

    authorize! :create, @comment
    @comment.save

    #
    # Append the comment to the list and clear the form
    #

    render :text => <<-EOF
      var w = $("##{widget_id}");
      var m = "#{render_comment_for_js! @comment}";

      // Append child
      w.find("ul").append(m);
      w.find("ul div:last-child").hide().fadeIn(500);

      // Clear form
      w.find("textarea").val("");
    EOF
    
  end



  #
  # Views
  #
  def display
    render
  end

  def list(comments)
    render locals: { comments: comments}
  end

  private

  def render_comment_for_js! comment
    render_widget_for_js! "comments/comment", "comment-#{comment.id}", :comment => comment
  end

end
