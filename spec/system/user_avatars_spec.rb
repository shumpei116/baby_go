require 'rails_helper'

RSpec.describe 'UserAvatars', type: :system do
  describe 'ユーザー画像のテスト' do
    let(:user) { create(:user) }

    before do
      sign_in(user)
      visit user_path(user)
    end

    describe '画像アップロードのテスト' do
      context '許可されたファイル形式でアップロードされたとき' do
        it '画像が設定できること' do
          click_link '編集'
          attach_file 'user[avatar]', Rails.root.join('spec/factories/avatar/valid_image.jpg')
          click_button 'アカウントを変更する'
          expect(page).to have_current_path(user_path(user))
          expect(page).to have_content 'アカウント情報を変更しました'
          expect(page).to have_selector("img[src$='thumb_valid_image.jpg']")
        end
      end

      context '許可されていないファイル形式でアップロードされたとき' do
        it '画像の設定が失敗すること' do
          click_link '編集'
          attach_file 'user[avatar]', Rails.root.join('spec/factories/avatar/invalid_image.txt')
          click_button 'アカウントを変更する'
          expect(page).to have_selector '#error_explanation', text: 'エラーが発生したため ユーザー は保存されませんでした'
          expect(page).to have_selector '#error_explanation', text: 'アップロードできるファイルタイプ: jpg, jpeg, gif, png'
        end
      end

      context '5.0MB以下の画像がアップロードされたとき' do
        it '画像が設定できること' do
          click_link '編集'
          attach_file 'user[avatar]', Rails.root.join('spec/factories/avatar/5MB_image.jpg')
          click_button 'アカウントを変更する'
          expect(page).to have_current_path(user_path(user))
          expect(page).to have_content 'アカウント情報を変更しました'
          expect(page).to have_selector("img[src$='thumb_5MB_image.jpg']")
        end
      end

      context '5.0MBより大きな画像がアップロードされたとき' do
        it '画像の設定が失敗すること' do
          click_link '編集'
          attach_file 'user[avatar]', Rails.root.join('spec/factories/avatar/6MB_image.jpg')
          click_button 'アカウントを変更する'
          expect(page).to have_selector '#error_explanation', text: 'エラーが発生したため ユーザー は保存されませんでした'
          expect(page).to have_selector '#error_explanation', text: 'ユーザー画像を5MB以下のサイズにしてください'
        end
      end
    end

    describe '画像表示と削除のテスト' do
      context 'ユーザー画像が設定されていないとき' do
        it 'デフォルト画像が表示されること' do
          expect(page).to have_selector("img[src$='thumb_default.jpg']")
        end

        it '画像削除のチェックボックスが表示されないこと' do
          click_link '編集'
          expect(page).to have_current_path(edit_user_registration_path)
          expect(page).to_not have_field('user[remove_avatar]')
        end
      end

      context 'ユーザー画像が設定されているとき' do
        let(:user) { create(:user, :with_avatar) }

        it '設定した画像が表示されること' do
          expect(page).to have_selector("img[src$='thumb_valid_image.jpg']")
        end

        it 'ユーザー画像を削除できること' do
          click_link '編集'
          check 'user[remove_avatar]'
          click_button 'アカウントを変更する'
          expect(page).to have_current_path(user_path(user))
          expect(page).to have_content 'アカウント情報を変更しました'
          expect(page).to have_selector("img[src$='thumb_default.jpg']")
        end
      end
    end
  end
end
