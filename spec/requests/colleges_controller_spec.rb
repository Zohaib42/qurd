require 'swagger_helper'

describe 'Colleges API', type: :request, swagger_doc: 'v1/swagger.json' do
  let(:member) { create :member }
  let(:Authorization) { auth_headers(member) }
  let!(:member2) { create :member }

  context 'Listing Colleges' do
    path '/colleges' do
      get 'Colleges with members' do
        tags 'Colleges'
        security [bearerAuth: []]
        operationId 'colleges'
        consumes 'application/json'
        produces 'application/json'

        parameter name: :term, in: :query, type: :string

        response '200', 'Successfully returns colleges' do
          let(:term) { '' }

          run_test! do
            expect(json_response['colleges'].count).to eq(2)
            expect(json_response['colleges'].first.key?('members')).to eq(true)

            domain = College.find(json_response['colleges'].first['id']).college_domains.first.domain
            member = Member.all.select { |m| m.email.split('@').last == domain }.first

            expect(json_response['colleges'].first['members'].first['id']).to eq member.id
          end
        end

        response '200', 'Successfully returns searched colleges' do
          before do
            College.first.update(name: 'Oxford University')
          end

          let(:term) { 'ford' }

          run_test! do
            expect(json_response['colleges'].count).to eq(1)
            expect(json_response['colleges'].first.key?('members')).to eq(true)
          end
        end
      end
    end
  end
end
