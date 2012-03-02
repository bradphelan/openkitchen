require 'acceptance/acceptance_helper'

feature "Add comment to event", :js => true do
  background do
    @password = "xxxxxx"
    @owner = Factory :registered_user, :password => @password
    @guest = Factory :registered_user, :password => @password
    @event = Factory :event, :owner => @owner 

    @event.invite @guest.email

    @comment1 = "Hello World"
    @comment2 = "Bye World"

  end

  Steps do
    include_steps "login", @guest.email, @password

    When "I visit the event path" do
      visit event_path(@event)
    end

    And "Enter a comment and click on 'comment'" do
      within "#comments form" do
        fill_in "comment_body", :with => @comment1
        click_button 'comment_submit_action'
      end
    end

    Then "a new comment should be added to the list" do
      within ".comments ul" do
        page.should have_content @comment1
      end
    end

    And "I enter another comment and click on 'comment'" do
      within "#comments form" do
        fill_in "comment_body", :with => @comment2
        click_button 'comment_submit_action'
      end
    end

    Then "a new comment should be added to the list" do
      within ".comments ul" do
        page.should have_content @comment2
      end
    end

  end
end
