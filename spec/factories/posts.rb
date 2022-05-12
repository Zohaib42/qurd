FactoryBot.define do
  factory :post do
    title { FFaker::String }
    post_type { Post::POST_TYPES[:text] }
    description { FFaker::String }
    share_type { Post::SHARE_TYPES[:link] }
    link { 'www.google.com' }

    association :creator, factory: :member, strategy: :create
  end
end
