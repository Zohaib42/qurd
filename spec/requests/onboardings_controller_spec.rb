require 'swagger_helper'

describe 'On-boarding API', type: :request, swagger_doc: 'v1/swagger.json' do
  let(:member) { create :member }
  let(:Authorization) { auth_headers(member) }

  context 'Adding member information while on-boarding' do
    path '/onboarding' do
      post 'Skills Interests and member Information' do
        tags 'On-boarding'
        security [bearerAuth: []]
        operationId 'onboarding_member'
        consumes 'application/json'
        produces 'application/json'
        parameter name: :onboarding, in: :body, schema: { '$ref' => '#/definitions/onboarding' }

        context 'with pronouns, skills and interests' do
          response '200', 'Successful On-boarding' do
            let(:onboarding) do
              {
                onboarding: {
                  member_attributes: {
                    pronouns: 'He/Him',
                    star_sign: Member::STAR_SIGNS.sample,
                    image: Rack::Test::UploadedFile.new(Rails.root.join("spec/factories/userimage.jpeg")),
                  },
                  skills: ['Rapper', 'Singing', 'dancing'],
                  interests: ['director', 'producer', 'choreographer'],
                }
              }
            end

            run_test! do
              member_response = json_response['member']

              expect(member_response['star_sign'].present?).to be_truthy
              expect(member_response['pronouns'].present?).to be_truthy
              expect(member_response['skills'].present?).to be_truthy
              expect(member_response['interests'].present?).to be_truthy
            end
          end
        end

        context 'with invalid skills and interests' do
          response '422', 'Error On-boarding' do
            let(:onboarding) do
              {
                onboarding: {
                  skills: ['Rapper122', 'Singing11111', 'dancing', '123', '2345', '12344'],
                  interests: ['director', 'producer', 'choreographer1111'],
                }
              }
            end

            run_test! do
              expect(json_response['errors'].present?).to be_truthy
              expect(json_response['meta']['error_message']).to eq('Skill name has invalid format, Skills cannot be more than 5, and Interest name has invalid format')
            end
          end
        end
      end
    end
  end
end
