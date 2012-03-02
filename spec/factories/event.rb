FactoryGirl.define do
  factory :event do
    owner { Factory :user }
    name  { Forgery::LoremIpsum.words(3) }
    datetime { Forgery::Date.date }
    venue { owner.venues.first }
    timezone "UTC"
  end
end
