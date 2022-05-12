require 'rails_helper'

RSpec.describe 'UserRoutes', type: :routing do
  describe 'GET /admins/' do
    it 'routes to users#index' do
      expect(get: '/admins').to route_to(
        controller: 'users',
        action: 'index',
        type: 'Admin'
      )
    end
  end

  describe 'GET /instructors/' do
    it 'routes to users#index' do
      expect(get: '/instructors').to route_to(
        controller: 'users',
        action: 'index',
        type: 'Instructor'
      )
    end
  end

  describe 'GET /students/' do
    it 'routes to users#index' do
      expect(get: '/students').to route_to(
        controller: 'users',
        action: 'index',
        type: 'Student'
      )
    end
  end

  describe 'GET /edit_profile/' do
    it 'routes to users#edit_profile' do
      expect(get: 'users/1/edit_profile').to route_to(
        controller: 'users',
        action: 'edit_profile',
        id: '1'
      )
    end
  end

  describe 'POST /update_profile/' do
    it 'routes to users#update_profile' do
      expect(post: 'users/1/update_profile').to route_to(
        controller: 'users',
        action: 'update_profile',
        id: '1'
      )
    end
  end
end
