require 'rails_helper'

RSpec.describe 'Homes', type: :request do
  describe 'GET /' do
    before do
      get root_path
    end

    it '200レスポンスが返ってくること' do
      expect(response).to have_http_status(200)
    end

    it 'トップ画像が含まれること' do
      expect(response.body).to include 'home_image'
    end

    it 'タイトルが含まれること' do
      expect(response.body).to include 'Baby_Go'
    end

    it '地図が含まれること' do
      expect(response.body).to include '現在地から探す'
    end
  end
end
