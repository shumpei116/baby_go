require 'rails_helper'

RSpec.describe 'Ranks', type: :request do
  describe 'GET /index' do
    let!(:first_store) { create(:store, :rated2) }

    before do
      get ranks_path
    end

    it '200レスポンスが返ってくること' do
      expect(response).to have_http_status(200)
    end

    it '順位が含まれること' do
      expect(response.body).to include '第1位'
    end

    it '施設名が含まれること' do
      expect(response.body).to include '赤ちゃんの本舗'
    end

    it '施設紹介が含まれること' do
      expect(response.body).to include '授乳室とおむつ交換スペースが完備！　綺麗で広くてとっても利用しやすいです'
    end

    it '都道府県名が含まれること' do
      expect(response.body).to include '栃木県'
    end

    it '情報提供者名が含まれること' do
      expect(response.body).to include 'test'
    end
  end
end
