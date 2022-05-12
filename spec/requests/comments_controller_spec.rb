require 'swagger_helper'

describe 'Comments API', type: :request, swagger_doc: 'v1/swagger.json' do
  let(:member) { create :member }
  let(:Authorization) { auth_headers(member) }
  let(:posting) { create :post }

  context "get a post's comment" do
    path "/posts/{post_id}/comments" do
      get 'fetch comments' do
        tags 'Comments'
        security [bearerAuth: []]
        operationId 'fetch_comments'
        consumes 'application/json'
        produces 'application/json'

        parameter name: :post_id, in: :path, type: :integer

        response '200', 'get comments for a post' do
          let(:post_id) { posting.id }
          let!(:comment) { create :comment, post: posting }

          run_test! do
            expect(json_response['comments'].count).to eq 1
            expect(posting.reload.comments_count).to eq 1
          end
        end
      end
    end
  end

  context 'create comment' do
    path '/posts/{post_id}/comments' do
      post 'create new comment' do
        tags 'Comments'
        security [bearerAuth: []]
        operationId 'create_comment'
        consumes 'application/json'
        produces 'application/json'

        parameter name: :comment, in: :body, schema: { '$ref' => '#/definitions/comment' }
        parameter name: :post_id, in: :path, type: :integer

        response '200', 'comment created' do
          let!(:device) { create :device, member: posting.creator }
          let!(:notifications_count) { Rpush::Gcm::Notification.count }
          let(:post_id) { posting.id }
          let(:comment) do
            {
              comment: {
                content: 'abc',
                tagged_member_ids: [Member.first.id]
              }
            }
          end

          before { dump_rpush }

          run_test! do
            expect(json_response['comment']['content']).to eq 'abc'
            expect(json_response['comment']['author']['id']).to eq member.id
            expect(Rpush::Gcm::Notification.count).to eq notifications_count + 2
            expect(posting.creator.notifications.count).to eq 2
          end
        end
      end
    end
  end

  context 'delete comment' do
    path '/posts/{post_id}/comments/{id}' do
      delete 'delete user comment' do
        tags 'Comments'
        security [bearerAuth: []]
        operationId 'delete comment'
        consumes 'application/json'
        produces 'application/json'

        parameter name: :post_id, in: :path, type: :integer
        parameter name: :id, in: :path, type: :integer

        response '200', 'delete user comment' do
          let(:post_id) { posting.id }
          let(:comment) { create :comment, post: posting, author: member }
          let(:id) { comment.id }

          run_test!
        end

        response '403', "Forbidden to delete comment" do
          let(:new_member) { create :member }
          let(:post_id) { posting.id }
          let(:comment) { create :comment, post: posting, author: new_member }
          let(:id) { comment.id }

          run_test!
        end
      end
    end
  end
end
