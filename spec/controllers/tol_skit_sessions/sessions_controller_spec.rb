require 'spec_helper'

describe TolSkitSessions::SessionsController, type: :controller do
  before(:each) do
    @routes = TolSkitSessions::Engine.routes
  end

  let(:user) { FactoryGirl.create(:user) }
  before (:each) do
    user.ensure_authentication_token
  end

  describe 'POST create' do
    context 'no param' do
      before { post :create }

      it 'returns http 400' do
        expect(response.response_code).to eq(400)
      end
    end

    context 'wrong credentials' do
      before { post :create, email: user.email, password: '' }

      it 'returns http 401' do
        expect(response.response_code).to eq(401)
      end
    end

    context 'right credentials' do
      before { post :create, email: user.email, password: user.password }
      subject { JSON.parse response.body }

      it { expect include 'user_id' }
      it { expect include 'auth_token' }

      it 'returns http 201' do
        expect(response.response_code).to eq(201)
      end
    end
  end

  describe 'DELETE destroy' do
    context 'no param' do
      before do
        delete :destroy
      end

      it 'returns http 400' do
        expect(response.response_code).to eq(400)
      end
    end

    context 'wrong credentials' do
      before { delete :destroy, auth_token: '' }

      it 'returns http 401' do
        expect(response.response_code).to eq(401)
      end
    end

    context 'normal auth token param' do
      before { delete :destroy, auth_token: user.authentication_token }
      subject { JSON.parse response.body }

      it { expect include 'user_id' }

      it 'returns http 200' do
        expect(response.response_code).to eq(200)
      end
    end
  end
end
