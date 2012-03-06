require 'spec_helper'

describe EventGuestsWidget do
  has_widgets do |root|
    root << widget('event_guests')
  end
  
  it "should render :display" do
    render_widget('event_guest', :display).should have_selector("h1")
  end
  
  it "should render :write" do
    render_widget('event_guest', :write).should have_selector("h1")
  end
  
end
