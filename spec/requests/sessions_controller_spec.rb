require 'swagger_helper'

describe 'Login API', type: :request, swagger_doc: 'v1/swagger.json' do
  let(:member_password) { 'password' }
  let(:member) { create :member, password: member_password }

  describe 'Login API' do
    path '/members/login' do
      post 'Member Login' do
        tags 'Accounts'
        operationId 'login'
        consumes 'application/json'
        produces 'application/json'
        parameter name: :sign_in, in: :body, schema: { '$ref' => '#/definitions/login' }

        response '200', 'Successfull Login' do
          let(:sign_in) do
            {
              sign_in: {
                email: member.email,
                password: member_password
              }
            }
          end

          run_test! do
            expect(json_response['member']['auth_token'].present?).to be_truthy
          end
        end
      end
    end
  end
end
