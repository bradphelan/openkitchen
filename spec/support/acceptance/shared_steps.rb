require 'acceptance/acceptance_helper'

shared_steps "show me the page" do
  Then "show me the page" do
    save_and_open_page
  end
end

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
    page.should have_content 'You have completed registration'
  end

  And "I should be fully registered" do
    page.should_not have_selector "#complete_registration"
  end

end

shared_steps "login" do |email, password|

  When "I visit the home page" do
    page.visit homepage
  end

  When "I go to click 'sign in'" do
    click_on 'Sign in'
  end
  
  When "I put in credentials" do
    within ".devise" do
      fill_in 'Email'                 , :with => email
      fill_in 'Password'              , :with => password
      click_on 'Sign in'
    end
  end
  
  Then "I should be logged in" do
    page.should have_content 'Signed in successfully'
  end
end
