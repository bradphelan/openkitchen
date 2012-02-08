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
    @user = Factory :registered_user
  end

  scenario "logging in with correct password" do
    sign_in_on_home_page email: @user.email, password: @password
    user_should_be_registered
  end

  scenario "logging in with incorrect password" do
    sign_in_on_home_page email: @user.email, password: "bad password"
    user_should_not_be_signed_in_successfully
  end
end

feature 'Sign in as an unregistered user' do

  background do
    @password = "xxxxxx"
    @user = Factory :user
  end

  scenario "logging in with correct password" do
    sign_in_on_home_page email: @user.email, password: @password
    user_should_be_signed_in_successfully
    user_should_be_unregistered
  end

end

