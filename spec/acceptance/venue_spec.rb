require 'acceptance/acceptance_helper'

feature "Venues", :js => true do
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
    include_steps "login", @owner.email, @password

    Given "I am a new user" do
    end

    When "I visit my profile by clicking on 'Profile'" do
      click_on 'Profile'
    end

    Then "I see I have a single venue called 'My Kitchen'" do
      within ".venues.edit" do
        page.should have_content 'My Kitchen'
      end
    end

    When "I fill in the a new venue name and click 'Create Venue'" do
      within "#profile_edit_new_venue form" do
        fill_in "Name", :with => "My new venue"
        click_on "Create Venue"
      end
    end

    Then "I will be on the edit new venue page" do
      page.should have_selector "#page_venues_edit"
      within "form" do
        page.should have_field "Name", :with => "My new venue"
      end
    end

    When "I change the venue name and update the record" do
      within "form" do
        fill_in "Name", :with => "That names sux"
        click_on "Update Venue"
      end

    end

    Then "I shall be back on the profile page and the venue should be there" do
      page.should have_selector "#page_profiles_edit"
    end

  end
end
