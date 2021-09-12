require 'rails_helper'

RSpec.describe 'Homes', type: :system do
  describe 'ヘッダーのテスト' do
    context 'ログインしていないとき' do
      before do
        visit root_path
      end

      it 'ヘッダーのリンクをクリックするとそれぞれのページに遷移すること' do
        click_link '現在地から探す'
        expect(current_path).to eq spots_path
        click_link 'ランキング'
        expect(current_path).to eq ranks_path
        click_link '施設一覧'
        expect(current_path).to eq stores_path
        click_link 'ログイン'
        expect(current_path).to eq new_user_session_path
        click_link '新規登録'
        expect(current_path).to eq new_user_registration_path
        click_link 'Baby_Go'
        expect(current_path).to eq root_path
      end

      it '施設の投稿ページをクリックするとログイン画面に遷移すること' do
        click_link '施設の投稿'
        expect(current_path).to eq new_user_session_path
      end
    end

    context 'ログインしているとき' do
      let(:user) { create(:user, name: 'shumpei') }

      it 'ヘッダーのリンクをクリックするとそれぞれのページに遷移すること', js: true do
        sign_in(user)
        page.accept_confirm do
          visit root_path
        end
        page.accept_confirm do
          click_link '現在地から探す'
        end
        expect(current_path).to eq spots_path
        click_link 'ランキング'
        expect(current_path).to eq ranks_path
        click_link '施設一覧'
        expect(current_path).to eq stores_path
        click_link '施設の投稿'
        expect(current_path).to eq new_store_path
        click_on 'shumpei'
        click_link 'マイページ'
        expect(current_path).to eq user_path(user)
        page.accept_confirm do
          click_link 'Baby_Go'
        end
        expect(current_path).to eq root_path
        click_on 'shumpei'
        page.accept_confirm do
          click_link 'ログアウト'
        end
        expect(current_path).to eq root_path
      end
    end
  end

  describe '表示のテスト' do
    before do
      visit root_path
    end

    it 'タイトルが正しく表示されること' do
      expect(page).to have_title 'Baby_Go'
    end

    it 'トップ画像とメッセージが表示されていること' do
      expect(page).to have_selector('img[alt=トップ画像]')
      within '.top-card' do
        expect(page).to have_content 'さぁ 家族で出かけよう'
        expect(page).to have_selector '.site-title', text: 'Baby_Go'
        expect(page).to have_content 'Baby_Goは赤ちゃんと一緒にお出かけできるスポットを共有・検索できるサイトです'
      end
    end

    it '現在地から探すが表示されていること' do
      expect(page).to have_selector 'h2', text: '現在地から探す'
    end
  end
end
