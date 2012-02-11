# == Schema Information
#
# Table name: users
#
#  id                        :integer         not null, primary key
#  email                     :string(255)     default(""), not null
#  encrypted_password        :string(128)     default(""), not null
#  reset_password_token      :string(255)
#  reset_password_sent_at    :datetime
#  remember_created_at       :datetime
#  sign_in_count             :integer         default(0)
#  current_sign_in_at        :datetime
#  last_sign_in_at           :datetime
#  current_sign_in_ip        :string(255)
#  last_sign_in_ip           :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#  confirmation_token        :string(255)
#  confirmed_at              :datetime
#  confirmation_sent_at      :datetime
#  registration_completed_at :datetime
#

require 'spec_helper'

describe User do
  before do
    @user = Factory :user
  end
  describe "an unauthenticated user" do
  end
end
