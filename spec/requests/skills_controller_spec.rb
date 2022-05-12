require 'swagger_helper'

describe 'Skills API', type: :request, swagger_doc: 'v1/swagger.json' do
  let(:member) { create :member }
  let(:Authorization) { auth_headers(member) }

  context 'Listing Skills' do
    path '/skills' do
      get 'Skills and Interests' do
        tags 'Skills'
        security [bearerAuth: []]
        operationId 'skills_and_interests'
        consumes 'application/json'
        produces 'application/json'

        response '200', 'Successfully return skills and interests' do
          run_test!
        end
      end
    end
  end
end
