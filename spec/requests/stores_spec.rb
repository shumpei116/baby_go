require 'rails_helper'

RSpec.describe 'Stores', type: :request do
  let(:user) { create(:user, name: 'chiaki', email: 'chiaki@example.com') }
  let!(:store) {
    create(:store, name: 'あかちゃん本舗', introduction: '綺麗な授乳室でした', postcode: '1111111',
                   prefecture_code: '北海道', city: '函館市1-1-1', url: 'https://stores.akachan.jp/224', user: user)
  }

  describe 'GET #index' do
    before do
      get stores_path
    end

    it '200レスポンスが返ってくること' do
      expect(response).to have_http_status(200)
    end

    it '施設名が含まれること' do
      expect(response.body).to include 'あかちゃん本舗'
    end

    it '施設紹介が含まれること' do
      expect(response.body).to include '綺麗な授乳室でした'
    end

    it '都道府県名が含まれること' do
      expect(response.body).to include '北海道'
    end

    it '情報提供者名が含まれること' do
      expect(response.body).to include 'chiaki'
    end
  end

  describe 'GET #show' do
    before do
      get store_path(store)
    end

    it '200レスポンスが返ってくること' do
      expect(response).to have_http_status(200)
    end

    it '施設名が含まれること' do
      expect(response.body).to include 'あかちゃん本舗'
    end

    it '施設紹介が含まれること' do
      expect(response.body).to include '綺麗な授乳室でした'
    end

    it '郵便番号が含まれること' do
      expect(response.body).to include '1111111'
    end

    it '都道府県名が含まれること' do
      expect(response.body).to include '北海道'
    end

    it '市区町村名が含まれること' do
      expect(response.body).to include '函館市1-1-1'
    end

    it 'URLが含まれること' do
      expect(response.body).to include 'https://stores.akachan.jp/224'
    end
  end

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

  describe 'POST #create' do
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

  describe 'GET #edit' do
    context 'ユーザーがログイン済みのとき' do
      context 'current_userと@store.userが等しいとき' do
        before do
          sign_in(user)
          get edit_store_path(store)
        end

        it '200レスポンスが返ってくること' do
          expect(response).to have_http_status(200)
        end

        it '施設名が含まれること' do
          expect(response.body).to include 'あかちゃん本舗'
        end

        it '施設紹介が含まれること' do
          expect(response.body).to include '綺麗な授乳室でした'
        end

        it '郵便番号が含まれること' do
          expect(response.body).to include '1111111'
        end

        it '都道府県名が含まれること' do
          expect(response.body).to include '北海道'
        end

        it '市区町村名が含まれること' do
          expect(response.body).to include '函館市1-1-1'
        end

        it 'URLが含まれること' do
          expect(response.body).to include 'https://stores.akachan.jp/224'
        end
      end

      context 'current_userと@store.userが等しくないとき' do
        let(:other_user) { create(:user) }

        before do
          sign_in(other_user)
          get edit_store_path(store)
        end

        it '302レスポンスが返ってくること' do
          expect(response).to have_http_status(302)
        end

        it 'トップページにリダイレクトされること' do
          expect(response).to redirect_to(root_path)
        end
      end
    end

    context 'ユーザーがログインしていないとき' do
      before do
        get edit_store_path(store)
      end

      it '302レスポンスが返ってくること' do
        expect(response).to have_http_status(302)
      end

      it 'ログインページにリダイレクトされること' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH #update' do
    context 'ユーザーがログイン済みのとき' do
      before do
        sign_in(user)
      end

      context 'current_userと@store.userが等しいとき' do
        context 'パラメータが正しいとき' do
          it '302レスポンスが返ってくること' do
            patch store_path(store), params: { store: attributes_for(:store) }
            expect(response).to have_http_status(302)
          end

          it '施設名が更新されること' do
            expect {
              patch store_path(store), params: { store: attributes_for(:store, name: '東松屋') }
            }.to change { Store.find(store.id).name }.from('あかちゃん本舗').to('東松屋')
          end

          it '施設詳細画面にリダイレクトされること' do
            patch store_path(store), params: { store: attributes_for(:store) }
            expect(response).to redirect_to(store_path(store))
          end
        end

        context 'パラメーターが正しくないとき' do
          it '200レスポンスが返ってくること' do
            patch store_path(store), params: { store: attributes_for(:store, :invalid) }
            expect(response).to have_http_status(200)
          end

          it '施設名が変更されないこと' do
            expect {
              patch store_path(store), params: { store: attributes_for(:store, :invalid) }
            }.to_not change(Store.find(store.id), :name)
          end

          it 'エラーが含まれること' do
            patch store_path(store), params: { store: attributes_for(:store, :invalid) }
            expect(response.body).to include '施設の名前が入力されていません'
          end
        end
      end

      context 'current_userと@store.userが等しくないとき' do
        let(:other_user) { create(:user) }

        before do
          sign_in(other_user)
          patch store_path(store)
        end

        it '302レスポンスが返ってくること' do
          expect(response).to have_http_status(302)
        end

        it 'トップページにリダイレクトされること' do
          expect(response).to redirect_to(root_path)
        end
      end
    end

    context 'ユーザーがログインしていないとき' do
      before do
        patch store_path(store)
      end

      it '302レスポンスが返ってくること' do
        expect(response).to have_http_status(302)
      end

      it 'ログインページにリダイレクトされること' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'ユーザーがログイン済みのとき' do
      context 'current_userと@store.userが等しいとき' do
        before do
          sign_in(user)
        end

        it '302レスポンスが返ってくること' do
          delete store_path(store)
          expect(response).to have_http_status(302)
        end

        it '施設が削除されること' do
          expect {
            delete store_path(store)
          }.to change(Store, :count).by(-1)
        end

        it 'ユーザー詳細ページにリダイレクトすること' do
          delete store_path(store)
          expect(response).to redirect_to(user_path(user))
        end
      end

      context 'current_userと@store.userが等しくないとき' do
        let(:other_user) { create(:user) }

        before do
          sign_in(other_user)
          delete store_path(store)
        end

        it '302レスポンスが返ってくること' do
          expect(response).to have_http_status(302)
        end

        it 'トップページにリダイレクトされること' do
          expect(response).to redirect_to(root_path)
        end
      end
    end

    context 'ユーザーがログインしていないとき' do
      before do
        delete store_path(store)
      end

      it '302レスポンスが返ってくること' do
        expect(response).to have_http_status(302)
      end

      it 'ログインページにリダイレクトされること' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
