require 'acceptance/acceptance_helper'

shared_steps "show me the page" do
  Then "show me the page" do
    save_and_open_page
  end
end

shared_steps "sign up" do |email_address, password|

  When "I goto the the home page" do
    page.visit homepage
  end

  When "I go to click sign up " do
    click_on 'Sign up'
  end
  
  When "I put in my email" do
    within ".devise" do
      fill_in 'Email'                 , :with => email_address
      click_on 'Sign up'
    end

  end

  Then "I should be signed up" do
    page.should have_content 'You have signed up successfully'
  end

  And "I should not be yet confirmed" do
    page.should have_selector "#complete_registration_button"
  end

  When "I look in my email" do
    @email = open_last_email
  end

  Then "I shall find an email delivered to me" do
    @email.should be_delivered_to email_address
  end

  When "I click on 'Confirm my account'" do
    visit_in_email 'Confirm my account'
  end

  Then "I shall find myself on the confirmations page" do
    page.should have_content 'Password confirmation'
  end

  When "I add my credentials and click 'Confirm Account'" do
    within ".devise" do
     fill_in 'Password'              , :with => password
     fill_in 'Password confirmation' , :with => password
     click_on 'Confirm Account'
    end
  end

  Then "I should be confirmed" do
    page.should have_content 'Your account was successfully confirmed'
    page.should_not have_selector "#complete_registration_button"
  end
end

shared_steps "login" do |email_address, password|

  When "I visit the home page" do
    page.visit homepage
  end

  When "I go to click 'sign in'" do
    click_on 'Sign in'
  end
  
  When "I put in credentials" do
    within ".devise" do
      fill_in 'Email'                 , :with => email_address
      fill_in 'Password'              , :with => password
      click_on 'Sign in'
    end
  end
  
  Then "I should be logged in" do
    page.should have_content 'Signed in successfully'
  end
end

shared_steps "logout" do |email_address, password|

  When "I visit my account page" do
    page.visit edit_users_path
  end

  When "I go to click 'sign in'" do
    click_on 'Sign out'
  end
  
  Then "I should be logged out" do
    page.should have_content 'Signed out successfully'
  end
end
