FactoryBot.define do
  factory :post_report do
    reason { 'xyz' }
    association :post, factory: :post, strategy: :create
    association :reporter, factory: :member, strategy: :create
  end
end
