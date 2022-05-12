require 'rails_helper'

describe DashboardController do
  let!(:user) { create(:user) }

  describe 'GET index' do
    context 'when user is not logged in' do
      it 'opens login page' do
        get :index
        expect(response).to redirect_to('/users/sign_in')
      end
    end

    context 'when user is logged in' do
      before do
        sign_in user
        get :index
      end

      it 'opens dashboard page' do
        expect(response).to render_template('index')
      end
    end
  end
end
