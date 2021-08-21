require 'rails_helper'

RSpec.describe 'Reviews', type: :request do
  let(:user)   { create(:user, name: 'chiaki', email: 'chiaki@example.com') }
  let!(:store) { create(:store, user: user) }

  describe 'POST /create' do
    context 'ログイン済みのとき' do
      before do
        sign_in(user)
      end

      context 'パラメーターが正しいとき' do
        it '302レスポンスが返ってくること' do
          post store_review_path(store), params: { review: attributes_for(:review, store_id: store.id) }
          expect(response).to have_http_status(302)
        end

        it 'レビューが投稿されること' do
          expect {
            post store_review_path(store), params: { review: attributes_for(:review, store_id: store.id) }
          }.to change(Review, :count).by(1)
        end

        it '施設詳細ページにリダイレクトされること' do
          post store_review_path(store), params: { review: attributes_for(:review, store_id: store.id) }
          expect(response).to redirect_to(store_path(store))
        end
      end

      context 'パラメーターが正しくないとき' do
        it '200レスポンスが返ってくること' do
          post store_review_path(store), params: { review: attributes_for(:review, :invalid, store_id: store.id) }
          expect(response).to have_http_status(200)
        end

        it 'レビューが投稿されないこと' do
          expect {
            post store_review_path(store), params: { review: attributes_for(:review, :invalid, store_id: store.id) }
          }.to_not change(Review, :count)
        end

        it 'エラーが含まれること' do
          post store_review_path(store), params: { review: attributes_for(:review, :invalid, store_id: store.id) }
          expect(response.body).to include 'エラーが発生したため レビュー は保存されませんでした'
        end
      end
    end

    context 'ログインしていないとき' do
      before do
        post store_review_path(store), params: { review: attributes_for(:review, store_id: store.id) }
      end

      it '302レスポンスが返ってくること' do
        expect(response).to have_http_status(302)
      end

      it 'ログインページにリダイレクトされること' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET /edit' do
    let!(:review) { create(:review, user: user, store: store, rating: 3, comment: 'とってもいいところでした') }

    context 'ユーザーがログイン済みのとき' do
      context 'current_userのレビューページのとき' do
        before do
          sign_in(user)
          get edit_store_review_path(store)
        end

        it '200レスポンスが返ってくること' do
          expect(response).to have_http_status(200)
        end

        it '点数が含まれること' do
          expect(response.body).to include '3'
        end

        it '口コミが含まれること' do
          expect(response.body).to include 'とってもいいところでした'
        end
      end

      context 'current_userのレビューページではないとき' do
        let(:other_user) { create(:user) }

        before do
          sign_in(other_user)
          get edit_store_review_path(store)
        end

        it '302レスポンスが返ってくること' do
          expect(response).to have_http_status(302)
        end

        it '施設一覧画面にリダイレクトされること' do
          expect(response).to redirect_to(stores_path)
        end
      end
    end

    context 'ユーザーがログインしていないとき' do
      before do
        get edit_store_review_path(store)
      end

      it '302レスポンスが返ってくること' do
        expect(response).to have_http_status(302)
      end

      it 'ログインページにリダイレクトされること' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH /update' do
    let!(:review) { create(:review, user: user, store: store, rating: 3, comment: 'とってもいいところでした') }

    context 'ユーザーがログイン済みのとき' do
      context 'current_userのレビューのとき' do
        before do
          sign_in(user)
        end

        it '302レスポンスが返ってくること' do
          patch store_review_path(store), params: { review: attributes_for(:review, store_id: store.id) }
          expect(response).to have_http_status(302)
        end

        it '点数が更新されること' do
          expect {
            patch store_review_path(store), params: { review: attributes_for(:review, store_id: store.id, rating: 5) }
          }.to change { Review.find(review.id).rating }.from(3.0).to(5.0)
        end

        it '口コミが更新されること' do
          expect {
            patch store_review_path(store),
                  params: { review: attributes_for(:review, store_id: store.id, comment: '最高でした') }
          }.to change { Review.find(review.id).comment }.from('とってもいいところでした').to('最高でした')
        end

        it '施設詳細画面にリダイレクトされること' do
          patch store_review_path(store), params: { review: attributes_for(:review, store_id: store.id) }
          expect(response).to redirect_to(store_path(store))
        end
      end

      context 'current_userのレビューページではないとき' do
        let(:other_user) { create(:user) }

        before do
          sign_in(other_user)
          patch store_review_path(store)
        end

        it '302レスポンスが返ってくること' do
          expect(response).to have_http_status(302)
        end

        it '施設一覧画面にリダイレクトされること' do
          expect(response).to redirect_to(stores_path)
        end
      end
    end

    context 'ユーザーがログインしていないとき' do
      before do
        patch store_review_path(store)
      end

      it '302レスポンスが返ってくること' do
        expect(response).to have_http_status(302)
      end

      it 'ログインページにリダイレクトされること' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE /destroy' do
    let!(:review) { create(:review, user: user, store: store) }
    context 'ユーザーがログイン済みのとき' do
      context 'current_userのレビューのとき' do
        before do
          sign_in(user)
        end

        it '302レスポンスが返ってくること' do
          delete store_review_path(store)
          expect(response).to have_http_status(302)
        end

        it 'レビューが削除されること' do
          expect {
            delete store_review_path(store)
          }.to change(Review, :count).by(-1)
        end

        it '施設詳細画面にリダイレクトされること' do
          delete store_review_path(store)
          expect(response).to redirect_to(store_path(review.store))
        end
      end

      context 'current_userのレビューページではないとき' do
        let(:other_user) { create(:user) }

        before do
          sign_in(other_user)
          delete store_review_path(store)
        end

        it '302レスポンスが返ってくること' do
          expect(response).to have_http_status(302)
        end

        it '施設一覧画面にリダイレクトされること' do
          expect(response).to redirect_to(stores_path)
        end
      end
    end

    context 'ユーザーがログインしていないとき' do
      before do
        delete store_review_path(store)
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
