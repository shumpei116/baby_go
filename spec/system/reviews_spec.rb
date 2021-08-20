require 'rails_helper'

RSpec.describe 'Reviews', type: :system, js: true do
  describe 'レビュー表示のテスト' do
    let(:user1) { create(:user, name: 'ちはるママ') }
    let(:user2) { create(:user, name: 'ちあきパパ') }
    let(:store) { create(:store) }
    let(:other_store) { create(:store) }
    let!(:review1) { create(:review, store: store, user: user1, rating: 2.0, comment: 'まあまあでした') }
    let!(:review2) { create(:review, store: store, user: user2, rating: 4.5, comment: 'とってもよかったです') }
    let!(:review3) { create(:review, store: other_store, comment: '最高でした') }

    it '施設詳細ページにその施設のレビューのみ全て表示されること' do
      visit store_path(store)
      expect(current_path).to eq store_path(store)
      expect(page).to have_selector 'h4', text: '利用したパパママからのメッセージ'
      expect(page).to_not have_content '最高でした'

      within '.review-1' do
        expect(page).to have_content 'ちはるママ'
        expect(page).to have_content 'まあまあでした'
        expect(find("#store_rate#{review1.id}").find('input', visible: false).value).to eq '2'
      end

      within '.review-2' do
        expect(page).to have_content 'ちあきパパ'
        expect(page).to have_content 'とってもよかったです'
        expect(find("#store_rate#{review2.id}").find('input', visible: false).value).to eq '4.5'
      end
    end
  end

  describe 'レビュー投稿のテスト' do
    let(:user) { create(:user, name: 'ちはるママ') }
    let(:store) { create(:store) }

    context 'ログインしているとき' do
      before do
        sign_in(user)
        visit store_path(store)
      end

      context 'フォームの入力が正しいとき' do
        it '投稿に成功すること' do
          expect(page).to have_content 'ちはるママさんからのメッセージを書いてみてね！'
          expect {
            find('#rating').find("img[alt='5']").click
            fill_in 'review_comment',	with: '最高でした'
            click_button 'レビューを投稿する'
            expect(page).to have_selector '.alert-success', text: 'レビューが投稿されました！'
          }.to change(Review, :count).by(1)
          expect(page).to have_content 'ちはるママ'
          expect(page).to have_content '最高でした'
          expect(find("#store_rate#{Review.first.id}").find('input', visible: false).value).to eq '4.5'
        end
      end

      context 'フォームの入力が正しくないとき' do
        it '投稿に失敗すること' do
          expect {
            find('#rating').find("img[alt='5']").click
            fill_in 'review_comment',	with: ''
            click_button 'レビューを投稿する'
            expect(page).to have_selector '#error_explanation', text: 'エラーが発生したため レビュー は保存されませんでした'
          }.to_not change(Review, :count)
        end
      end

      context 'すでにその施設のレビューを投稿済みのとき' do
        let!(:review) { create(:review, store: store, user: user) }
        it '投稿フォームが表示されないこと' do
          visit store_path(store)
          expect(current_path).to eq store_path(store)
          expect(page).to_not have_content 'ちはるママさんからのメッセージを書いてみてね！'
          expect(page).to_not have_selector 'review_comment'
          expect(page).to_not have_button 'レビューを投稿する'
        end
      end
    end

    context 'ログインしていないとき' do
      it '投稿フォームが表示されないこと' do
        visit store_path(store)
        expect(current_path).to eq store_path(store)
        expect(page).to_not have_content 'ちはるママさんからのメッセージを書いてみてね！'
        expect(page).to_not have_selector 'review_comment'
        expect(page).to_not have_button 'レビューを投稿する'
      end
    end
  end

  describe 'レビュー編集のテスト' do
    let(:user) { create(:user, name: 'ちはるママ') }
    let(:store) { create(:store) }

    context 'ログインしているとき' do
      before do
        sign_in(user)
      end

      context 'その施設のレビューを投稿済みのとき' do
        let!(:review) { create(:review, store: store, user: user, rating: '3', comment: 'そこそこでした') }

        before do
          visit store_path(store)
          click_link '修正する'
        end

        context 'フォームの入力値が正しいとき' do
          it '編集に成功すること' do
            expect(current_path).to eq edit_store_review_path(store)
            expect(page).to have_content 'レビューの修正'
            find('#rating').find("img[alt='5']").click
            fill_in 'review_comment',	with: '最高でした'
            click_button 'レビューを修正する'
            expect(page).to have_content 'ちはるママ'
            expect(page).to have_content '最高でした'
            expect(find("#store_rate#{Review.first.id}").find('input', visible: false).value).to eq '4.5'
          end
        end

        context 'フォームの入力値が正しくないとき' do
          it '編集に失敗すること' do
            find('#rating').find("img[alt='5']").click
            fill_in 'review_comment',	with: ''
            click_button 'レビューを修正する'
            expect(page).to have_selector '#error_explanation', text: 'エラーが発生したため レビュー は保存されませんでした'
          end
        end
      end

      context 'その施設のレビューを投稿していないとき' do
        it '編集ボタンが表示されないこと' do
          visit store_path(store)
          expect(current_path).to eq store_path(store)
          expect(page).to_not have_link '修正する'
        end
      end
    end

    context 'ログインしていないとき' do
      it '編集ボタンが表示されないこと' do
        visit store_path(store)
        expect(current_path).to eq store_path(store)
        expect(page).to_not have_link '修正する'
      end
    end
  end

  describe 'レビュー削除のテスト' do
    let(:user) { create(:user, name: 'ちはるママ') }
    let(:store) { create(:store) }

    context 'ログインしているとき' do
      before do
        sign_in(user)
      end

      context 'その施設のレビューを投稿済みのとき' do
        let!(:review) { create(:review, store: store, user: user, rating: '3', comment: 'そこそこでした') }

        it '削除に成功すること' do
          visit store_path(store)
          expect {
            page.accept_confirm do
              click_link '削除する'
            end
            expect(page).to have_selector '.alert-success', text: 'レビューを削除しました'
            expect(current_path).to eq store_path(store)
          }.to change(Review, :count).by(-1)
        end
      end

      context 'その施設のレビューを投稿していないとき' do
        it '削除ボタンが表示されないこと' do
          visit store_path(store)
          expect(current_path).to eq store_path(store)
          expect(page).to_not have_link '削除する'
        end
      end
    end

    context 'ログインしていないとき' do
      it '削除ボタンが表示されないこと' do
        visit store_path(store)
        expect(current_path).to eq store_path(store)
        expect(page).to_not have_link '削除する'
      end
    end
  end
end