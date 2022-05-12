require 'rails_helper'

describe 'PostReport API', type: :request, swagger_doc: 'v1/swagger.json' do
  let(:member) { create :member, :with_following }
  let(:Authorization) { auth_headers(member) }

  context 'Create Report Post' do
    path "/post_reports" do
      post 'Create post report' do
        tags 'PostReport'
        security [bearerAuth: []]
        operationId 'create_post_report'
        consumes 'application/json'
        produces 'application/json'

        parameter name: :post_report, in: :body, schema: { '$ref' => '#/definitions/post_report' }

        response '200', 'Returns success response' do
          let(:posting) { create :post }
          let(:post_report) do
            {
              post_report: {
                reason: 'some reason',
                post_id: posting.id
              }
            }
          end

          run_test! do
            expect(posting.reporters.first.id).to eq member.id
          end
        end
      end
    end
  end

  context 'Delete Report Post' do
    path "/post_reports/{post_report_id}/destroy" do
      delete 'Delete post report' do
        tags 'PostReport'
        security [bearerAuth: []]
        operationId 'delete_post_report'
        consumes 'application/json'
        produces 'application/json'

        parameter name: :post_report_id, in: :path, type: :integer

        response '200', 'Returns success response' do
          let(:new_member) { create :member }
          let(:posting) { create :post, creator: new_member }
          let(:posting_report) { create :post_report, post: posting, reporter: member }
          let(:post_report_id) { posting_report.post_id }

          run_test! do
            expect(posting.reporters.count).to eq 0
          end
        end

        response '404', 'Returns not found response' do
          let(:post_report_id) { 0 }

          run_test!
        end
      end
    end
  end
end
