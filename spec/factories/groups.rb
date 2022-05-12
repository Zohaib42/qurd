FactoryBot.define do
  factory :group do
    name { FFaker::String }
    chat_type { Group::CHAT_TYPES[:channel] }
    association :creator, factory: :member, strategy: :create
  end
end
