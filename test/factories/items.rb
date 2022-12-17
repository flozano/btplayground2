FactoryBot.define do
  factory :item do
    association :team
    name { "MyString" }
    content { "MyText" }
  end
end
