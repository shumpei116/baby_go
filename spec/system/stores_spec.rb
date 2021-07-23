require 'rails_helper'

RSpec.describe "Stores", type: :system do
  describe '施設新規登録のテスト' do
    let(:user) { create(:user, name: 'shumpei', email: 'shumpei@example.com') }
    context "ログインしているとき" do
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

    context "ログインしていないとき" do
      it "ログインページにリダイレクトされること" do
        visit new_store_path
        expect(current_path).to eq new_user_session_path
        expect(page).to have_selector '.alert-alert', text: 'ログインもしくはアカウント登録してください'
      end
    end
  end
end
