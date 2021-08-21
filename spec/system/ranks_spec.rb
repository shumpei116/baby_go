require 'rails_helper'

RSpec.describe 'Ranks', type: :system do
  describe '一覧ページのテスト' do
    let(:user) { create(:user, name: 'shumpei') }

    describe '表示とリンクのテスト' do
      let!(:first_store) {
        create(:store, :rated2, name: 'あかちゃん本舗', introduction: '綺麗な授乳室でした', postcode: '1111111', prefecture_code: '北海道',
                                city: '函館市1-1-1', user: user)
      }
      let!(:second_store) {
        create(:store, :rated1, name: 'ベビーレストラン', introduction: '個室の和室があって赤ちゃんと一緒でもゆっくりできました', postcode: '1234567',
                                prefecture_code: '沖縄県', city: '那覇市1-1-1', user: user)
      }

      before do
        visit ranks_path
      end

      it '施設情報がレビュー平均点順に表示されていること' do
        within '.store-1' do
          expect(page).to have_selector('img[alt=施設画像-1]')
          expect(page).to have_selector '.card-title', text: '第1位　あかちゃん本舗'
          expect(page).to have_css ".favorite-#{first_store.id}"
          expect(page).to have_selector '.favorite-count', text: '0'
          expect(page).to have_css '.review-average-rating'
          expect(page).to have_selector '.reviews-average-score', text: '3.0'
          expect(page).to have_selector '.reviews-count', text: '3'
          expect(page).to have_content '綺麗な授乳室でした'
          expect(page).to have_content '北海道'
          expect(page).to have_link 'shumpei'
        end

        within '.store-2' do
          expect(page).to have_selector('img[alt=施設画像-2]')
          expect(page).to have_selector '.card-title', text: '第2位　ベビーレストラン'
          expect(page).to have_selector '.reviews-average-score', text: '2.0'
          expect(page).to have_css ".favorite-#{second_store.id}"
          expect(page).to have_selector '.favorite-count', text: '0'
          expect(page).to have_css '.review-average-rating'
          expect(page).to have_selector '.reviews-count', text: '3'
          expect(page).to have_content '個室の和室があって赤ちゃんと一緒でもゆっくりできました'
          expect(page).to have_content '沖縄県'
          expect(page).to have_link 'shumpei'
        end
        expect(page).to have_selector('.store-card', count: 2)
      end

      it '施設画像をクリックすると施設詳細画面にページ遷移すること' do
        click_link '施設画像-1'
        expect(current_path).to eq store_path(first_store)
        expect(page).to have_selector 'h2', text: 'あかちゃん本舗'
      end

      it 'コメントアイコンをクリックすると施設詳細画面にページ遷移すること' do
        within '.store-1' do
          find('.comment-link').click
        end
        expect(current_path).to eq store_path(first_store)
        expect(page).to have_selector 'h2', text: 'あかちゃん本舗'
      end

      it 'ユーザー名をクリックするとユーザーの詳細画面に遷移すること' do
        within '.store-1' do
          click_link 'shumpei'
        end
        expect(current_path).to eq user_path(user)
        expect(page).to have_selector '.card-title', text: 'shumpei'
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

        it 'ページネーションが2つ表示され2ページ目をクリックすると次ページに遷移すること', js: true do
          expect(page).to have_css '.pagination', count: 2
          expect(page).to have_selector '.pagination-count', text: "1-10\n/11件中"
          expect(page).to have_css '.store-card', count: 10
          within '.paginate-1' do
            click_link '2'
          end
          expect(page).to have_css '.pagination', count: 2
          expect(page).to have_selector '.pagination-count', text: "11-11\n/11件中"
          expect(page).to have_css '.store-card', count: 1
        end
      end
    end
  end
end
