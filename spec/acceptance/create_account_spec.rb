require 'acceptance/acceptance_helper'

feature 'Create account' do
  Steps do
    include_steps "sign up", "joesixpack@muscles.com", "bigmuscles"
  end
end

feature 'Signing in as a registered user' do
  background do
    @password = "xxxxxx"
    @user = Factory :registered_user, :password => @password
  end

  Steps do
    include_steps "login", @user.email, @password
    Then "I should be fully registered" do
      page.should_not have_selector "#complete_registration"
    end
  end

end


feature 'Sign in as an unregistered user' do

  background do
    @password = "xxxxxx"
    @user = Factory :user, :password => @password
  end

  Steps do
    include_steps "login", @user.email, @password
    Then "user should not be fully registered" do
      page.should have_selector "#complete_registration"
    end
  end

end


feature 'Completing registration' do
  background do
    @password = "xxxxxx"
    @user = Factory :user, :password => @password
  end

  # See http://rubydoc.info/gems/email_spec/1.2.1/EmailSpec/Helpers
  # for email spec helpers
  Steps "complete the registration" do

    include_steps "login", @user.email, @password

    When "I click on complete registration" do
      click_on "Complete Registration"
    end

    Then "I should be signed out" do
      page.should have_content "You have been signed out to perform this action"
    end

    When "I look in my email" do
      @email = open_last_email
    end

    Then "I shall find an email delivered to me" do
      @email.should be_delivered_to @user.email
    end

    When "I click the link to follow change my password" do
      visit_in_email "Change my password"
    end

    Then "I find myself at the password change page" do
      page.should have_content "Change your password"
    end

    When "I change my password" do
      change_password_to "yyyyyy"
    end

    Then "I should be fully registered" do
      user_should_be_registered
    end
  end

end

feature "Creating an event" do
  background do
    @password = "xxxxxx"
    @user = Factory :registered_user, :password => @password
    visit homepage
  end

  Steps do

    include_steps "login", @user.email, @password

    When "I click on 'events'" do
      click_on "Events"
    end

    Then "I should be on the events page" do
      page.should have_content "Welcome to your events"
    end

    When "I click on 'create new event'" do
      click_on "Create New Event"
    end

    Then "I am presented with a form to create the event" do
      page.should have_content "Create an event"
    end

    When "I fill in the form" do
      within "form" do
        fill_in "Name", :with => "My Party"
        fill_in "Date", :with => "09/02/2012"
        select "(GMT+01:00) Vienna", :from => "Timezone"
        fill_in "Street", :with => "6 Astolat Ave"
        fill_in "City", :with => "Melbourne"
        fill_in "Country", :with => "Australia"
      end
    end

    And "click 'Create Event'" do
      click_on "Create Event"
    end

    Then "the event will have been created" do
      page.should have_content "Event 'My Party' has been created"
    end
  end


end

