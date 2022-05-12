FactoryBot.define do
  factory :member do
    sequence :email do |n|
      "member#{n}@#{college_domain.domain}"
    end
    first_name { 'Babyface' }
    last_name { 'Combes' }
    password { 'password' }
    mobile { '(555) 555-1234' }
    sequence :username do |n|
      "#{first_name.downcase}#{n}"
    end
    confirmed_at { Time.zone.now }
    star_sign { 'Taurus' }

    transient do
      college_domain { create(:college_domain) }
    end

    trait :with_follower do
      after(:create) do |member|
        member.followers << FactoryBot.create(:member)
      end
    end

    trait :with_following do
      after(:create) do |member|
        member.following << FactoryBot.create(:member)
      end
    end
  end
end
