FactoryBot.define do
  factory :group_member do
    association :group, factory: :group, strategy: :create
    association :member, factory: :member, strategy: :create
  end
end
