require 'rails_helper'

describe 'Event API', type: :request, swagger_doc: 'v1/swagger.json' do
  let(:member) { create :member }
  let(:Authorization) { auth_headers(member) }

  context 'Listing Events' do
    path '/events' do
      get 'Listing events' do
        tags 'Events'
        security [bearerAuth: []]
        operationId 'listing_events'
        consumes 'application/json'
        produces 'application/json'

        response '200', 'Returns success response' do
          let(:num_of_events) { 10 }
          let!(:existing_events) { create_list(:event, num_of_events) }

          run_test! do
            expect(json_response['events'].count).to eq 10
          end
        end
      end
    end
  end

  context 'Show Event' do
    path '/events/{id}' do
      get 'Show event' do
        tags 'Events'
        security [bearerAuth: []]
        operationId 'show_event'
        consumes 'application/json'
        produces 'application/json'

        parameter name: :id, in: :path, type: :integer

        response '200', 'Returns success response' do
          let!(:existing_event) { create :event }
          let(:id) { existing_event.id }

          run_test! do
            expect(json_response.keys.count).to eq 8
          end
        end

        response '404', 'Returns not found response' do
          let(:id) { 0 }

          run_test!
        end
      end
    end
  end
end
