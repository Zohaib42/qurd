FactoryBot.define do
  factory :member_report do
    reason { "MyText" }
    association :reported, factory: :member, strategy: :create
    association :reporter, factory: :member, strategy: :create
  end
end
