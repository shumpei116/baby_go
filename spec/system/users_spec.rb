require 'rails_helper'

RSpec.describe 'Users', type: :system do
  describe '詳細ページのテスト' do
    let(:user) { create(:user, name: 'shumpei', introduction: 'よろしくお願いします！', email: 'shumpei@example.com') }
    let(:other_user) { create(:user, name: 'ちはるちゃんママ', introduction: 'いっぱい投稿します', email: 'chiaki@example.com') }

    describe 'ユーザー詳細のテスト' do
      context 'ログインしているとき' do
        before do
          sign_in(user)
        end

        context 'current_userの詳細ページのとき' do
          before do
            visit user_path(user)
          end
          it '名前・自己紹介・メールアドレス・編集ボタンが表示されていること' do
            expect(page).to have_selector('img[alt=ユーザー画像]')
            expect(page).to have_selector '.card-title', text: 'shumpei'
            expect(page).to have_selector '.card-introduction', text: 'よろしくお願いします！'
            expect(page).to have_selector '.card-email', text: 'shumpei@example.com'
            expect(page).to have_link '編集'
          end

          it '編集ボタンを押したらユーザーの編集ページに遷移すること' do
            click_link '編集'
            expect(current_path).to eq edit_user_registration_path
            expect(page).to have_field '名前', with: 'shumpei'
          end
        end

        context 'current_user以外の詳細ページのとき' do
          it '名前・自己紹介のみ表示されていること' do
            visit user_path(other_user)
            expect(page).to have_selector('img[alt=ユーザー画像]')
            expect(page).to have_selector '.card-title', text: 'ちはるちゃんママ'
            expect(page).to have_selector '.card-introduction', text: 'いっぱい投稿します'
            expect(page).to_not have_selector '.card-email', text: 'chiaki@example.com'
            expect(page).to_not have_link '編集'
          end
        end
      end

      context 'ログインしていないとき' do
        it '名前・自己紹介のみ表示されていること' do
          visit user_path(user)
          expect(page).to have_selector('img[alt=ユーザー画像]')
          expect(page).to have_selector '.card-title', text: 'shumpei'
          expect(page).to have_selector '.card-introduction', text: 'よろしくお願いします！'
          expect(page).to_not have_selector '.card-email', text: 'shumpei@example.com'
          expect(page).to_not have_link '編集'
        end
      end
    end

    describe 'ユーザーが投稿した施設一覧のテスト' do
      let!(:store1) {
        create(:store, name: 'あかちゃん本舗', introduction: '綺麗な授乳室でした', postcode: '1111111', prefecture_code: '北海道',
                       city: '函館市1-1-1', user: user)
      }
      let!(:store2) {
        create(:store, name: 'ベビーレストラン', introduction: '個室の和室があって赤ちゃんと一緒でもゆっくりできました', postcode: '1234567',
                       prefecture_code: '沖縄県', city: '那覇市1-1-1', user: user)
      }
      let!(:store3) {
        create(:store, name: 'ベービーモール', introduction: '広いおむつ交換スペースがいっぱいありました', postcode: '9876543',
                       prefecture_code: '東京都', city: '新宿区1-1-1', user: other_user)
      }

      before do
        visit user_path(user)
      end

      describe '表示のテスト' do
        it 'ユーザーが投稿した施設が全て表示されていること' do
          expect(page).to have_selector('.store-card', count: user.stores.count)
          within '.store-1' do
            expect(page).to have_selector('img[alt=施設画像-1]')
            expect(page).to have_selector '.card-title', text: 'あかちゃん本舗'
            expect(page).to have_content '綺麗な授乳室でした'
            expect(page).to have_content '北海道'
          end

          within '.store-2' do
            expect(page).to have_selector('img[alt=施設画像-2]')
            expect(page).to have_selector '.card-title', text: 'ベビーレストラン'
            expect(page).to have_content '個室の和室があって赤ちゃんと一緒でもゆっくりできました'
            expect(page).to have_content '沖縄県'
          end
        end

        it 'ユーザー以外が投稿した施設は表示されないこと' do
          expect(page).to_not have_content 'ベービーモール'
          expect(page).to_not have_content '広いおむつ交換スペースがいっぱいありました'
          expect(page).to_not have_content '東京都'
        end
      end

      describe 'リンクのテスト' do
        it '施設画像をクリックすると施設詳細画面に遷移すること' do
          click_link '施設画像-1'
          expect(current_path).to eq store_path(store1)
          expect(page).to have_selector 'h2', text: 'あかちゃん本舗'
        end
      end
    end
  end
end
