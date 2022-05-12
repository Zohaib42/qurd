FactoryBot.define do
  factory :device do
    token { '13234we4' }
    platform { 'ios' }

    association :member, factory: :member, strategy: :create
  end
end
