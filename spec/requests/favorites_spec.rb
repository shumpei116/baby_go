require 'rails_helper'

RSpec.describe 'Favorites', type: :request do
  let(:user) { create(:user, name: 'chiaki', email: 'chiaki@example.com') }
  let!(:store) {
    create(:store, name: 'あかちゃん本舗', introduction: '綺麗な授乳室でした', postcode: '1111111',
                   prefecture_code: '北海道', city: '函館市1-1-1', url: 'https://stores.akachan.jp/224', user: user)
  }

  describe 'POST #create' do
    context 'ログイン済みのとき' do
      before do
        sign_in(user)
      end

      it '200レスポンスが返ってくること' do
        post store_favorite_path(store.id), xhr: true
        expect(response).to have_http_status(200)
      end

      it 'いいねされること' do
        expect {
          post store_favorite_path(store.id), xhr: true
        }.to change(Favorite, :count).by(1)
      end
    end

    context 'ログインしていないとき' do
      before do
        post store_favorite_path(store.id), xhr: true
      end

      it '401レスポンスが返ってくること' do
        expect(response).to have_http_status(401)
      end

      it 'エラーの内容が含まれること' do
        expect(response.body).to include 'ログインもしくはアカウント登録してください'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:favorite) { create(:favorite, user: user, store: store) }

    context 'ログイン済みのとき' do
      before do
        sign_in(user)
      end

      it '200レスポンスが返ってくること' do
        delete store_favorite_path(store.id), xhr: true
        expect(response).to have_http_status(200)
      end

      it 'いいねが削除されること' do
        expect {
          delete store_favorite_path(store.id), xhr: true
        }.to change(Favorite, :count).by(-1)
      end
    end

    context 'ログインしていないとき' do
      before do
        delete store_favorite_path(store.id), xhr: true
      end

      it '401レスポンスが返ってくること' do
        expect(response).to have_http_status(401)
      end

      it 'エラーの内容が含まれること' do
        expect(response.body).to include 'ログインもしくはアカウント登録してください'
      end
    end
  end
end
