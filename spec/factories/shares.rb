FactoryBot.define do
  factory :share do
    association :member, factory: :member, strategy: :create
    association :post, factory: :post, strategy: :create
  end
end
