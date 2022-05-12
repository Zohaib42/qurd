FactoryBot.define do
  factory :comment do
    content { FFaker::String.rand }
    association :author, factory: :member, strategy: :create
    association :post, factory: :post, strategy: :create
  end
end
