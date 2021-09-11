require 'rails_helper'

RSpec.describe 'Spots', type: :request do
  describe 'GET /index' do
    let!(:first_store) { create(:store) }

    before do
      get spots_path
    end

    it '200レスポンスが返ってくること' do
      expect(response).to have_http_status(200)
    end

    it 'タイトルが含まれること' do
      expect(response.body).to include '現在地から探す'
    end
  end
end
