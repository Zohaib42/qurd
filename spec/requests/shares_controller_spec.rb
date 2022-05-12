require 'swagger_helper'

describe 'Echoes API', type: :request, swagger_docs: 'v1/swagger.json' do
  let!(:member) { create :member, :with_following }
  let(:Authorization) { auth_headers(member) }
  let(:posting) { create :post }

  context 'echoing a post' do
    path '/posts/{post_id}/shares' do
      post 'Create echo' do
        tags 'Echos'
        operationId 'create_echo'
        security [bearerAuth: []]
        consumes 'application/json'
        produces 'application/json'

        parameter name: :post_id, in: :path, type: :integer

        response '200', 'echoing a post returns success' do
          let(:post_id) { posting.id }
          let!(:device) { create :device, member: posting.creator }
          let!(:notifications_count) { Rpush::Gcm::Notification.count }

          before { dump_rpush }

          run_test! do
            expect(posting.reload.shares_count).to eq 1
            expect(Rpush::Gcm::Notification.count).to eq notifications_count + 1
            expect(posting.creator.notifications.count).to eq 1
          end
        end
      end
    end
  end

  context 'echoing an already echoed post' do
    path '/posts/{post_id}/shares' do
      post 'Echo a post again' do
        tags 'Echos'
        operationId 're_echo_post'
        security [bearerAuth: []]
        consumes 'application/json'
        produces 'application/json'

        parameter name: :post_id, in: :path, type: :integer

        response '200', 're-echoing a post returns success' do
          let(:post_id) { posting.id }
          let!(:existing_share) { create :share, member: member, post: posting }

          run_test! do
            expect(posting.reload.shares_count).to eq 1
          end
        end
      end
    end
  end

  context 'undoes an echo' do
    let(:other_member) { create :member }

    path '/posts/{post_id}/shares' do
      delete 'Undo echo' do
        tags 'Echos'
        operationId 'undo_echo'
        security [bearerAuth: []]
        consumes 'application/json'
        produces 'application/json'

        parameter name: :post_id, in: :path, type: :integer

        response '200', 'undoing an echo returns success' do
          let(:post_id) { posting.id }
          let!(:share) { create :share, member: member, post: posting }

          run_test! do
            expect(posting.reload.shares_count).to eq 0
          end
        end

        response '404', "undoing another member's echo returns 404" do
          let(:post_id) { posting.id }
          let!(:share) { create :share, member: other_member, post: posting }

          run_test! do
            expect(posting.reload.shares_count).to eq 1
          end
        end
      end
    end
  end
end
