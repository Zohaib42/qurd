FactoryBot.define do
  factory :like do
    association :member, factory: :member, strategy: :create
    association :post, factory: :post, strategy: :create
  end
end
