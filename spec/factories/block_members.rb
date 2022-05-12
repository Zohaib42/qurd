FactoryBot.define do
  factory :block_member do
    association :blocker, factory: :member, strategy: :create
    association :member, factory: :member, strategy: :create
  end
end
