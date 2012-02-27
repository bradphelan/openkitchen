FactoryGirl.define do
  factory :user do
    email { Forgery::Internet.email_address }
    password "xxxxxx"

    factory :registered_user do
      confirmed_at { Time.zone.now }
    end
  end
end
