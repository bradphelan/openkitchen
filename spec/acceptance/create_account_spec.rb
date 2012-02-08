require 'acceptance/acceptance_helper'

feature 'Create account', %q{
  In order to become a member
  As a new user
  I want to sign up for an account
} do

  scenario 'Signing up' do
    visit homepage
    click_on 'Sign up'
    fill_in 'Email'                 , :with => "joe@bigman.com"
    fill_in 'Password'              , :with => "xxxxxx"
    fill_in 'Password confirmation' , :with => "xxxxxx"
    click_on 'Sign up'
    page.should have_content 'Welcome! You have signed up successfully.'
  end

end

feature 'Signing in', %q{
  In order to be signed in
  As a current user
  I wish to sign in
} do
  background do
    @password = "xxxxxx"
    @user = Factory :registered_user
  end

  scenario "logging in with correct password" do
    visit homepage
    click_on "Sign in"
    within ".devise" do
      fill_in 'Email'                 , :with => @user.email
      fill_in 'Password'              , :with => @password
      click_button 'Sign in'
    end
    page.should have_content 'Signed in successfully'
  end

  scenario "logging in with incorrect password" do
    visit homepage
    click_on "Sign in"
    within ".devise" do
      fill_in 'Email'                 , :with => @user.email
      fill_in 'Password'              , :with => "bad password"
      click_button 'Sign in'
    end
    page.should have_content 'Invalid email or password'
  end
end

