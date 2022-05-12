require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  create_all_users

  describe 'GET #index' do
    before do
      sign_in user
      get :index
    end

    context 'with admin user' do
      let(:user) { admin_user }

      it { expect(assigns(:users).count).to eq(3) }
      it { expect(response).to render_template('index') }
    end

    context 'with instructor user' do
      let(:user) { instructor_user }

      it 'raises CanCan::AccessDenied' do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'with student user' do
      let(:user) { student_user }

      it 'raises CanCan::AccessDenied' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe '#edit_profile' do
    let(:assigns_user) { assigns[:user] }
    let(:user_profile_id) { user.id }

    before do
      sign_in user
      get :edit_profile, params: { id: user_profile_id }
    end

    context 'with student' do
      let(:user) { student_user }

      it 'assigns the correct user' do
        expect(assigns_user).to eq(user)
      end

      it 'renders the edit profile template' do
        expect(response).to render_template :edit_profile
      end
    end

    context 'with instructor' do
      let(:user) { instructor_user }

      it 'assigns the correct user' do
        expect(assigns_user).to eq(user)
      end

      it 'renders the edit template' do
        expect(response).to render_template :edit_profile
      end
    end

    context 'with admin' do
      let(:user) { admin_user }

      it 'assigns the correct user' do
        expect(assigns_user).to eq(user)
      end

      it 'renders the edit template' do
        expect(response).to render_template :edit_profile
      end
    end

    context "when a student is trying to access someone else's profile" do
      let(:user) { student_user }
      let(:user_profile_id) { instructor_user.id }

      it 'raises CanCan::AccessDenied' do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "when an instructor is trying to access someone else's profile" do
      let(:user) { instructor_user }
      let(:user_profile_id) { student_user.id }

      it 'raises CanCan::AccessDenied' do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "when an admin is trying to access someone else's profile" do
      let(:user) { admin_user }
      let(:user_profile_id) { student_user.id }

      it 'raises CanCan::AccessDenied' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe '#update_profile' do
    let(:assigns_user) { assigns[:user] }
    let(:user_error) { assigns_user.errors }

    before do
      sign_in user
      put :update_profile, as: :js, params: { id: user.id, user: { first_name: first_name } }
    end

    context 'with student' do
      let(:user) { student_user }

      context 'when mandatory fields are present' do
        let(:first_name) { 'Sushant' }

        it "updates the user's first name" do
          expect(assigns_user.first_name).to eq(first_name)
        end

        it { expect(response).to render_template('update_profile') }
      end

      context 'when one of the mandatory fields is blank' do
        let(:first_name) { '' }

        it "does not update the user's first name" do
          expect(User.find(student_user.id).first_name).not_to eq(first_name)
        end

        it { expect(user_error.full_messages).to eq(['First name can\'t be blank']) }
        it { expect(response).to render_template('update_profile') }
      end

      context 'when one of the mandatory fields is not present' do
        let(:first_name) { nil }

        it "does not update the user's first name" do
          expect(User.find(student_user.id).first_name).not_to eq(first_name)
        end

        it { expect(user_error.full_messages).to eq(['First name can\'t be blank']) }
        it { expect(response).to render_template('update_profile') }
      end
    end

    context 'with instructor' do
      let(:user) { instructor_user }

      context 'when mandatory fields are present' do
        let(:first_name) { 'Manu' }

        it "updates the user's first name" do
          expect(assigns_user.first_name).to eq(first_name)
        end

        it { expect(response).to render_template('update_profile') }
      end

      context 'when one of the mandatory fields is blank' do
        let(:first_name) { '' }

        it "does not update the user's first name" do
          expect(User.find(instructor_user.id).first_name).not_to eq(first_name)
        end

        it { expect(user_error.full_messages).to eq(['First name can\'t be blank']) }
        it { expect(response).to render_template('update_profile') }
      end

      context 'when one of the mandatory fields is not present' do
        let(:first_name) { nil }

        it "does not update the user's first name" do
          expect(User.find(instructor_user.id).first_name).not_to eq(first_name)
        end

        it { expect(user_error.full_messages).to eq(['First name can\'t be blank']) }
        it { expect(response).to render_template('update_profile') }
      end
    end

    context 'with admin' do
      let(:user) { admin_user }

      context 'when mandatory fields are present' do
        let(:first_name) { 'Shanu' }

        it "updates the user's first name" do
          expect(assigns_user.first_name).to eq(first_name)
        end

        it { expect(response).to render_template('update_profile') }
      end

      context 'when one of the mandatory fields is blank' do
        let(:first_name) { '' }

        it "does not update the user's first name" do
          expect(User.find(admin_user.id).first_name).not_to eq(first_name)
        end

        it { expect(user_error.full_messages).to eq(['First name can\'t be blank']) }
        it { expect(response).to render_template('update_profile') }
      end

      context 'when one of the mandatory fields is not present' do
        let(:first_name) { nil }

        it "does not update the user's first name" do
          expect(User.find(admin_user.id).first_name).not_to eq(first_name)
        end

        it { expect(user_error.full_messages).to eq(['First name can\'t be blank']) }
        it { expect(response).to render_template('update_profile') }
      end
    end
  end
end
