require 'rails_helper'

describe 'MemberReport API', type: :request, swagger_doc: 'v1/swagger.json' do
  let(:member) { create :member, :with_following }
  let(:Authorization) { auth_headers(member) }

  context 'Create Member Report' do
    path "/member_reports" do
      post 'Create member report' do
        tags 'MemberReport'
        security [bearerAuth: []]
        operationId 'create_member_report'
        consumes 'application/json'
        produces 'application/json'

        parameter name: :member_report, in: :body, schema: { '$ref' => '#/definitions/member_report' }

        response '200', 'Returns success response' do
          let(:new_member) { create :member }
          let(:member_report) do
            {
              member_report: {
                reason: 'some reason',
                reported_id: new_member.id
              }
            }
          end

          run_test! do
            expect(member.member_reports.count).to eq 1
            expect(member.member_reports.first.reporter_id).to eq member.id
          end
        end

        response '422', 'Returns unprocessable response' do
          let(:new_member) { create :member }
          let(:member_report) do
            {
              member_report: {
                reason: 'some reason'
              }
            }
          end

          run_test! do
            expect(member.member_reports.count).to eq 0
          end
        end
      end
    end
  end

  context 'Delete Member Report' do
    path "/member_reports/{member_report_id}/destroy" do
      delete 'Delete member report' do
        tags 'MemberReport'
        security [bearerAuth: []]
        operationId 'delete_member_report'
        consumes 'application/json'
        produces 'application/json'

        parameter name: :member_report_id, in: :path, type: :integer

        response '200', 'Returns success response' do
          let(:new_member) { create :member }
          let(:member_report) { create :member_report, reported: new_member, reporter: member }
          let(:member_report_id) { member_report.reported_id }

          run_test! do
            expect(member.member_reports.count).to eq 0
          end
        end

        response '404', 'Returns not found response' do
          let(:member_report_id) { 0 }

          run_test!
        end
      end
    end
  end
end
