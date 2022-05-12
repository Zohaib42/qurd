require 'swagger_helper'

RSpec.describe UpdateMemberHotnessService do
  let(:member) { create :member }
  let(:first_post) { create :post, creator: member }
  let(:second_post) { create :post, creator: member }

  describe '#update_score' do
    before do
      first_post.update(score: 0.023)
    end

    let(:score_sum) { member.posts.order(score: :desc).limit(4).sum(:score) }

    it 'calculates and updates the member score' do
      UpdateMemberHotnessService.new(member).update_score

      expect(member.score).to eq score_sum
    end
  end
end
