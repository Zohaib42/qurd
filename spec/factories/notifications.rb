FactoryBot.define do
  factory :notification do
    status { Notification::STATUSES[:unread] }
    title { "MyString" }
    association :notifier, factory: :member, strategy: :create
    association :recipient, factory: :member, strategy: :create
    association :notifiable, factory: :post, strategy: :create
  end
end
