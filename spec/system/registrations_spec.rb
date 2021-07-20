require 'rails_helper'

RSpec.describe 'Registrations', type: :system do
  describe 'ユーザー新規登録のテスト' do
    before do
      visit new_user_registration_path
    end

    context 'フォームの入力値が正しいとき' do
      it 'ユーザーの登録に成功すること' do
        expect {
          fill_in '名前',	with: 'shumpei'
          fill_in 'メールアドレス',	with: 'shumpei@example.com'
          fill_in 'パスワード',	with: 'password'
          fill_in '確認用パスワード',	with: 'password'
          click_button 'アカウントを作成する'
          expect(current_path).to eq root_path
          expect(page).to have_content 'アカウント登録が完了しました'
        }.to change(User, :count).by(1)
      end
    end

    context 'フォームの入力値が正しくないとき' do
      it 'ユーザーの登録に失敗すること' do
        expect {
          fill_in '名前',	with: ''
          fill_in 'メールアドレス',	with: 'shumpei@example.com'
          fill_in 'パスワード',	with: 'password'
          fill_in '確認用パスワード',	with: 'password'
          click_button 'アカウントを作成する'
          expect(page).to have_selector '#error_explanation', text: 'エラーが発生したため ユーザー は保存されませんでした'
        }.to_not change(User, :count)
      end
    end
  end

  describe 'ユーザー編集のテスト' do
    let(:user) { create(:user, name: 'shumpei', email: 'shumpei@example.com') }

    before do
      sign_in(user)
      visit user_path(user)
      expect(page).to have_selector '.card-title', text: 'shumpei'
      expect(page).to have_selector '.card-introduction', text: ''
      expect(page).to have_selector '.card-email', text: 'shumpei@example.com'
      click_link '編集'
    end

    context 'フォームの入力値が正しいとき' do
      it 'ユーザーの編集に成功すること' do
        fill_in '名前', with: 'chiharu'
        fill_in '自己紹介', with: 'こんにちは！'
        fill_in 'メールアドレス', with: 'chiharu@example.com'
        click_button 'アカウントを変更する'
        expect(current_path).to eq user_path(user)
        expect(page).to have_content 'アカウント情報を変更しました'
        expect(page).to have_selector '.card-title', text: 'chiharu'
        expect(page).to have_selector '.card-introduction', text: 'こんにちは！'
        expect(page).to have_selector '.card-email', text: 'chiharu@example.com'
      end
    end

    context 'フォームの入力値が正しくないとき' do
      it 'ユーザーの編集に失敗すること' do
        fill_in '名前', with: 'chiharu'
        fill_in '自己紹介', with: 'こんにちは！'
        fill_in 'メールアドレス', with: ''
        click_button 'アカウントを変更する'
        expect(page).to have_selector '#error_explanation', text: 'エラーが発生したため ユーザー は保存されませんでした'
        visit user_path(user)
        expect(page).to have_selector '.card-title', text: 'shumpei'
        expect(page).to have_selector '.card-introduction', text: ''
        expect(page).to have_selector '.card-email', text: 'shumpei@example.com'
      end
    end
  end
end
