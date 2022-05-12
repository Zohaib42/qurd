FactoryBot.define do
  factory :event do
    title { FFaker::String }
    description { FFaker::Book.title }
    price { FFaker::Currency.code }
    location { FFaker::String }
    start_at { Time.zone.now }
    end_at { Time.zone.now + 1.day }
  end
end
