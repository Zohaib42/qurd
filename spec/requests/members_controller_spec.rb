require 'swagger_helper'

describe 'Members API', type: :request, swagger_doc: 'v1/swagger.json' do
  let(:member) { create :member, :with_following }
  let(:Authorization) { auth_headers(member) }

  context 'Filtering members by username and skills' do
    path "/members" do
      get 'Get all members. Filter members' do
        tags 'Members'
        security [bearerAuth: []]
        operationId 'search_member_by_skills'
        consumes 'application/json'
        produces 'application/json'

        parameter name: :term, in: :query, type: :string
        parameter name: 'skills[]', in: :query, type: :array, items: { type: :integer }
        parameter name: 'looking_for_skills[]', in: :query, type: :array, items: { type: :integer }
        parameter name: :college_id, in: :query, type: :integer

        response '200', 'Successfully return members' do
          let(:new_member) { create :member }
          let(:term) { new_member.username }
          let(:'skills[]') { [] }
          let(:'looking_for_skills[]') { [] }
          let(:college_id) { nil }

          run_test! do |response|
            expect(JSON.parse(response.body).dig("members").count).to eq(1)
          end
        end

        response '200', 'Successfully return members' do
          let(:new_member) { create :member }
          let(:skill) { create :skill }
          let(:term) { nil }
          let(:'skills[]') { [skill.id] }
          let(:'looking_for_skills[]') { [] }
          let(:college_id) { nil }

          before { create :member_skill, skill: skill, member: new_member }

          run_test! do |response|
            expect(JSON.parse(response.body).dig("members").count).to eq(1)
          end
        end

        response '200', 'Successfully return members' do
          let(:new_member) { create :member }
          let(:skill) { create :skill }
          let(:term) { nil }
          let(:'skills[]') { [] }
          let(:'looking_for_skills[]') { [skill.id] }
          let(:college_id) { nil }

          before { create :member_interest, skill: skill, member: new_member }

          run_test! do |response|
            expect(JSON.parse(response.body).dig("members").count).to eq(1)
          end
        end

        response '200', 'Successfully return members' do
          let(:new_member) { create :member }
          let(:skill) { create :skill }
          let(:term) { nil }
          let(:'skills[]') { [] }
          let(:'looking_for_skills[]') { [] }
          let(:college_domain) { create :college_domain }
          let(:college) { college_domain.college }
          let(:college_id) { college_domain.college.id }
          let(:email) { "ss@#{college_domain.domain}" }

          before { new_member.update(email: email) }

          run_test! do |response|
            expect(JSON.parse(response.body).dig("members").count).to eq(1)
          end
        end
      end
    end
  end

  context 'Follow member' do
    path '/members/{member_id}/follow' do
      get 'follow member' do
        tags 'Members'
        security [bearerAuth: []]
        operationId 'follow_member'
        consumes 'application/json'
        produces 'application/json'

        parameter name: :member_id, in: :path, type: :integer

        response '200', 'Returns success response.' do
          let(:new_member) { create :member }
          let(:member_id) { new_member.id }

          run_test! do
            expect(member.following.first).to eq(new_member)
          end
        end

        response '422', 'Returns unprocessable entity response when followed not found.' do
          let(:member_id) { 0 }

          run_test! do |response|
            expect(JSON.parse(response.body)['meta']['error_message'].present?).to eq true
          end
        end

        response '422', 'Returns unprocessable_entity response when following self.' do
          let(:member_id) { member.id }

          run_test! do |response|
            expect(JSON.parse(response.body)['meta']['error_message'].present?).to eq true
          end
        end
      end
    end
  end

  context 'follow list of members' do
    path '/members/bulk_follow' do
      post 'follow list of members' do
        tags 'Members'
        security [bearerAuth: []]
        consumes 'application/json'
        produces 'application/json'

        parameter name: :bulk_follow, in: :body, schema: { '$ref' => '#/definitions/bulk_follow' }

        response '200', 'Returns success response' do
          let(:new_member) { create :member }
          let(:bulk_follow) do
            {
              bulk_follow: {
                member_ids: [new_member.id]
              }
            }
          end

          run_test! do
            expect(new_member.followers.count).to eq 1
          end
        end
      end
    end
  end

  context 'UnFollow member' do
    path '/members/{member_id}/unfollow' do
      get 'unfollow member' do
        tags 'Members'
        security [bearerAuth: []]
        operationId 'unfollow_member'
        consumes 'application/json'
        produces 'application/json'

        parameter name: :member_id, in: :path, type: :integer

        response '200', 'Returns success response.' do
          let(:member_id) { member.following.last.id }

          run_test! do
            expect(member.reload.following.count).to eq 0
          end
        end

        response '404', 'Returns not found response.' do
          let(:member_id) { 100 }

          run_test! do |response|
            expect(JSON.parse(response.body)['errors'].present?).to eq true
            expect(JSON.parse(response.body)['meta'].present?).to eq true
            expect(JSON.parse(response.body)['status'].present?).to eq true
          end
        end
      end
    end
  end

  context 'Member profile' do
    path '/members/{id}/profile' do
      get 'Member Profile' do
        tags 'Members'
        security [bearerAuth: []]
        operationId 'profile'
        consumes 'application/json'
        produces 'application/json'

        parameter name: :id, in: :path, type: :integer

        response '200', 'Successfully return profile' do
          let(:id) { member.id }

          run_test! do
            expect(json_response.keys.count).to eq 25
          end
        end

        response '422', 'Returns unprocessable response' do
          let(:new_member) { create :member }
          let(:id) { new_member.id }

          before do
            member.block_members.create(member_id: id)
          end

          run_test!
        end

        response '404', 'Returns not found' do
          let(:id) { 100 }

          run_test!
        end
      end
    end
  end

  context 'Members list' do
    path '/members/followers_list' do
      get 'Members list' do
        tags 'Members'
        security [bearerAuth: []]
        operationId 'Followers List'
        consumes 'application/json'
        produces 'application/json'

        parameter name: :term, in: :query, type: :string

        response '200', 'Successfully return members' do
          let(:new_member) { member.following.first }
          let(:term) { new_member.username }

          run_test! do |response|
            expect(JSON.parse(response.body).dig("members").count).to eq(1)
          end
        end

        response '200', 'Successfully return members' do
          let(:new_member) { member.following.first }
          let(:term) { new_member.username }

          before do
            member.block_members.create(member_id: new_member.id)
          end

          run_test! do |response|
            expect(JSON.parse(response.body).dig("members").count).to eq(0)
          end
        end
      end
    end
  end

  # TODO: Need to test current member device tokens are deleted on this end-point.
  context 'Logout' do
    path '/members/logout' do
      delete 'Logout' do
        tags 'Members'
        security [bearerAuth: []]
        operationId 'Logout'
        consumes 'application/json'
        produces 'application/json'

        response '200', 'Successfully Logout' do
          let(:device) { create :device, member: member }
          let(:new_device) { create :device, member: member }

          run_test! do
            expect(member.devices.count).to eq 0
          end
        end
      end
    end
  end
end
