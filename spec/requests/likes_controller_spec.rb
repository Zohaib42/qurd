require 'swagger_helper'

describe 'Likes API', type: :request, swagger_doc: 'v1/swagger.json' do
  let(:member) { create :member }
  let(:Authorization) { auth_headers(member) }
  let(:posting) { create :post }

  context 'create applause' do
    path '/posts/{post_id}/likes' do
      post 'create new applause' do
        tags 'Applause'
        security [bearerAuth: []]
        operationId 'create_applause'
        consumes 'application/json'
        produces 'application/json'

        parameter name: :post_id, in: :path, type: :integer

        response '200', 'applause created' do
          let!(:device) { create :device, member: posting.creator }
          let!(:notifications_count) { Rpush::Gcm::Notification.count }
          let(:post_id) { posting.id }

          before { dump_rpush }

          run_test! do
            expect(posting.reload.likes_count).to eq 1
            expect(Rpush::Gcm::Notification.count).to eq notifications_count + 1
            expect(posting.creator.notifications.count).to eq 1
          end
        end
      end
    end
  end

  context 'undo applause' do
    path '/posts/{post_id}/likes' do
      delete 'undo post applause' do
        tags 'Applause'
        security [bearerAuth: []]
        operationId 'undo_applause'
        consumes 'application/json'
        produces 'application/json'

        parameter name: :post_id, in: :path, type: :integer

        response '200', 'undo post applause' do
          let(:post_id) { posting.id }
          let!(:like) { create :like, post: posting, member: member }

          run_test! do
            expect(posting.reload.likes_count).to eq 0
          end
        end
      end
    end
  end
end
