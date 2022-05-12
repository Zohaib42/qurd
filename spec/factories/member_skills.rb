FactoryBot.define do
  factory :member_skill do
    association :skill, factory: :skill, strategy: :create
    association :member, factory: :member, strategy: :create
  end
end
