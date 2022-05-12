FactoryBot.define do
  factory :skill do
    name { FFaker::Name.unique.name }
    creatives { 1 }
  end
end
