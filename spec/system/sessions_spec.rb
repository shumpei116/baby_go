require 'rails_helper'

RSpec.describe 'Sessions', type: :system do
  let!(:user) { create(:user, name: 'shumpei', email: 'shumpei@example.com', password: 'password') }

  describe 'ユーザーログインのテスト' do
    before do
      visit new_user_session_path
    end

    context 'パラメーターが正しいとき' do
      it 'ログインできること' do
        expect(page).to have_link 'ログイン'
        expect(page).to have_link '新規登録'
        expect(page).to_not have_button 'shumpei'
        fill_in 'メールアドレス',	with: 'shumpei@example.com'
        fill_in 'パスワード',	with: 'password'
        click_button 'Log in'
        expect(current_path).to eq root_path
        expect(page).to_not have_link 'ログイン'
        expect(page).to_not have_link '新規登録'
        expect(page).to have_button 'shumpei'
      end
    end
    context 'パラメーターが正しくないとき' do
      it 'ログインに失敗すること' do
        fill_in 'メールアドレス',	with: ''
        fill_in 'パスワード',	with: 'password'
        click_button 'Log in'
        expect(current_path).to eq new_user_session_path
        expect(page).to have_selector '.alert-alert', text: 'メールアドレスまたはパスワードが違います'
      end
    end
  end

  describe 'ユーザーログアウトのテスト', js: true do
    it 'ログアウトに成功すること' do
      sign_in(user)
      visit user_path(user)
      click_button 'shumpei'
      click_link 'ログアウト'
      expect(current_path).to eq root_path
      expect(page).to have_selector '.alert-notice', text: 'ログアウトしました'
    end
  end

  describe 'フレンドリフォワーディングのテスト' do
    it 'ログイン後にリクエストしたページにリダイレクトされること' do
      visit root_path
      click_link '施設を投稿'
      expect(current_path).to eq new_user_session_path
      expect(page).to have_selector '.alert-alert', text: 'ログインもしくはアカウント登録してください'
      fill_in 'メールアドレス',	with: 'shumpei@example.com'
      fill_in 'パスワード',	with: 'password'
      click_button 'Log in'
      expect(current_path).to eq new_store_path
    end
  end
end
