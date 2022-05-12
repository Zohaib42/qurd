require 'rails_helper'

RSpec.describe 'WelcomeControllerRoutes', type: :routing do
  describe 'GET #index' do
    it 'is the root url' do
      expect(get: '/').to route_to(
        controller: 'dashboard',
        action: 'index'
      )
    end
  end
end
