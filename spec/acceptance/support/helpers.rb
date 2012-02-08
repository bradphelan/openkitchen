module HelperMethods
  # Put helper methods you need to be available in all acceptance specs here.
  def sign_in_on_home_page options
    email = options.delete :email
    password = options.delete :password

    visit homepage
    click_on "Sign in"
    within ".devise" do
      fill_in 'Email'                 , :with => email
      fill_in 'Password'              , :with => password
      click_button 'Sign in'
    end
  end

  def sign_up_on_home_page options
    user = options.delete :user
    password = options.delete :password
    visit homepage
    click_on 'Sign up'
    within ".devise" do
      fill_in 'Email'                 , :with => "joe@bigman.com"
      fill_in 'Password'              , :with => "xxxxxx"
      fill_in 'Password confirmation' , :with => "xxxxxx"
      click_on 'Sign up'
    end
  end

  def user_should_be_signed_in_successfully
    page.should have_content 'Signed in successfully'
  end

  def user_should_not_be_signed_in_successfully
    page.should have_content 'Invalid email or password'
  end

  def user_should_be_registered
    page.should_not have_selector "#complete_registration"
  end

  def user_should_be_unregistered
    page.should have_selector "#complete_registration"
  end


end

RSpec.configuration.include HelperMethods, :type => :acceptance
