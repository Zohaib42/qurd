FactoryBot.define do
  factory :rsvp do
    association :member, factory: :member, strategy: :create
    association :event, factory: :event, strategy: :create
  end
end
