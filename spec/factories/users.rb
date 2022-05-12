# rubocop:disable Style/MixinUsage
include ActionDispatch::TestProcess
# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "test#{n}@email.com"
    end

    first_name { 'Babyface' }
    last_name { 'Combes' }
    password { 'password' }
    password_confirmation { 'password' }
    type { 'Student' }
    trait :with_avatar do
      avatar { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'dummy_image.jpg'), 'image/jpg') }
    end
  end

  factory :admin, parent: :user, class: 'Admin' do
    type { 'Admin' }
  end
  factory :student, parent: :user, class: 'Student' do
    type { 'Student' }
  end
  factory :instructor, parent: :user, class: 'Instructor' do
    type { 'Instructor' }
  end
end
# rubocop:enable Style/MixinUsage
