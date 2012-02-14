require 'spec_helper'

describe CommentsWidget do
  has_widgets do |root|
    root << widget('comments')
  end
  
  it "should render :display" do
    render_widget('comment', :display).should have_selector("h1")
  end
  
end
