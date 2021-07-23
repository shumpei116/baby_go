require 'rails_helper'

RSpec.describe 'Stores', type: :system do
  describe '施設新規登録のテスト' do
    let(:user) { create(:user, name: 'shumpei', email: 'shumpei@example.com') }
    context 'ログインしているとき' do
      before do
        sign_in(user)
        visit new_store_path
      end

      context 'フォームの入力値が正しいとき' do
        it '施設の登録に成功すること' do
          expect {
            fill_in '名前',	with: '東松屋'
            fill_in '施設の紹介',	with: '綺麗で広くて使いやすい授乳室がありました'
            fill_in '郵便番号',	with: '1111111'
            select '茨城県', from: '都道府県'
            fill_in '市区町村番地',	with: 'テスト市テスト町1-1-1'
            fill_in 'URL',	with: 'https://github.com/shumpei116'
            click_button '施設を登録する'
            expect(page).to have_selector '.alert-success', text: '施設を登録したよ！ありがとう！'
          }.to change(Store, :count).by(1)
        end
      end

      context 'フォームの入力値が正しくないとき' do
        it '施設の登録に失敗すること' do
          expect {
            fill_in '名前',	with: '東松屋'
            fill_in '施設の紹介',	with: ''
            fill_in '郵便番号',	with: '1111111'
            select '茨城県', from: '都道府県'
            fill_in '市区町村番地',	with: 'テスト市テスト町1-1-1'
            fill_in 'URL',	with: 'https://github.com/shumpei116'
            click_button '施設を登録する'
            expect(page).to have_selector '#error_explanation', text: 'エラーが発生したため 施設 は保存されませんでした'
          }.to_not change(User, :count)
        end
      end
    end

    context 'ログインしていないとき' do
      it 'ログインページにリダイレクトされること' do
        visit new_store_path
        expect(current_path).to eq new_user_session_path
        expect(page).to have_selector '.alert-alert', text: 'ログインもしくはアカウント登録してください'
      end
    end
  end

  describe '詳細ページのテスト' do
    let(:user) { create(:user, name: 'shumpei', email: 'shumpei@example.com') }
    let(:store) {
      create(:store, name: 'あかちゃん本舗', introduction: '綺麗な授乳室でした', postcode: '1111111',
                     prefecture_code: '北海道', city: '函館市1-1-1', url: 'https://stores.akachan.jp/224', user: user)
    }

    before do
      visit store_path(store)
    end

    it '施設情報が表示されていること' do
      expect(page).to have_content 'あかちゃん本舗'
      expect(page).to have_content '綺麗な授乳室でした'
      expect(page).to have_link 'https://stores.akachan.jp/224'
      expect(page).to have_content '1111111'
      expect(page).to have_content '北海道'
      expect(page).to have_content '函館市1-1-1'
      expect(page).to have_selector('img[alt=施設画像]')
    end

    it '投稿者名が表示されていること' do
      expect(page).to have_selector '.figure-caption', text: 'shumpei'
    end
  end
end
