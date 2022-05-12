require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:post) { build :post }

  context 'associations' do
    it { should belong_to(:creator) }
  end

  context 'with validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:post_type) }

    context 'title not present' do
      it 'should return invalid post' do
        post.assign_attributes(title: nil)

        expect(post.valid?).to be false
        expect(post.errors[:title].present?).to be true
      end
    end

    context 'post_type not present' do
      it 'should return invalid post' do
        post.assign_attributes(post_type: nil)

        expect(post.valid?).to be false
        expect(post.errors[:post_type].present?).to be true
      end
    end

    context 'description longer than 500 characters' do
      it 'should return invalid post' do
        post.assign_attributes(description: FFaker::Lorem.characters(Post::MAX_DESCRIPTION_CHARS + 1))

        expect(post.valid?).to be false
        expect(post.errors[:description].present?).to be true
      end
    end

    context 'attachment not present' do
      it 'should return invalid post' do
        post.assign_attributes(post_type: Post::POST_TYPES[:image], share_type: Post::SHARE_TYPES[:attachment])

        expect(post.valid?).to be false
        expect(post.errors[:attachment].present?).to be true
      end
    end

    context 'share_type not present' do
      it 'should return invalid post' do
        post.assign_attributes(share_type: nil, post_type: Post::POST_TYPES[:image])

        expect(post.valid?).to be false
        expect(post.errors[:share_type].present?).to be true
      end
    end

    context 'link not present' do
      it 'should return inavlid post' do
        post.assign_attributes(link: nil)

        expect(post.valid?).to be false
        expect(post.errors[:link].present?).to be true
      end
    end
  end
end
