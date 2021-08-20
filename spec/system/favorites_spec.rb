require 'rails_helper'

RSpec.describe 'Favorites', type: :system do
  describe 'いいね機能のテスト', js: true do
    describe '一覧表示のいいねのテスト' do
      let(:user) { create(:user, name: 'shumpei', introduction: 'よろしくお願いします！', email: 'shumpei@example.com') }
      let!(:store) {
        create(:store, name: 'あかちゃん本舗', introduction: '綺麗な授乳室でした', postcode: '1111111', prefecture_code: '北海道',
                       city: '函館市1-1-1', user: user)
      }

      context 'ログインしているとき' do
        it '.favorite-store.idをクリックするといいねをつけたり削除したりできること' do
          sign_in(user)
          visit stores_path
          expect(page).to have_selector 'h3', text: 'みんなが投稿してくれた施設の一覧'
          expect(page).to have_selector '.favorite-count', text: '0'

          expect {
            find(".favorite-#{store.id}").click
            expect(page).to have_css ".favorited-#{store.id}"
            expect(page).to have_selector '.favorite-count', text: '1'
          }.to change(Favorite, :count).by(1)

          expect {
            find(".favorited-#{store.id}").click
            expect(page).to have_css ".favorite-#{store.id}"
            expect(page).to have_selector '.favorite-count', text: '0'
          }.to change(Favorite, :count).by(-1)
        end
      end

      context 'ログインしていないとき' do
        it '.favorite-store.idをクリックするとログインページに遷移すること' do
          visit stores_path
          find(".favorite-#{store.id}").click
          expect(current_path).to eq new_user_session_path
          expect(page).to have_selector '.alert-alert', text: 'ログインもしくはアカウント登録してください'
        end
      end
    end

    describe '施設詳細ページのいいねのテスト' do
      let(:user) { create(:user, name: 'shumpei', introduction: 'よろしくお願いします！', email: 'shumpei@example.com') }
      let!(:store) {
        create(:store, name: 'あかちゃん本舗', introduction: '綺麗な授乳室でした', postcode: '1111111', prefecture_code: '北海道',
                       city: '函館市1-1-1', user: user)
      }

      context 'ログインしているとき' do
        it '.favorite-store.idをクリックするといいねをつけたり削除したりできること' do
          sign_in(user)
          visit store_path(store)
          expect(page).to have_selector 'h2', text: 'あかちゃん本舗'
          expect(page).to have_selector '.favorite-count', text: '0'

          expect {
            find(".favorite-#{store.id}").click
            expect(page).to have_css ".favorited-#{store.id}"
            expect(page).to have_selector '.favorite-count', text: '1'
          }.to change(Favorite, :count).by(1)

          expect {
            find(".favorited-#{store.id}").click
            expect(page).to have_css ".favorite-#{store.id}"
            expect(page).to have_selector '.favorite-count', text: '0'
          }.to change(Favorite, :count).by(-1)
        end
      end

      context 'ログインしていないとき' do
        it '.favorite-store.idをクリックするとログインページに遷移すること' do
          visit store_path(store)
          find(".favorite-#{store.id}").click
          expect(current_path).to eq new_user_session_path
          expect(page).to have_selector '.alert-alert', text: 'ログインもしくはアカウント登録してください'
        end
      end
    end

    describe 'レビューランキングページのいいねのテスト' do
      let(:user) { create(:user, name: 'shumpei') }
      let!(:store) {
        create(:store, :rated2, name: 'あかちゃん本舗', introduction: '綺麗な授乳室でした', postcode: '1111111', prefecture_code: '北海道',
                                city: '函館市1-1-1', user: user)
      }

      context 'ログインしているとき' do
        it '.favorite-store.idをクリックするといいねをつけたり削除したりできること' do
          sign_in(user)
          visit ranks_path
          expect(page).to have_selector 'h2', text: 'レビューランキング'
          expect(page).to have_selector '.favorite-count', text: '0'

          expect {
            find(".favorite-#{store.id}").click
            expect(page).to have_css ".favorited-#{store.id}"
            expect(page).to have_selector '.favorite-count', text: '1'
          }.to change(Favorite, :count).by(1)

          expect {
            find(".favorited-#{store.id}").click
            expect(page).to have_css ".favorite-#{store.id}"
            expect(page).to have_selector '.favorite-count', text: '0'
          }.to change(Favorite, :count).by(-1)
        end
      end

      context 'ログインしていないとき' do
        it '.favorite-store.idをクリックするとログインページに遷移すること' do
          visit ranks_path
          find(".favorite-#{store.id}").click
          expect(current_path).to eq new_user_session_path
          expect(page).to have_selector '.alert-alert', text: 'ログインもしくはアカウント登録してください'
        end
      end
    end
  end
end
