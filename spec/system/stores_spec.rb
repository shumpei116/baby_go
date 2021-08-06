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
            attach_file 'store[image]', Rails.root.join('spec/factories/image/valid_image.jpg')
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
      expect(page).to have_selector 'h2', text: 'あかちゃん本舗'
      expect(page).to have_selector 'td', text: 'あかちゃん本舗'
      expect(page).to have_content '綺麗な授乳室でした'
      expect(page).to have_link 'https://stores.akachan.jp/224'
      expect(page).to have_content '1111111'
      expect(page).to have_content '北海道'
      expect(page).to have_content '函館市1-1-1'
      expect(page).to have_selector('img[alt=施設画像]')
      expect(page).to have_content 'shumpei'
    end

    it '投稿者名をクリックするとユーザー詳細画面が表示されること' do
      click_link 'shumpei'
      expect(current_path).to eq user_path(user)
    end
  end

  describe '一覧ページのテスト' do
    let(:user1)   { create(:user, name: 'shumpei') }
    let(:user2)   { create(:user, name: 'ちはるちゃんママ') }

    describe '表示とリンクのテスト' do
      let!(:store1) {
        create(:store, name: 'あかちゃん本舗', introduction: '綺麗な授乳室でした', postcode: '1111111', prefecture_code: '北海道',
                       city: '函館市1-1-1', user: user1)
      }
      let!(:store2) {
        create(:store, name: 'ベビーレストラン', introduction: '個室の和室があって赤ちゃんと一緒でもゆっくりできました', postcode: '1234567',
                       prefecture_code: '沖縄県', city: '那覇市1-1-1', user: user2)
      }

      before do
        visit stores_path
      end

      it '全ての施設情報が表示されていること' do
        within '.store-2' do
          expect(page).to have_selector('img[alt=施設画像-2]')
          expect(page).to have_selector '.card-title', text: 'あかちゃん本舗'
          expect(page).to have_content '綺麗な授乳室でした'
          expect(page).to have_content '北海道'
          expect(page).to have_link 'shumpei'
        end

        within '.store-1' do
          expect(page).to have_selector('img[alt=施設画像-1]')
          expect(page).to have_selector '.card-title', text: 'ベビーレストラン'
          expect(page).to have_content '個室の和室があって赤ちゃんと一緒でもゆっくりできました'
          expect(page).to have_content '沖縄県'
          expect(page).to have_link 'ちはるちゃんママ'
        end
        expect(page).to have_selector('.store-card', count: 2)
      end

      it '施設画像をクリックすると施設詳細画面にページ遷移すること' do
        click_link '施設画像-1'
        expect(current_path).to eq store_path(store2)
        expect(page).to have_selector 'h2', text: 'ベビーレストラン'
      end

      it 'ユーザー名をクリックするとユーザーの詳細画面に遷移すること' do
        click_link 'ちはるちゃんママ'
        expect(current_path).to eq user_path(user2)
        expect(page).to have_selector '.card-title', text: 'ちはるちゃんママ'
      end
    end

    describe 'ページネーションのテスト' do
      context '施設情報が9個登録されているとき' do
        let!(:stores) {
          create_list(:store, 9, name: 'あかちゃん本舗', introduction: '綺麗な授乳室でした', postcode: '1111111',
                                 prefecture_code: '北海道', user: user1)
        }

        before do
          visit stores_path
        end

        it '.store-cardが9個表示されていること' do
          expect(page).to have_selector('.store-card', count: 9)
        end

        it 'ページネーションリンクが表示されていないこと' do
          expect(page).to_not have_css '.pagination'
        end
      end

      context '施設情報が10個登録されているとき' do
        let!(:stores) {
          create_list(:store, 10, name: 'あかちゃん本舗', introduction: '綺麗な授乳室でした', postcode: '1111111',
                                  prefecture_code: '北海道', user: user1)
        }

        before do
          visit stores_path
        end

        it '.store-cardが9個表示されていること' do
          expect(page).to have_selector('.store-card', count: 9)
        end

        it 'ページネーションリンクが2つ表示されること' do
          expect(page).to have_css '.pagination', count: 2
        end
      end
    end
  end

  describe '施設編集のテスト' do
    let(:user) { create(:user, name: 'shumpei', email: 'shumpei@example.com') }
    let(:store) {
      create(:store, name: 'あかちゃん本舗', introduction: '綺麗な授乳室でした', postcode: '1111111',
                     prefecture_code: '北海道', city: '函館市1-1-1', url: 'https://stores.akachan.jp/224', user: user)
    }

    context 'ログインしているとき' do
      context 'current_userと@store.userが等しいとき' do
        before do
          sign_in(user)
          visit store_path(store)
          expect(page).to have_selector 'h2', text: 'あかちゃん本舗'
          expect(page).to have_selector 'td', text: '綺麗な授乳室でした'
          expect(page).to have_selector 'td', text: '1111111'
          expect(page).to have_selector 'td', text: '北海道'
          expect(page).to have_selector 'td', text: '函館市1-1-1'
          expect(page).to have_selector 'td', text: 'https://stores.akachan.jp/224'
          expect(page).to have_selector("img[src$='thumb_default_store.jpg']")
          click_link '編集'
        end

        context 'フォームの入力値が正しいとき' do
          it '編集に成功すること' do
            fill_in '施設の名前',	with: '東松屋'
            fill_in '施設の紹介',	with: '素敵なおむつ交換スペースでした'
            fill_in '郵便番号',	with: '2222222'
            select '沖縄県', from: '都道府県'
            fill_in '市区町村番地',	with: '那覇市2-2-2'
            fill_in '施設参考URL',	with: 'http://localhost:3000/'
            attach_file 'store[image]', Rails.root.join('spec/factories/image/valid_image.jpg')
            click_button '更新する'
            expect(current_path).to eq store_path(store)
            expect(page).to have_content '施設の情報を更新しました'
            expect(page).to have_selector 'h2', text: '東松屋'
            expect(page).to have_selector 'td', text: '素敵なおむつ交換スペースでした'
            expect(page).to have_selector 'td', text: '2222222'
            expect(page).to have_selector 'td', text: '沖縄県'
            expect(page).to have_selector 'td', text: '那覇市2-2-2'
            expect(page).to have_selector 'td', text: 'http://localhost:3000/'
            expect(page).to have_selector("img[src$='thumb_valid_image.jpg']")
          end
        end

        context 'フォームの入力値が正しくないとき' do
          it '編集に失敗すること' do
            fill_in '施設の名前',	with: ''
            click_button '更新する'
            expect(page).to have_selector '#error_explanation', text: 'エラーが発生したため 施設 は保存されませんでした'
            visit store_path(store)
            expect(page).to have_selector 'h2', text: 'あかちゃん本舗'
          end
        end
      end

      context 'current_userと@store.userが等しくないとき' do
        let(:other_user) { create(:user) }

        it '編集ボタンが表示されないこと' do
          sign_in(other_user)
          visit store_path(store)
          expect(current_path).to eq store_path(store)
          expect(page).to_not have_link '編集'
        end
      end
    end

    context 'ログインしていないとき' do
      it '編集ボタンが表示されないこと' do
        visit store_path(store)
        expect(current_path).to eq store_path(store)
        expect(page).to_not have_link '編集'
      end
    end
  end

  describe '施設削除のテスト' do
    let(:user) { create(:user, name: 'shumpei', email: 'shumpei@example.com') }
    let(:store) {
      create(:store, name: 'あかちゃん本舗', introduction: '綺麗な授乳室でした', postcode: '1111111',
                     prefecture_code: '北海道', city: '函館市1-1-1', url: 'https://stores.akachan.jp/224', user: user)
    }

    context 'ログインしているとき' do
      context 'current_userと@store.userが等しいとき' do
        it '施設を削除できること', js: true do
          sign_in(user)
          visit store_path(store)
          expect {
            page.accept_confirm do
              click_link '施設情報を削除する'
            end
            expect(page).to have_selector '.alert-success', text: '施設を削除しました'
            expect(current_path).to eq user_path(user)
          }.to change(Store, :count).by(-1)
        end
      end

      context 'current_userと@store.userが等しくないとき' do
        let(:other_user) { create(:user) }

        it '施設削除ボタンが表示されないこと' do
          sign_in(other_user)
          visit store_path(store)
          expect(current_path).to eq store_path(store)
          expect(page).to_not have_link '施設情報を削除する'
        end
      end
    end

    context 'ログインしていないとき' do
      it '施設削除ボタンが表示されないこと' do
        visit store_path(store)
        expect(current_path).to eq store_path(store)
        expect(page).to_not have_link '施設情報を削除する'
      end
    end
  end
end
