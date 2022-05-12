require 'swagger_helper'

describe 'Group API', type: :request, swagger_doc: 'v1/swagger.json' do
  let(:member) { create :member, :with_following }
  let(:Authorization) { auth_headers(member) }

  context 'Index group' do
    path '/groups' do
      get 'Groups Listing' do
        tags 'Group'
        security [bearerAuth: []]
        operationId 'GroupsListing'
        consumes 'application/json'
        produces 'application/json'

        context 'Groups listing' do
          let!(:groups) { create_list :group, 5, creator: member, member_ids: [member.id] }

          response '200', 'returns success response' do
            run_test! do
              expect(json_response['groups'].count).to eq 5
            end
          end
        end
      end
    end
  end

  context 'create group' do
    path '/groups' do
      post 'create new Group' do
        tags 'Group'
        security [bearerAuth: []]
        operationId 'create_group'
        consumes 'application/json'
        produces 'application/json'

        parameter name: :group, in: :body, schema: { '$ref' => '#/definitions/group' }

        context 'when group is valid' do
          response '200', 'returns success response' do
            let(:group) do
              {
                group: {
                  name: 'abc group',
                  image: nil,
                  chat_type: Group::CHAT_TYPES[:channel],
                  creator: member,
                  member_ids: member.following_ids + [member.id]
                }
              }
            end

            run_test! do
              expect(member.groups.first.members.count).to eq 3
            end
          end
        end

        context 'when group is valid' do
          response '200', 'returns success response' do
            let(:group) do
              {
                group: {
                  name: 'abc group',
                  image: nil,
                  chat_type: Group::CHAT_TYPES[:direct],
                  creator: member,
                  member_ids: [member.following_ids.first]
                }
              }
            end

            run_test! do
              expect(member.created_groups.direct.first.members.count).to eq 2
            end
          end
        end
      end
    end
  end

  context 'show group' do
    path '/groups/{id}' do
      get 'Group Details' do
        tags 'Group'
        security [bearerAuth: []]
        operationId 'show group'
        consumes 'application/json'
        produces 'application/json'

        parameter name: :id, in: :path

        response '200', 'returns success response' do
          let!(:group) { create :group, creator: member, member_ids: [member.id] }
          let(:id) { group.id }

          run_test!
        end
      end
    end
  end

  context 'update group' do
    path '/groups/{id}' do
      patch 'update Group' do
        tags 'Group'
        security [bearerAuth: []]
        operationId 'update_group'
        consumes 'application/json'
        produces 'application/json'

        parameter name: :group, in: :body, schema: { '$ref' => '#/definitions/group' }
        parameter name: :id, in: :path, type: :integer

        context 'when group is valid' do
          response '200', 'returns success response' do
            let(:new_group) { create :group, creator: member }
            let(:group) do
              {
                group: {
                  name: 'abc'
                }
              }
            end
            let(:id) { new_group.id }

            run_test! do
              expect(member.created_groups.first.name).to eq 'abc'
            end
          end
        end

        context 'when group is invalid' do
          response '422', 'returns unprocessable response' do
            let(:new_group) { create :group, creator: member }
            let(:group) do
              {
                group: {
                  name: nil
                }
              }
            end
            let(:id) { new_group.id }

            run_test!
          end
        end

        context 'when group is invalid' do
          response '422', 'returns unprocessable response' do
            let(:new_group) { create :group, creator: member }
            let(:group) do
              {
                group: {
                  chat_type: nil
                }
              }
            end
            let(:id) { new_group.id }

            run_test!
          end
        end

        context 'when group is valid' do
          response '404', 'returns record not found response' do
            let(:group) do
              {
                group: {
                  name: 'abc'
                }
              }
            end

            let(:id) { 0 }

            run_test! do
              expect(member.created_groups.count).to eq 0
            end
          end
        end
      end
    end
  end

  context 'delete group' do
    path '/groups/{id}' do
      delete 'delete Group' do
        tags 'Group'
        security [bearerAuth: []]
        operationId 'delete_group'
        consumes 'application/json'
        produces 'application/json'

        parameter name: :id, in: :path, type: :integer

        context 'when group is valid' do
          response '200', 'returns success response' do
            let(:group) { create :group, creator: member  }
            let(:id) { group.id }

            run_test! do
              expect(member.created_groups.count).to eq 0
            end
          end
        end

        context 'when group is valid' do
          response '404', 'returns record not found response' do
            let(:id) { 0 }

            run_test! do
              expect(member.created_groups.count).to eq 0
            end
          end
        end
      end
    end
  end

  context 'Leave group' do
    path '/groups/{id}/leave_group' do
      post 'leave group' do
        tags 'Group'
        security [bearerAuth: []]
        operationId 'leave_group'
        consumes 'application/json'
        produces 'application/json'

        parameter name: :id, in: :path, type: :integer
        parameter name: :leave_group, in: :body, schema: { '$ref' => '#/definitions/leave_group' }

        context 'when group is valid' do
          response '200', 'returns success response' do
            let(:group) { create :group, creator: member  }
            let(:new_member) { create :member }
            let!(:group_member_one) { create :group_member, group: group, member: member }
            let!(:group_member_two) { create :group_member, group: group, member: new_member }
            let(:id) { group.id }
            let(:leave_group) do
              {
                leave_group: {
                  member_id: new_member.id
                }
              }
            end

            run_test! do
              expect(member.groups.count).to eq 1
              expect(group.members.count).to eq 1
            end
          end
        end

        context 'when group is valid' do
          response '200', 'returns success response' do
            let(:group) { create :group, creator: member  }
            let(:new_member) { create :member }
            let!(:group_member_one) { create :group_member, group: group, member: member }
            let!(:group_member_two) { create :group_member, group: group, member: new_member }
            let(:id) { group.id }
            let(:leave_group) do
              {
                leave_group: {
                  member_id: member.id
                }
              }
            end

            run_test! do
              expect(member.created_groups.count).to eq 0
            end
          end
        end

        context 'when group is valid' do
          response '404', 'returns record not found response' do
            let(:id) { 0 }
            let(:leave_group) do
              {
                leave_group: {
                  member_id: member.id
                }
              }
            end

            run_test!
          end
        end
      end
    end
  end

  context 'Read conversation' do
    path '/groups/{id}/read_conversation/{member_id}' do
      get 'Read Conversation' do
        tags 'Group'
        security [bearerAuth: []]
        operationId 'read_conversation'
        consumes 'application/json'
        produces 'application/json'

        parameter name: :id, in: :path, type: :integer
        parameter name: :member_id, in: :path, type: :integer

        let!(:group) { create :group, creator: member, member_ids: [member.id] }
        let(:id) { group.id }
        let(:member_id) { member.id }

        context 'when successfull' do
          before do
            allow(TalkJs::ReadGroupConversation).to receive(:call).and_return(ServiceResponse.new(data: {}))
          end

          response '200', 'returns success response' do
            run_test!
          end
        end

        context 'when un-successfull' do
          before do
            allow(TalkJs::ReadGroupConversation).to receive(:call).and_return(
              ServiceResponse.new(data: OpenStruct.new(parsed_response: { 'errorCode' => 'Not Found' }), status: :unprocessable_entity)
            )
          end

          response '422', 'returns unprocessable entity' do
            run_test!
          end
        end
      end
    end
  end
end
