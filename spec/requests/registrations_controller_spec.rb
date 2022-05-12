require 'swagger_helper'

describe 'Registration API', type: :request, swagger_doc: 'v1/swagger.json' do
  let(:member_password) { 'password' }
  let(:member) { build :member, password: member_password }

  describe 'Registration API' do
    path '/members' do
      post 'Member Registration' do
        tags 'Accounts'
        operationId 'registration'
        consumes 'application/json'
        produces 'application/json'
        parameter name: :sign_up, in: :body, schema: { '$ref' => '#/definitions/sign_up' }

        context 'when member is successfully created' do
          response '200', 'Successfull Registration' do
            let(:mock_mailer) { instance_double('mailer') }

            before do
              allow(Devise::Mailer).to receive(:confirmation_instructions).and_return(mock_mailer)
              allow(mock_mailer).to receive(:deliver)
            end


            let(:sign_up) do
              {
                sign_up: {
                  email: member.email,
                  password: member_password,
                  name: member.name,
                  username: member.username,
                  mobile: member.mobile
                }
              }
            end

            run_test! do
              expect(json_response['member']['auth_token'].present?).to be_truthy
            end
          end
        end

        context 'when member is not successfully created' do
          response '422', 'Invalid Registration' do
            let(:sign_up) do
              {
                sign_up: {
                  email: member.email,
                  password: '123',
                  username: 'samuel.black1',
                  mobile: '12342'
                }
              }
            end

            run_test! do
              expect(json_response['errors']['password'].present?).to be_truthy
              expect(json_response['errors']['name'].present?).to be_truthy
              expect(json_response['errors']['username'].present?).to be_truthy
              expect(json_response['errors']['mobile'].present?).to be_truthy
            end
          end
        end
      end
    end
  end
end
