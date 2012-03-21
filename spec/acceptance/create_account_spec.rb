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
    Then "I should be confirmed" do
      page.should_not have_selector "#complete_registration_button"
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
    Then "user should not be confirmed" do
      page.should have_selector "#complete_registration_button"
    end
  end

end

feature "Creating an event" do
  background do
    @password = "xxxxxx"
    @create_new_event_selector = "New"
    @create_event_selector = "New event"
    visit homepage
  end

  Steps do
    Given "An unregistered user" do
      @user = Factory :user, :password => @password
    end

    include_steps "login", @user.email, @password

    When "I click on 'events'" do
      click_on "Events"
    end

    Then "I should be on the events page" do
      page.should have_selector ".events"
    end

    When "I click on 'create new event'" do
      click_on @create_new_event_selector
    end

    Then "nothing should happen as the link is disabled" do
      page.should have_selector ".events"
    end
  end

  Steps  do

    Given "A registered user" do
      @user = Factory :registered_user, :password => @password
    end

    include_steps "login", @user.email, @password

    When "I click on 'events'" do
      click_on "Events"
    end

    Then "I should be on the events page" do
      page.should have_selector ".events"
    end

    Then "there should be a 'create new event' button" do
      page.should have_link @create_new_event_selector
    end

    When "I click on 'create new event'" do
      click_on @create_new_event_selector
    end

    Then "I am presented with a form to create the event" do
      page.should have_content @create_event_selector
    end

    When "I fill in the form" do
      within "form" do
        fill_in "Name", :with => "My Party"
        within ".date" do
          select "2017", :from => "event_datetime_1i"
          select "Jul", :from => "event_datetime_2i"
          select "12", :from => "event_datetime_3i"
        end
        within ".time" do
          select "08 PM", :from => "event_datetime_4i"
          select "15", :from => "event_datetime_5i"
        end
        select "(GMT+01:00) Vienna", :from => "Timezone"
        select I18n.t('default_venue_name'), :from => "Venue"
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
      click_on "Complete registration"
    end

    When "I look in my email" do
      @email = open_last_email
    end

    Then "I shall find an email delivered to me" do
      @email.should be_delivered_to @user.email
    end

    When "I click the link to follow change my password" do
      visit_in_email "Confirm my account"
    end

    Then "I find myself at the password change page" do
      page.should have_content "Password confirmation"
    end

    When "I change my password" do
      within ".devise" do
        fill_in "Password", :with =>  "yyyyyy"
        fill_in "Password confirmation", :with => "yyyyyy"
        click_on "Confirm Account"
      end
    end

    Then "I should be confirmed" do
      user_should_be_registered
    end
  end

end


feature "Inviting somebody to an event" do
  background do
    @password = "xxxxxx"
    @owner = Factory :registered_user, :password => @password
    @event = Factory :event, :owner => @owner, :name => "Party GAGA"
    @guest_email = "joe@bigdumbjoe.com"
  end

  Steps do
    include_steps "login", @owner.email, @password

    Given "I am editing an event I own" do
      visit edit_event_path(@event)
    end

    And "fill in an email address of a guest to invite and click send" do
      within "form.invite-guest" do
        fill_in "invite_guest", :with => @guest_email
        click_on "Invite"
      end
    end

    When "the guest looks in thier email" do
      @email = open_last_email
    end

    Then "they shall find an email delivered to themselves" do
      @email.should be_delivered_to @guest_email
    end

    When "I follow the invite link in the email" do
      visit_in_email "Goto invitation"
    end

    Then "I should be on the page for the event" do
      page.should have_selector "#show_event_page"
      #page.save_and_open_page
      page.should have_content "Party gaga"
    end

    And "I should not be confirmed" do
      page.should have_selector "#complete_registration_button"
    end


  end

end
