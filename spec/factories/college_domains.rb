FactoryBot.define do
  factory :college_domain do
    association :college, factory: :college, strategy: :create

    domain { FFaker::Internet.unique.domain_name }
  end
end
