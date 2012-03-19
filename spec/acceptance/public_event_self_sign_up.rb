require 'acceptance/acceptance_helper'


feature "Signing up to public events that have no seats left", :js => true do
  background do
    @password = "xxxxxx"
    @owner = Factory :registered_user, :password => @password
    @event_name ="Acxdadjksdfjkl"

    @guests = []
    2.times do |i|
     @guests << Factory(:registered_user, :password => @password)
    end

    @event = Factory :event, :name => @event_name, :owner => @owner, :public => true, :public_seats => 1
  end

  Steps do

    include_steps "login", @guests[0].email, @password

    When "I visit the event path" do
      visit event_path(@event)
    end

    Then "There should be 1 seat left" do
      page.should have_content "1 public seats left."
    end

    When "I click the 'Register' button" do
      page.should have_button("Invite")
      within "#invite" do
        click_on "Invite"
      end
    end

    Then "there should be 0 seats left" do
      page.should have_content "0 public seats left."
    end

    And "there should be no registration button anymore" do
      page.should have_no_button("Invite")
    end

    When "I visit the event path" do
      visit event_path(@event)
    end

    # Double check this because the AJAX response
    # remove the invite button but I want to be sure
    # it is really gone on a page refresh
    Then "there should be no registration button anymore" do
      page.should have_no_button("Invite")
    end


    include_steps "logout"

    Then "another user starts using the system as 'I'" do end

    include_steps "login", @guests[1].email, @password

    When "I visit the event path" do
      visit event_path(@event)
    end

    Then "There should be 0 seats left" do
      page.should have_content "0 public seats left."
    end

    And "I will not be able to register" do
      page.should have_no_button("Invite")
    end


  end



end

feature "Signing up to a public event when I am allready logged in", :js => true do
  background do
    @password = "xxxxxx"
    @owner = Factory :registered_user, :password => @password
    @event_name ="Acxdadjksdfjkl"
    @guest = Factory :registered_user, :password => @password
    @guest_email = @guest.email
    @guest_name = @guest.name

    @event = Factory :event, :name => @event_name, :owner => @owner, :public => true, :public_seats => 20
  end

  Steps do
    
    include_steps "login", @guest.email, @password

    When "I visit the event path" do
      visit event_path(@event)
    end

    Then "I should be signed in" do
      page.should_not have_content "Sign in"
      page.should_not have_content "Sign up"
    end

    Then "I should not yet be invited to the event" do
      page.should have_content @event_name
      page.should have_no_css("li.invitation .email a", :text => @guest.name)
    end


    When "I click the invite button" do
      within "form.invite" do
        click_on "Invite" 
      end
    end

    Then "I shall be invited to the event" do
      page.should have_content @event_name
      page.should have_css("li.invitation .email a", :text => @guest.name)
    end

    And "There will be no invite form available anymore" do
      page.should_not have_css "form.invite"
    end

  end

end

feature 'Signing up to a public event with an email that is not a current user', :js => true do
  background do
    @password = "xxxxxx"
    @owner = Factory :registered_user, :password => @password
    @event_name ="Acxdadjksdfjkl"
    @guest_email = 'guest@guest.com'
    @guest_name = "Jon Doe"
    @event = Factory :event, :name => @event_name, :owner => @owner, :public => true, :public_seats => 20
  end

  Steps do

    When "I visit the event path" do
      visit event_path(@event)
    end

    Then "I should not be signed in" do
      page.should have_content "Sign in"
      page.should have_content "Sign up"
    end


    Then "I can see the event" do
      page.should have_content @event_name
    end

    When "I enter my email and click the register button" do
      within "form.invite" do
        fill_in "invite_email", :with => @guest_email
        click_on "Invite" 
      end
    end

    Then "I shall be invited to the event" do
      page.should have_content @event_name
      page.should have_css("li.invitation .email a", :text => @guest_email, :count => 1)
    end

    And "I shall be required to confirm my account" do
      user_should_be_unregistered
      page.should_not have_content "Sign in"
      page.should_not have_content "Sign up"
    end
  end
end

feature 'Signing up to a public event with an email of an existing user', :js => true do
  background do
    @password = "xxxxxx"
    @owner = Factory :registered_user, :password => @password
    @event_name ="Acxdadjksdfjkl"

    @guest= Factory :registered_user, :password => @password
    @guest_email = @guest.email

    @event = Factory :event, :name => @event_name, :owner => @owner, :public => true, :public_seats => 20
  end

  Steps do
    When "I visit the event path" do
      visit event_path(@event)
    end

    Then "I should not be signed in" do
      page.should have_content "Sign in"
      page.should have_content "Sign up"
    end


    Then "I can see the event" do
      page.should have_content @event_name
    end

    And "I can see a register for event button" do
      page.should have_selector "form.invite"
    end

    When "I enter my email and click the register button" do
      within "form.invite" do
        fill_in "invite_email", :with => @guest_email
        click_on "Invite" 
      end
    end

    Then "I shall be sent to the sign in screen to log in" do
      page.should have_css ".devise form#new_user" 
    end

    And "the email field should be pre-filled with my email address" do
      within "form#new_user" do
        page.should have_field("user_email", :with => @guest_email)
      end
    end

    When "I fill in my password and submit" do
      within "form#new_user" do
        fill_in "Password", :with => @password
        click_on "Sign in"
      end
    end

    And "I will be back on the event page" do
      page.should have_content @event_name
    end

  end
end
