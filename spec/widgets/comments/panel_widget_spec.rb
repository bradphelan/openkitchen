require 'spec_helper'

describe Comments::PanelWidget do
  has_widgets do |root|
    root << widget('comments/panel')
  end
  
  it "should render :display" do
    render_widget('comments/panel', :display).should have_selector("h1")
  end
  
end
