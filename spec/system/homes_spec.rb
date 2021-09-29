require 'rails_helper'

RSpec.describe 'Homes', type: :system do
  describe 'ヘッダーのテスト' do
    context 'ログインしていないとき' do
      before do
        visit root_path
      end

      it 'ヘッダーのリンクをクリックするとそれぞれのページに遷移すること' do
        click_link '現在地から探す'
        expect(page).to have_current_path(spots_path)
        click_link 'ランキング'
        expect(page).to have_current_path(ranks_path)
        click_link '施設一覧'
        expect(page).to have_current_path(stores_path)
        click_link 'ログイン'
        expect(page).to have_current_path(new_user_session_path)
        click_link '新規登録'
        expect(page).to have_current_path(new_user_registration_path)
        click_link 'ロゴ画像'
        expect(page).to have_current_path(root_path)
      end

      it '施設の投稿ページをクリックするとログイン画面に遷移すること' do
        click_link '施設の投稿'
        expect(page).to have_current_path(new_user_session_path)
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
        expect(page).to have_current_path(spots_path)
        click_link 'ランキング'
        expect(page).to have_current_path(ranks_path)
        click_link '施設一覧'
        expect(page).to have_current_path(stores_path)
        click_link '施設の投稿'
        expect(page).to have_current_path(new_store_path)
        click_on 'shumpei'
        click_link 'マイページ'
        expect(page).to have_current_path(user_path(user))
        page.accept_confirm do
          click_link 'ロゴ画像'
        end
        expect(page).to have_current_path(root_path)
        click_on 'shumpei'
        page.accept_confirm do
          click_link 'ログアウト'
        end
        expect(page).to have_current_path(root_path)
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

  describe 'ランキングのテスト' do
    let(:user) { create(:user, name: 'shumpei') }
    let!(:first_store) {
      create(:store, :rated1, name: 'あかちゃん本舗', introduction: '綺麗な授乳室でした', postcode: '1111111', prefecture_code: '北海道',
                              city: '函館市1-1-1', user: user)
    }
    let!(:second_store) {
      create(:store, :rated2, name: 'ベビーレストラン', introduction: '個室の和室があって赤ちゃんと一緒でもゆっくりできました', postcode: '1234567',
                              prefecture_code: '沖縄県', city: '那覇市1-1-1', user: user)
    }
    let!(:third_store) {
      create(:store, :rated3, name: '東松屋', introduction: '広くて新しい授乳室でした', postcode: '2222222',
                              prefecture_code: '北海道', city: '稚内市1-1-1', user: user)
    }
    let!(:fourth_store) {
      create(:store, :rated3, name: 'バースデイ', introduction: '子供服が安くてたくさん売っていました', postcode: '3333333',
                              prefecture_code: '大阪府', city: '御堂筋1-1-1', user: user)
    }

    describe '表示とリンクのテスト' do
      before do
        visit root_path
      end

      it '施設情報がレビュー平均点順に3件表示されていること' do
        within '.store-1' do
          expect(page).to have_selector('img[alt=ランキング1位画像]')
          expect(page).to have_selector('img[alt=施設画像-1]')
          expect(page).to have_selector '.card-title', text: 'あかちゃん本舗'
          expect(page).to have_css ".favorite-#{first_store.id}"
          expect(page).to have_selector '.favorite-count', text: '0'
          expect(page).to have_css '.review-average-rating'
          expect(page).to have_selector '.reviews-average-score', text: '4.0'
          expect(page).to have_selector '.reviews-count', text: '3'
          expect(page).to have_content '綺麗な授乳室でした'
          expect(page).to have_content '北海道函館市1-1-1'
          expect(page).to have_link 'shumpei'
        end

        within '.store-2' do
          expect(page).to have_selector('img[alt=ランキング2位画像]')
          expect(page).to have_selector('img[alt=施設画像-2]')
          expect(page).to have_selector '.card-title', text: 'ベビーレストラン'
          expect(page).to have_css ".favorite-#{second_store.id}"
          expect(page).to have_selector '.favorite-count', text: '0'
          expect(page).to have_css '.review-average-rating'
          expect(page).to have_selector '.reviews-average-score', text: '3.0'
          expect(page).to have_selector '.reviews-count', text: '3'
          expect(page).to have_content '個室の和室があって赤ちゃんと一緒でもゆっくりできました'
          expect(page).to have_content '沖縄県那覇市1-1-1'
          expect(page).to have_link 'shumpei'
        end

        within '.store-3' do
          expect(page).to have_selector('img[alt=ランキング3位画像]')
          expect(page).to have_selector('img[alt=施設画像-3]')
          expect(page).to have_selector '.card-title', text: '東松屋'
          expect(page).to have_css ".favorite-#{third_store.id}"
          expect(page).to have_selector '.favorite-count', text: '0'
          expect(page).to have_css '.review-average-rating'
          expect(page).to have_selector '.reviews-average-score', text: '2.0'
          expect(page).to have_selector '.reviews-count', text: '3'
          expect(page).to have_content '広くて新しい授乳室でした'
          expect(page).to have_content '北海道稚内市1-1-1'
          expect(page).to have_link 'shumpei'
        end
        expect(page).to_not have_content 'バースデイ'
        expect(page).to have_selector('.store-card', count: 3)
      end

      it '施設画像をクリックすると施設詳細画面にページ遷移すること' do
        click_link '施設画像-1'
        expect(page).to have_current_path(store_path(first_store))
        expect(page).to have_selector 'h1', text: 'あかちゃん本舗'
      end

      it 'コメントアイコンをクリックすると施設詳細画面にページ遷移すること' do
        within '.store-1' do
          find('.comment-link').click
        end
        expect(page).to have_current_path(store_path(first_store))
        expect(page).to have_selector 'h1', text: 'あかちゃん本舗'
      end

      it 'ユーザー名をクリックするとユーザーの詳細画面に遷移すること' do
        within '.store-1' do
          click_link 'shumpei'
        end
        expect(page).to have_current_path(user_path(user))
        expect(page).to have_selector '.card-title', text: 'shumpei'
      end
    end

    describe 'いいね機能のテスト', js: true do
      context 'ログインしているとき' do
        it '.favorite-store.idをクリックするといいねをつけたり削除したりできること' do
          sign_in(user)
          page.accept_confirm do
            visit root_path
          end
          within '.store-1' do
            expect(page).to have_selector '.favorite-count', text: '0'

            expect {
              find(".favorite-#{first_store.id}").click
              expect(page).to have_css ".favorited-#{first_store.id}"
              expect(page).to have_selector '.favorite-count', text: '1'
            }.to change(Favorite, :count).by(1)

            expect {
              find(".favorited-#{first_store.id}").click
              expect(page).to have_css ".favorite-#{first_store.id}"
              expect(page).to have_selector '.favorite-count', text: '0'
            }.to change(Favorite, :count).by(-1)
          end
        end
      end

      context 'ログインしていないとき' do
        it '.favorite-store.idをクリックするとログインページに遷移すること' do
          page.accept_confirm do
            visit root_path
          end
          within '.store-1' do
            find(".favorite-#{first_store.id}").click
          end
          expect(page).to have_current_path(new_user_session_path)
          expect(page).to have_selector '.alert-alert', text: 'ログインもしくはアカウント登録してください'
        end
      end
    end
  end
end
