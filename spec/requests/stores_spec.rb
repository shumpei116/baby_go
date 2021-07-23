require 'rails_helper'

RSpec.describe 'Stores', type: :request do
  let(:user) { create(:user, name: 'chiaki', email: 'chiaki@example.com') }
  describe 'GET #new' do
    context 'ユーザーがログイン済みのとき' do
      before do
        sign_in(user)
        get new_store_path
      end

      it '200レスポンスが返ってくること' do
        expect(response).to have_http_status(200)
      end
    end

    context 'ユーザーがログインしていないとき' do
      before do
        get new_store_path
      end

      it '302レスポンスが返ってくること' do
        expect(response).to have_http_status(302)
      end

      it 'ログインページにリダイレクトされること' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET #create' do
    before do
      sign_in(user)
    end
    context 'パラメーターが正しいとき' do
      it '302レスポンスが返ってくること' do
        post stores_path, params: { store: attributes_for(:store) }
        expect(response).to have_http_status(302)
      end

      it '施設が登録されること' do
        expect {
          post stores_path, params: { store: attributes_for(:store) }
        }.to change(Store, :count).by(1)
      end
    end

    context 'パラメーターが正しくないとき' do
      it '200レスポンスが返ってくること' do
        post stores_path, params: { store: attributes_for(:store, :invalid) }
        expect(response).to have_http_status(200)
      end

      it 'ユーザーが登録されないこと' do
        expect {
          post stores_path, params: { store: attributes_for(:store, :invalid) }
        }.to_not change(Store, :count)
      end

      it 'エラーが含まれること' do
        post stores_path, params: { store: attributes_for(:store, :invalid) }
        expect(response.body).to include 'エラーが発生したため 施設 は保存されませんでした'
      end
    end
  end
end
