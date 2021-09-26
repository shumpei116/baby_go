require 'rails_helper'

RSpec.describe 'Sessions', type: :system do
  let!(:user) { create(:user, name: 'shumpei', email: 'shumpei@example.com', password: 'password') }

  describe 'ユーザーログインのテスト' do
    before do
      visit new_user_session_path
    end

    it 'タイトルが正しく表示されること' do
      expect(page).to have_title 'ログイン - Baby_Go'
    end

    context 'パラメーターが正しいとき' do
      it 'ログインできること' do
        expect(page).to have_link 'ログイン'
        expect(page).to have_link '新規登録'
        expect(page).to_not have_button 'shumpei'
        fill_in 'メールアドレス',	with: 'shumpei@example.com'
        fill_in 'パスワード',	with: 'password'
        click_button 'ログイン'
        expect(page).to have_current_path(root_path)
        expect(page).to_not have_link 'ログイン'
        expect(page).to_not have_link '新規登録'
        expect(page).to have_button 'shumpei'
      end
    end

    context 'パラメーターが正しくないとき' do
      it 'ログインに失敗すること' do
        fill_in 'メールアドレス',	with: ''
        fill_in 'パスワード',	with: 'password'
        click_button 'ログイン'
        expect(page).to have_current_path(new_user_session_path)
        expect(page).to have_selector '.alert-alert', text: 'メールアドレスまたはパスワードが違います'
      end
    end
  end

  describe 'ユーザーログアウトのテスト', js: true do
    it 'ログアウトに成功すること' do
      sign_in(user)
      visit user_path(user)
      click_button 'shumpei'
      page.accept_confirm do
        click_link 'ログアウト'
      end
      expect(page).to have_current_path(root_path)
      expect(page).to have_selector '.alert-notice', text: 'ログアウトしました'
    end
  end

  describe 'フレンドリフォワーディングのテスト' do
    it 'ログイン後にリクエストしていたページにリダイレクトされること' do
      visit root_path
      click_link '施設の投稿'
      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_selector '.alert-alert', text: 'ログインもしくはアカウント登録してください'
      fill_in 'メールアドレス',	with: 'shumpei@example.com'
      fill_in 'パスワード',	with: 'password'
      click_button 'ログイン'
      expect(page).to have_current_path(new_store_path)
    end
  end

  describe 'ゲストユーザーのテスト' do
    it 'ゲストログインをクリックするとゲストユーザーでログインでき,アカウントの編集はできないこと' do
      visit root_path
      expect(page).to have_link 'ログイン'
      expect(page).to have_link '新規登録'
      click_link 'ゲストログイン'
      expect(page).to_not have_link 'ログイン'
      expect(page).to_not have_link '新規登録'
      expect(page).to have_button 'ゲストユーザー'
      expect(page).to have_selector '.alert-notice', text: 'ゲストユーザーとしてログインしました'

      click_on 'ゲストユーザー'
      click_link 'マイページ'
      click_link '編集'
      fill_in '名前', with: 'ホストユーザー'
      click_on 'アカウントを変更する'
      expect(page).to have_current_path(root_path)
      expect(page).to have_selector '.alert-alert', text: 'ゲストユーザーのアカウント更新はできません'
    end
  end
end
