FactoryBot.define do
  factory :comment_tag do
    association :member, factory: :member, strategy: :create
    association :comment, factory: :comment, strategy: :create
  end
end
