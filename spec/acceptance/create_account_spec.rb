require 'acceptance/acceptance_helper'

feature 'Create account', %q{
  In order to become a member
  As a new user
  I want to sign up for an account
} do
  scenario 'Signing up' do
    sign_up_on_home_page email: "joe@bigman.com", password: "xxxxxx"
    page.should have_content 'Welcome! You have signed up successfully.'
  end
end

feature 'Signing in as a registered user', %q{
  In order to be signed in
  As a current user
  I wish to sign in
} do
  background do
    @password = "xxxxxx"
    @user = Factory :registered_user, :password => @password
  end

  scenario "A correct password and username should sign in" do
    sign_in_on_home_page email: @user.email, password: @password
    user_should_be_registered
  end

  scenario "An incorrect password and username should fail to sign in" do
    sign_in_on_home_page email: @user.email, password: "bad password"
    user_should_not_be_signed_in_successfully
  end
end

feature 'Sign in as an unregistered user' do

  background do
    @password = "xxxxxx"
    @user = Factory :user, :password => @password
  end

  scenario "should be told to complete registration" do
    sign_in_on_home_page email: @user.email, password: @password
    user_should_be_signed_in_successfully
    user_should_be_unregistered
  end

end

feature 'Completing registration' do
  background do
    @password = "xxxxxx"
    @user = Factory :user, :password => @password
  end

  # See http://rubydoc.info/gems/email_spec/1.2.1/EmailSpec/Helpers
  # for email spec helpers
  scenario "complete the registration" do

    sign_in_on_home_page email: @user.email, password: @password
    click_on "Complete Registration"
    page.should have_content "You have been signed out to perform this action"

    @email = open_last_email
    @email.should be_delivered_to @user.email

    visit_in_email "Change my password"
    page.should have_content "Change your password"

    change_password_to "yyyyyy"
    user_should_be_registered
  end

end

