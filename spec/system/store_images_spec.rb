require 'rails_helper'

RSpec.describe 'StoreImages', type: :system do
  describe '施設画像のテスト' do
    let(:user) { create(:user) }
    let(:store) { create(:store, user: user) }

    before do
      sign_in(user)
      visit store_path(store)
    end

    describe '画像アップロードのテスト' do
      context '許可されたファイル形式でアップロードされたとき' do
        it '画像が設定できること' do
          click_link '編集'
          attach_file 'store[image]', Rails.root.join('spec/factories/image/valid_image.jpg')
          click_button '更新する'
          expect(current_path).to eq store_path(store)
          expect(page).to have_content '施設の情報を更新しました'
          expect(page).to have_selector("img[src$='thumb_valid_image.jpg']")
        end
      end

      context '許可されていないファイル形式でアップロードされたとき' do
        it '画像の設定が失敗すること' do
          click_link '編集'
          attach_file 'store[image]', Rails.root.join('spec/factories/image/invalid_image.txt')
          click_button '更新する'
          expect(page).to have_selector '#error_explanation', text: 'エラーが発生したため 施設 は保存されませんでした'
          expect(page).to have_selector '#error_explanation', text: 'アップロードできるファイルタイプ: jpg, jpeg, gif, png'
        end
      end

      context '5.0MB以下の画像がアップロードされたとき' do
        it '画像が設定できること' do
          click_link '編集'
          attach_file 'store[image]', Rails.root.join('spec/factories/image/5MB_image.jpg')
          click_button '更新する'
          expect(current_path).to eq store_path(store)
          expect(page).to have_content '施設の情報を更新しました'
          expect(page).to have_selector("img[src$='thumb_5MB_image.jpg']")
        end
      end

      context '5.0MBより大きな画像がアップロードされたとき' do
        it '画像の設定が失敗すること' do
          click_link '編集'
          attach_file 'store[image]', Rails.root.join('spec/factories/image/6MB_image.jpg')
          click_button '更新する'
          expect(page).to have_selector '#error_explanation', text: 'エラーが発生したため 施設 は保存されませんでした'
          expect(page).to have_selector '#error_explanation', text: '施設の画像を5MB以下のサイズにしてください'
        end
      end
    end

    describe '画像表示と削除のテスト' do
      context '施設画像が設定されていないとき' do
        it 'デフォルト画像が表示されること' do
          expect(page).to have_selector("img[src$='thumb_default_store.jpg']")
        end

        it '画像削除のチェックボックスが表示されないこと' do
          click_link '編集'
          expect(current_path).to eq edit_store_path(store)
          expect(page).to_not have_field('store[remove_image]')
        end
      end

      context '施設画像が設定されているとき' do
        let(:store) { create(:store, :with_image, user: user) }

        it '設定した画像が表示されること' do
          expect(page).to have_selector("img[src$='thumb_valid_image.jpg']")
        end

        it '施設画像を削除できること' do
          click_link '編集'
          check 'store[remove_image]'
          click_button '更新する'
          expect(current_path).to eq store_path(store)
          expect(page).to have_content '施設の情報を更新しました'
          expect(page).to have_selector("img[src$='thumb_default_store.jpg']")
        end
      end
    end
  end
end
