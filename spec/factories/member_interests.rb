FactoryBot.define do
  factory :member_interest do
    association :skill, factory: :skill, strategy: :create
    association :member, factory: :member, strategy: :create
  end
end
