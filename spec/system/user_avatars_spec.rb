require 'rails_helper'

RSpec.describe 'UserAvatars', type: :system do
  describe 'ユーザー画像のテスト' do
    let(:user) { create(:user) }

    before do
      sign_in(user)
      visit user_path(user)
    end

    it 'ユーザー画像を設定できること' do
      click_link '編集'
      attach_file 'user[avatar]', Rails.root.join('spec/factories/test_image.jpg')
      click_button 'アカウントを変更する'
      expect(current_path).to eq user_path(user)
      expect(page).to have_content 'アカウント情報を変更しました'
      expect(page).to have_selector("img[src$='medium_thumb_test_image.jpg']")
    end

    context 'ユーザー画像が設定されていないとき' do
      it 'デフォルト画像が表示されること' do
        expect(page).to have_selector("img[src$='medium_thumb_default.jpg']")
      end

      it '画像削除のチェックボックスが表示されないこと' do
        click_link '編集'
        expect(current_path).to eq edit_user_registration_path
        expect(page).to_not have_field('user[remove_avatar]')
      end
    end

    context 'ユーザー画像が設定してあるとき' do
      let(:user) { create(:user, :with_avatar) }

      it '設定した画像が表示されること' do
        expect(page).to have_selector("img[src$='medium_thumb_test_image.jpg']")
      end

      it 'ユーザー画像を削除できること' do
        click_link '編集'
        check 'user[remove_avatar]'
        click_button 'アカウントを変更する'
        expect(current_path).to eq user_path(user)
        expect(page).to have_content 'アカウント情報を変更しました'
        expect(page).to have_selector("img[src$='medium_thumb_default.jpg']")
      end
    end
  end
end
