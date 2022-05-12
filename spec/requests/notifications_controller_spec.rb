require 'rails_helper'

describe 'Notification Api', type: :request, swagger_doc: 'v1/swagger.json' do
  let(:member) { create :member, :with_follower }
  let(:Authorization) { auth_headers(member) }

  context 'App notifications' do
    path "/notifications" do
      get 'Get all notifications' do
        tags 'Notifications'
        security [bearerAuth: []]
        operationId 'all_notifications'
        consumes 'application/json'
        produces 'application/json'

        response '200', 'Successfully return members' do
          let!(:new_post) { create :post, creator: member }
          let!(:like) { create :like , post: new_post, member: member.followers.first }
          let!(:comment) { create :comment, author: member.followers.first }
          let!(:device) { create :device, member: member }
          let!(:notification) { create :notification, notifiable: new_post, recipient: member, notifier: member.followers.first }

          run_test! do
            expect(json_response['notifications'].count).to eq 1
          end
        end
      end
    end
  end

  context 'Read notification' do
    path '/notifications/{id}/read' do
      get 'read notifications' do
        tags 'Notifications'
        security [bearerAuth: []]
        operationId 'read_notifications'
        consumes 'application/json'
        produces 'application/json'

        parameter name: :id, in: :path, type: :integer

        response '200', 'Returns success response' do
          let(:new_post) { create :post }
          let(:like) { create :like , post: new_post, member: member.followers.first }
          let(:notification) { create :notification, notifiable: new_post, recipient: member, notifier: member.followers.first }
          let(:id) { notification.id }

          run_test! do
            expect(notification.reload.status).to eq "read"
          end
        end
      end
    end
  end
end
