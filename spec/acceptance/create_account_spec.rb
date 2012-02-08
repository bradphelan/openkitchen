require 'acceptance/acceptance_helper'


shared_steps "sign up" do |email, password|

  When "I goto the the home page" do
    page.visit homepage
  end

  When "I go to click sign up " do
    click_on 'Sign up'
  end
  
  When "I put in credentials" do
    within ".devise" do
      fill_in 'Email'                 , :with => email
      fill_in 'Password'              , :with => password
      fill_in 'Password confirmation' , :with => password
      click_on 'Sign up'
    end

  end

  Then "I should be signed up" do
    page.should have_content 'You have signed up successfully'
  end

  And "I should be fully registered" do
    page.should_not have_selector "#complete_registration"
  end

end

shared_steps "login" do |email, password|

  When "I goto the the home page" do
    page.visit homepage
  end

  When "I go to click sign up " do
    click_on 'Sign in'
  end
  
  When "I put in credentials" do
    within ".devise" do
      fill_in 'Email'                 , :with => email
      fill_in 'Password'              , :with => password
      click_on 'Sign in'
    end
    page.should have_content 'Signed in successfully'
  end
end

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

