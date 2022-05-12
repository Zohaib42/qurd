require 'swagger_helper'

describe 'Accounts API', type: :request, swagger_doc: 'v1/swagger.json' do
  let(:member) { create :member }
  let(:Authorization) { auth_headers(member) }

  describe 'Accounts API' do
    path '/accounts/resend_confirmation' do
      get 'Resend Confirmation' do
        tags 'Accounts'
        security [bearerAuth: []]
        operationId 'resend_confirmation'
        consumes 'application/json'
        produces 'application/json'

        let!(:email_delivery_count) { ActionMailer::Base.deliveries.count }

        response '200', 'When resend email is sent after 10 minutes' do
          before { member.update(confirmation_sent_at: 15.minutes.ago) }

          run_test! do
            expect(ActionMailer::Base.deliveries.count).to eq email_delivery_count + 1
          end
        end

        response '200', 'When resend email is not sent before 10 minutes' do
          before { member.update(confirmation_sent_at: 5.minutes.ago) }

          run_test! do
            expect(ActionMailer::Base.deliveries.count).to eq email_delivery_count
          end
        end
      end
    end

    path '/accounts/reset_password_link' do
      post 'Reset Password Link' do
        tags 'Accounts'
        security [bearerAuth: []]
        operationId 'reset_password_link'
        consumes 'application/json'
        produces 'application/json'

        parameter name: :account, in: :body, schema: { '$ref' => '#/definitions/reset_password_link' }

        response '200', 'Returns success response' do
          let(:account) do {
              account: {
                email: member.email
              }
            }
          end

          run_test!
        end

        response '404', 'Returns not found' do
          let(:account) do {
              account: {
                email: 'abc@xyz.com'
              }
            }
          end

          run_test!
        end
      end
    end

    path '/accounts/confirmation_status' do
      get 'Email Confirmation status' do
        tags 'Accounts'
        security [bearerAuth: []]
        operationId 'confirmation_status'
        consumes 'application/json'
        produces 'application/json'

        response '200', 'Returns success response' do
          run_test!
        end

        response '401', 'Returns unprocessable_entity response' do
          before { member.update(confirmed_at: nil) }

          run_test!
        end
      end
    end

    path '/accounts/change_password' do
      post 'Change password' do
        tags 'Accounts'
        security [bearerAuth: []]
        operationId 'change_password'
        consumes 'application/json'
        produces 'application/json'

        parameter name: :account, in: :body, schema: { '$ref' => '#/definitions/change_password' }

        response '200', 'Returns success response' do
          let(:account) do {
              account: {
                password: 'example',
                password_confirmation: 'example',
                current_password: 'password'
              }
            }
          end

          run_test!
        end
      end
    end

    path '/accounts/suggestions' do
      get 'Member suggestions' do
        tags 'Accounts'
        security [bearerAuth: []]
        operationId 'Member Suggestions'
        consumes 'application/json'
        produces 'application/json'

        response '200', 'Returns suggested members' do
          let!(:new_member) { create :member }
          let!(:skill) { create :skill }
          let!(:new_member_skill) { create :member_skill, skill: skill, member: new_member  }
          let!(:another_member_skill) { create  :member_skill, skill: skill, member: member }
          let!(:member_interest) { create :member_interest, skill: skill, member: new_member }
          let!(:another_member_interest) { create :member_interest, skill: skill, member: member }

          run_test! do
            expect(new_member.id).to eq json_response['members'][0]['id']
          end
        end

        response '200', 'Returns empty array' do
          let!(:new_member) { create :member }
          let!(:skill_one) { create :skill }
          let!(:new_member_skill) { create :member_skill, skill: skill_one, member: new_member  }
          let!(:skill_two) { create :skill }
          let!(:first_member_skill) { create :member_skill, skill: skill_two, member: member  }

          run_test! do
            expect(json_response['members']).to eq []
          end
        end

        response '200', 'Returns suggested members' do
          let!(:new_member) { create :member, :with_follower }
          let!(:skill) { create :skill }
          let!(:new_member_skill) { create :member_skill, skill: skill, member: new_member  }
          let!(:another_member_skill) { create  :member_skill, skill: skill, member: member }
          let!(:member_interest) { create :member_interest, skill: skill, member: new_member }
          let!(:another_member_interest) { create :member_interest, skill: skill, member: member }
          let!(:third_member) { create :member }

          run_test! do
            expect(json_response['members'][0]['id']).to eq new_member.id
            expect(json_response['members'].size).to eq 1
          end
        end

        response '200', 'Returns empty array' do
          let!(:new_member) { create :member, :with_follower }
          let!(:skill_one) { create :skill }
          let!(:new_member_skill) { create :member_skill, skill: skill_one, member: new_member  }
          let!(:first_member_skill) { create :member_skill, skill: skill_one, member: member  }

          run_test! do
            expect(json_response['members']).to eq []
          end
        end
      end
    end
  end
end
