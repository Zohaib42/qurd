require 'rails_helper'

describe 'BlockMember API', type: :request, swagger_doc: 'v1/swagger.json' do
  let(:member) { create :member }
  let(:Authorization) { auth_headers(member) }

  context "Create block member" do
    path "/block_members" do
      post 'create_block_member' do
        tags 'BlockMember'
        security [bearerAuth: []]
        operationId 'create_block_member'
        consumes 'application/json'
        produces 'application/json'

        parameter name: :block_member, in: :body, schema: { '$ref' => '#/definitions/block_member' }

        response '200', 'Returns success response' do
          let(:new_member) { create :member }
          let(:block_member) do
            {
              block_member: {
                member_id: new_member.id
              }
            }
          end

          run_test! do
            expect(member.block_members.count).to eq 1
            expect(member.block_members.first.member_id).to eq new_member.id
          end
        end

        response '422', 'Returns unprocessable response' do
          let(:new_member) { create :member }
          let(:block_member) do
            {
              block_member: {
                member_id: 0
              }
            }
          end

          run_test! do
            expect(member.block_members.count).to eq 0
          end
        end
      end
    end
  end

  context "Delete block member" do
    path "/block_members/{block_member_id}/destroy" do
      delete 'delete_block_member' do
        tags 'BlockMember'
        security [bearerAuth: []]
        operationId 'delete_block_member'
        consumes 'application/json'
        produces 'application/json'

        parameter name: :block_member_id, in: :path, type: :integer

        response '200', 'Returns success response' do
          let(:new_member) { create :member }
          let(:block_member) { create :block_member, blocker: member, member: member }
          let(:block_member_id) { block_member.member_id }

          run_test! do
            expect(member.block_members.count).to eq 0
          end
        end

        response '404', 'Returns not found response' do
          let(:block_member_id) { 0 }

          run_test!
        end
      end
    end
  end
end
