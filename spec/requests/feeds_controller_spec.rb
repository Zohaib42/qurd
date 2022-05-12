require 'swagger_helper'

describe 'Feed API', type: :request, swagger_doc: 'v1/swagger.json' do
  let(:member) { create :member }
  let(:Authorization) { auth_headers(member) }

  context "feed for member" do
    path "/feeds" do
      get 'fetch feed' do
        tags 'Feed'
        security [bearerAuth: []]
        operationId 'fetch_comments'
        consumes 'application/json'
        produces 'application/json'

        response '200', 'return success response' do
          let(:number_of_posts) { 15 }
          let!(:existing_posts) { create_list(:post, number_of_posts, creator: member) }
          let!(:new_member) { create :member }
          let(:skill) { create :skill }
          let!(:new_member_skill) { create :member_skill, skill: skill, member: new_member }
          let!(:another_member_skill) { create :member_skill, skill: skill, member: member }
          let!(:new_member_interest) { create :member_interest, skill: skill, member: member }
          let!(:another_member_interest) { create :member_interest, skill: skill, member: new_member }

          run_test! do
            expect(json_response['feed']['posts'].count).to be 15
            expect(json_response['feed']['video_posts'].count).to be 0
            expect(json_response['feed']['image_posts'].count).to be 0
            expect(json_response['feed']['text_posts'].count).to be 15
            expect(json_response['feed']['audio_posts'].count).to be 0
            expect(json_response['feed']['skills'].count).to be 1
            expect(json_response['feed']['suggested_members'].count).to be 1
          end
        end

        response '200', 'return success response' do
          let(:number_of_posts) { 15 }
          let!(:new_member) { create :member }
          let!(:existing_posts) { create_list(:post, number_of_posts, creator: new_member) }
          let(:skill) { create :skill }
          let!(:new_member_skill) { create :member_skill, skill: skill, member: new_member }
          let!(:another_member_skill) { create :member_skill, skill: skill, member: member }
          let!(:new_member_interest) { create :member_interest, skill: skill, member: member }
          let!(:another_member_interest) { create :member_interest, skill: skill, member: new_member }
          let!(:another_member) { create :member }
          let!(:third_member_interest) { create :member_interest, skill: skill, member: another_member }
          let!(:third_member_skill) { create :member_skill, skill: skill, member: another_member }

          before do
            member.passive_relationships.create(follower_id: new_member.id)
            member.block_members.create(member_id: member.followers.first.id)
          end

          run_test! do
            expect(json_response['feed']['posts'].count).to be 0
            expect(json_response['feed']['video_posts'].count).to be 0
            expect(json_response['feed']['image_posts'].count).to be 0
            expect(json_response['feed']['text_posts'].count).to be 0
            expect(json_response['feed']['audio_posts'].count).to be 0
            expect(json_response['feed']['skills'].count).to be 1
            expect(json_response['feed']['suggested_members'].count).to be 1
          end
        end
      end
    end
  end
end
