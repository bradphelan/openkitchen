FactoryGirl.define do
  factory :user do
    email { Forgery::Internet.email_address }
    password Forgery::Basic.password
  end
end
