
require 'spec_helper'

describe Api::UsersController, type: :controller do

  let(:user) { FactoryGirl.create(:user) }
  before(:each) do
    user
  end

  describe 'GET show' do
    context 'unauthorized' do
      before do
        get :show, id: user.id
      end

      it 'returns http 401' do
        expect(response.response_code).to eq(401)
      end
    end

    context 'authorized' do
      before do
        user.ensure_authentication_token
        get :show, id: user.id, auth_token: user.authentication_token
      end
      subject { JSON.parse response.body }

      it 'wraps around user' do
        expect include 'user'
      end

      context 'inside user' do
        subject { JSON.parse(response.body)['user'] }
        it { expect include 'id' }
        it { expect include 'email' }
        it { expect include 'param' }
      end

      it 'returns http 200' do
        expect(response.response_code).to eq(200)
      end
    end
  end


end
