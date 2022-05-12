FactoryBot.define do
  factory :college do
    name { FFaker::Name.name }
    lat { FFaker.numerify("#.##") }
    lng { FFaker.numerify("#.##") }
  end
end
