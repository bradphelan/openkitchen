module ClickableHelpers

  def sign_in
    ".sign_in a"
  end
  def sign_up
    ".sign_up a"
  end

end
RSpec.configuration.include ClickableHelpers, :type => :acceptance
