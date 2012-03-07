FactoryGirl.define do
  factory :user do
    email { Forgery::Internet.email_address }
    password "xxxxxx"
    name { Forgery::Name.full_name }

    factory :registered_user do
      confirmed_at { Time.zone.now }
    end
  end
end
