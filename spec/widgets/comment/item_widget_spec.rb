require 'spec_helper'

describe Comment::ItemWidget do
  has_widgets do |root|
    root << widget('comment/item')
  end
  
  it "should render :display" do
    render_widget('comment/item', :display).should have_selector("h1")
  end
  
end
