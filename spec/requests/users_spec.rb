require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user) { create(:user, name: 'shumpei') }

  describe 'GET #show' do
    before do
      get user_path(user)
    end

    it '200レスポンスが返ってくること' do
      expect(response).to have_http_status(200)
    end

    it '名前が含まれていること' do
      expect(response.body).to include 'shumpei'
    end
  end
end
