require 'openkitchen/authorizable_widget'

class Comments::PanelWidget < OpenKitchen::AuthorizableWidget

  responds_to_event :comment
  
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


    update({:state => :display}, @event)
  end

  #
  # Views
  #
  def display(event = options[:event])
    @event = event
    @comments = @event.root_comments
    @comments.each do |comment|
      self << widget("comments/comment", "comment-#{comment.id}", :comment => comment)
    end
    render
  end

  def list(comments)
    render locals: { comments: comments}
  end


end
