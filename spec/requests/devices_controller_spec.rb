require 'swagger_helper'

describe 'Likes API', type: :request, swagger_doc: 'v1/swagger.json' do
  let(:member) { create :member }
  let(:Authorization) { auth_headers(member) }
  let(:posting) { create :post }

  context 'create device token' do
    path '/devices' do
      post 'create new Device Token' do
        tags 'Device Token'
        security [bearerAuth: []]
        operationId 'create_device_token'
        consumes 'application/json'
        produces 'application/json'

        parameter name: :device, in: :body, schema: { '$ref' => '#/definitions/device' }

        context 'When Device Token is successfully created' do
          response '200', 'Device Token created' do
            let(:device) do
              {
                device: {
                  token: '34123dde',
                  platform: 'ios'
                }
              }
            end

            run_test!
          end
        end

        context 'When Device Token is not successfully created' do
          response '422', 'Device Token created' do
            let(:device) do
              {
                device: {
                  token: '34123dde',
                  platform: 'iossss'
                }
              }
            end

            run_test!
          end
        end
      end
    end
  end
end
