FactoryGirl.define do
  factory :event do
    owner { Factory :user }
    name  { Forgery::LoremIpsum.words(3) }
    datetime { Forgery::Date.date }
    street "6 Astolat Ave"
    city "Murrumbeena"
    country "Australia"
  end
end
