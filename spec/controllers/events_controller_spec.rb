require 'rails_helper'

RSpec.describe EventsController, type: :controller do

  context 'unauthenticated user' do

    before(:each) { sign_out(:user) }

    describe 'GET #index' do
      it do
        get :index
        should redirect_to(new_user_session_path)
      end
    end

    describe 'GET #all' do
      it do
        get :all, params: { year: rand(2000..2020), month: rand(1..12) }
        should redirect_to(new_user_session_path)
      end
    end

    describe 'GET #show' do
      it do
        get :show, params: { id: create(:event) }
        should redirect_to(new_user_session_path)
      end
    end

    describe 'GET #new' do
      it do
        get :new
        should redirect_to(new_user_session_path)
      end
    end

    describe 'POST #create' do
      it do
        post :create, params: { event: attributes_for(:event) }
        should redirect_to(new_user_session_path)
      end
    end

    describe 'GET #edit' do
      it do
        get :edit, params: { id: create(:event) }
        should redirect_to(new_user_session_path)
      end
    end

    describe 'PATCH #update' do
      it do
        patch :update, params: { id: create(:event), event: attributes_for(:event) }
        should redirect_to(new_user_session_path)
      end
    end

    describe 'DELETE #destroy' do
      it do
        delete :destroy, params: { id: create(:event) }
        should redirect_to(new_user_session_path)
      end
    end

  end

  context 'authenticated user' do

    let(:current_user) { create(:user) }
    before(:each) { sign_in(current_user) }

    describe 'GET #index' do

      it do
        get :index
        expect(response).to have_http_status(:ok)
      end

      context 'with valid year/month params' do
        it do
          get :index, params: { year: rand(2000..2020), month: rand(1..12) }
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with invalid year/month params' do
        it do
          get :index, params: { year: rand(2000..2020), month: rand(121..142) }
          expect(response).to have_http_status(:ok)
        end
      end

    end

    describe 'GET #all' do

      context 'with valid year/month params' do
        it do
          get :all, params: { year: rand(2000..2020), month: rand(1..12) }
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with invalid year/month params' do
        it do
          get :all, params: { year: rand(2000..2020), month: rand(121..142) }
          expect(response).to have_http_status(:ok)
        end
      end
    end

    describe 'GET #show' do
      it do
        get :show, params: { id: create(:event) }
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'GET #new' do
      it do
        get :new
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'POST #create' do

      let(:action) { -> { post :create, params: { event: event_attributes } } }

      context 'with valid attributes' do

        let(:event_attributes) { attributes_for(:event) }

        it do
          action.call
          should redirect_to(events_path)
        end

        it 'creates event in db' do
          expect {
            action.call
          }.to change { Event.count }.by(1)
        end

        it 'creates event for current user' do
          action.call
          expect(Event.last.user).to eq(current_user)
        end

      end

      context 'with invalid attributes' do

        let(:event_attributes) { attributes_for(:event, :invalid) }

        it do
          action.call
          expect(response).to have_http_status(:ok)
        end

        it 'does not create event in db' do
          expect {
            action.call
          }.not_to(change { Event.count })
        end

      end

    end

    describe 'GET #edit' do

      context "user's event" do
        it do
          get :edit, params: { id: create(:event, user: current_user) }
          expect(response).to have_http_status(:ok)
        end
      end

      context 'non-user event' do
        it do
          expect {
            get :edit, params: { id: create(:event) }
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

    end

    describe 'PATCH #update' do

      let(:action) { -> { patch :update, params: { id: event, event: event_attributes } } }

      context 'non-user event' do
        let(:event) { create(:event) }
        let(:event_attributes) { {} }

        it do
          expect {
            action.call
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context "user's event" do
        let!(:event) { create(:event, user: current_user) }

        context 'with valid attributes' do
          let(:event_attributes) { attributes_for(:event) }

          it do
            action.call
            should redirect_to(events_path)
          end

          it 'updates event in db' do
            action.call

            event.reload
            expect(event.title).to eq(event_attributes[:title])
          end
        end

        context 'with invalid attributes' do
          let(:event_attributes) { attributes_for(:event, :invalid) }

          it do
            action.call
            expect(response).to have_http_status(:ok)
          end

          it 'does not update event in db' do
            previous_title = event.title
            action.call

            event.reload
            expect(event.title).to eq(previous_title)
          end
        end

      end

    end

    describe 'DELETE #destroy' do

      let(:action) { -> { delete :destroy, params: { id: event } } }

      context 'non-user event' do
        let!(:event) { create(:event) }

        it do
          expect {
            action.call
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context "user's event" do
        let!(:event) { create(:event, user: current_user) }

        it do
          action.call
          should redirect_to(events_path)
        end

        it 'removes event from db' do
          expect {
            action.call
          }.to change { Event.count }.by(-1)
          expect(Event.where(id: event.id).exists?).to eq(false)
        end
      end

    end

  end

end
