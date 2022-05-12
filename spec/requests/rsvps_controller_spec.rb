require 'rails_helper'

describe 'Rsvp API', type: :request, swagger_doc: 'v1/swagger.json' do
  let!(:member) { create :member }
  let(:Authorization) { auth_headers(member) }

  context 'rsvp create' do
    path '/rsvps' do
      post 'rsvp create' do
        tags 'RSVP'
        security [bearerAuth: []]
        operationId 'create_rsvp'
        consumes 'application/json'
        produces 'application/json'

        parameter name: :rsvp, in: :body, schema: { '$ref' => '#/definitions/rsvp' }

        response '200', 'Returns success response' do
          let(:new_event) { create :event }
          let(:rsvp) do
            {
              rsvp: {
                event_id: new_event.id
              }
            }
          end

          run_test! do
            expect(new_event.rsvps.count).to eq 1
          end
        end
      end
    end
  end

  context 'rsvp destroy' do
    path '/rsvps/{event_id}' do
      delete 'rsvp destroy' do
        tags 'RSVP'
        security [bearerAuth: []]
        operationId 'destroy_rsvp'
        consumes 'application/json'
        produces 'application/json'

        parameter name: :event_id, in: :path, type: :integer

        response '200', 'Returns success response' do
          let(:new_event) { create :event }
          let(:new_event_rsvp) { create :rsvp, event: new_event, member: member }
          let(:event_id) { new_event_rsvp.event_id }

          run_test! do
            expect(new_event.rsvps.count).to eq 0
          end
        end

        response '404', 'Returns not found response' do
          let(:event_id) { 0 }

          run_test!
        end
      end
    end
  end
end
