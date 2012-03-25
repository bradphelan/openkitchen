class Comments::PanelWidget < ApplicationWidget

  responds_to_event :comment
  responds_to_event :toggle_watch
  responds_to_event :refresh

  has_widgets do
    @event = options[:event]
    if @event
      @comments = @event.root_comments.includes(:user, :commentable).order "created_at ASC"
      @invitation = @event.invitation_for_user current_user if current_user
      @comments.each do |comment|
        self << widget("comments/comment", "comment_#{comment.id}", :comment => comment)
      end
    end
  end

  def toggle_watch_link title
    [ url_for_event(:toggle_watch), :remote=>true, :class => "btn btn-info subscribe", :title => title]
  end
  helper_method :toggle_watch_link
  #
  # Events
  #

  def toggle_watch
    @invitation = @event.invitation_for_user current_user

    authorize! :update, @invitation

    @invitation.event.toggle_comment_subscription @invitation.user

    #
    # Append the comment to the list and clear the form
    #

    replace "##{widget_id} .subscribe", :view => :comment_button
  end

  # Add a comment
  def comment(evt)
    commentable_type = case evt[:comment][:commentable_type]
                        when 'Event'
                          ::Event
                        else
                          raise "nice try!"
                        end

    @comment = Comment.build_from @event, 
      current_user.id, 
      evt[:comment][:body]


    authorize! :create, @comment
    @comment.save
    
    # This needs to be done or the subscription state is
    # not reloaded automatically
    @invitation.reload if @invitation

    #
    # Append the comment to the list and clear the form
    # and set the state on the watch button
    #

    button = escape_javascript render :view => :comment_button

    PusherQueue.trigger! "event.#{@event.id}.comments", "new", :callback => url_for_event('refresh')

    render :text => <<-EOF
      var w = $("##{widget_id}");
      var m = "#{render_comment_for_js! @comment}";

      // Append child
      w.find("ul").append(m);
      w.find("ul div:last-child").hide().fadeIn(500);

      // Clear form
      w.find("textarea").val("");

      w.find(".subscribe").replaceWith("#{button}");
    EOF

    
  end

  def refresh
    authorize! :read, @event
    replace "##{widget_id}", :view => :display
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
    render_widget_for_js! "comments/comment", "comment_#{comment.id}", :comment => comment
  end

end
