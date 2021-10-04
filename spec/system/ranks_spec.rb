require 'rails_helper'

RSpec.describe 'Ranks', type: :system do
  describe '一覧ページのテスト' do
    let(:user) { create(:user, name: 'shumpei') }

    describe '表示とリンクのテスト' do
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

      before do
        visit ranks_path
      end

      context '都道府県検索が選択されていないとき' do
        it '全ての施設情報がレビュー平均点順に表示されていること' do
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
            expect(page).to have_content '北海道'
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
            expect(page).to have_content '沖縄県'
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
            expect(page).to have_content '北海道'
            expect(page).to have_link 'shumpei'
          end
          expect(page).to have_selector('.store-card', count: 3)
        end
      end

      context '都道府県検索が選択されているとき' do
        context '選択された都道府県に施設が登録されているとき' do
          it '該当する施設情報のみレビュー平均点順に表示されていること' do
            select '北海道', from: 'q[prefecture_code_cont]'
            click_button '検索'
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
              expect(page).to have_content '北海道'
              expect(page).to have_link 'shumpei'
            end

            within '.store-2' do
              expect(page).to have_selector('img[alt=ランキング2位画像]')
              expect(page).to have_selector('img[alt=施設画像-2]')
              expect(page).to have_selector '.card-title', text: '東松屋'
              expect(page).to have_css ".favorite-#{third_store.id}"
              expect(page).to have_selector '.favorite-count', text: '0'
              expect(page).to have_css '.review-average-rating'
              expect(page).to have_selector '.reviews-average-score', text: '2.0'
              expect(page).to have_selector '.reviews-count', text: '3'
              expect(page).to have_content '広くて新しい授乳室でした'
              expect(page).to have_content '北海道'
              expect(page).to have_link 'shumpei'
            end
            expect(page).to have_selector('.store-card', count: 2)
            expect(page).to_not have_content 'ベビーレストラン'
          end
        end

        context '選択された都道府県に施設が登録されていないとき' do
          it 'コメントと施設登録のリンクが表示されること' do
            select '茨城県', from: 'q[prefecture_code_cont]'
            click_button '検索'
            expect(page).to have_selector('.store-card', count: 0)
            expect(page).to have_content 'まだ施設が投稿されていません'
            expect(page).to have_link 'ここから施設を投稿してみよう！'
          end
        end
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

      it 'タイトルが正しく表示されること' do
        expect(page).to have_title 'レビューランキング - Baby_Go'
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

    describe 'ページネーションのテスト' do
      context '施設情報が10個登録されているとき' do
        let!(:stores) {
          create_list(:store, 10, :rated1, name: 'あかちゃん本舗', introduction: '綺麗な授乳室でした', postcode: '1111111',
                                           prefecture_code: '北海道', user: user)
        }

        before do
          visit ranks_path
        end

        it '.store-cardが10個表示されていること' do
          expect(page).to have_selector('.store-card', count: 10)
        end

        it 'ページネーションリンクが表示されていないこと' do
          expect(page).to_not have_css '.pagination'
        end
      end

      context '施設情報が11個登録されているとき' do
        let!(:stores) {
          create_list(:store, 11, :rated1, name: 'あかちゃん本舗', introduction: '綺麗な授乳室でした', postcode: '1111111',
                                           prefecture_code: '北海道', user: user)
        }

        before do
          visit ranks_path
        end

        it 'ページネーションが2つ表示され2ページ目をクリックすると次ページに遷移して順位は11位から始まること', js: true do
          expect(page).to have_css '.pagination', count: 2
          within '.store-1' do
            expect(page).to have_selector('img[alt=ランキング1位画像]')
          end
          expect(page).to have_selector '.pagination-count', text: "1-10\n/11件中"
          expect(page).to have_css '.store-card', count: 10
          within '.paginate-1' do
            click_link '2'
          end
          expect(page).to have_css '.pagination', count: 2
          within '.store-1' do
            expect(page).to have_content '第11位'
          end
          expect(page).to have_selector '.pagination-count', text: "11-11\n/11件中"
          expect(page).to have_css '.store-card', count: 1
        end
      end
    end

    describe 'スクロールボタンのテスト', js: true do
      let!(:stores) {
        create_list(:store, 10, :rated1, name: 'あかちゃん本舗', introduction: '綺麗な授乳室でした', postcode: '1111111',
                                         prefecture_code: '北海道', user: user)
      }

      before do
        visit ranks_path
      end

      context '画面スクロールが500px以下のとき' do
        it 'scrollボタンが表示されないこと' do
          expect(find('#back', visible: false)).to_not be_visible
          page.execute_script('window.scroll(0, 500)')
          sleep 1
          expect(find('#back', visible: false)).to_not be_visible
          scrolly = page.evaluate_script('window.pageYOffset')
          expect(scrolly).to eq(500)
        end
      end

      context '画面スクロールが501px以上のとき' do
        it 'scrollボタンが表示されてクリックするとページ最上部に遷移すること' do
          expect(find('#back', visible: false)).to_not be_visible
          page.execute_script('window.scroll(0, 501)')
          sleep 1
          scrolly1 = page.evaluate_script('window.pageYOffset')
          expect(scrolly1).to eq(501)
          expect(find('#back', visible: false)).to be_visible
          click_link 'スクロール画像'
          sleep 1
          scrolly2 = page.evaluate_script('window.pageYOffset')
          expect(scrolly2).to eq(0)
        end
      end
    end
  end
end
