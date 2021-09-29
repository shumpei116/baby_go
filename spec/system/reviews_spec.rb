require 'rails_helper'

RSpec.describe 'Reviews', type: :system, js: true do
  describe '施設詳細ページレビューのテスト' do
    let(:user1) { create(:user, name: 'ちはるママ') }
    let(:user2) { create(:user, name: 'ちあきパパ') }
    let(:store) { create(:store) }
    let(:other_store) { create(:store) }
    let!(:review1) { create(:review, store: store, user: user1, rating: 2.0, comment: 'まあまあでした') }
    let!(:review2) { create(:review, store: store, user: user2, rating: 4.5, comment: 'とってもよかったです') }
    let!(:other_review) { create(:review, store: other_store, comment: '最高でした') }

    describe '表示のテスト' do
      context 'レビューが投稿されているとき' do
        it '施設詳細ページにその施設のレビューのみ全て表示されること' do
          visit store_path(store)
          expect(page).to have_current_path(store_path(store))
          expect(page).to have_selector 'h2', text: '利用したパパママからのメッセージ'
          expect(page).to_not have_content '最高でした'

          within '.review-1' do
            expect(page).to have_content 'ちあきパパ'
            expect(page).to have_content 'とってもよかったです'
            expect(find("#store_rate#{review2.id}").find('input', visible: false).value).to eq '4.5'
          end

          within '.review-2' do
            expect(page).to have_content 'ちはるママ'
            expect(page).to have_content 'まあまあでした'
            expect(find("#store_rate#{review1.id}").find('input', visible: false).value).to eq '2'
          end
        end
      end

      context 'レビューが投稿されていないとき' do
        let(:no_review_store) { create(:store) }

        it 'レビューが投稿されていないメッセージが表示されること' do
          visit store_path(no_review_store)
          expect(page).to have_current_path(store_path(no_review_store))
          expect(page).to have_selector 'h5', text: '投稿されたレビューはありません'
          expect(page).to have_selector 'p', text: '利用した感想を投稿してみてね'
        end
      end

      describe 'ページネーションのテスト' do
        let!(:reviews) { create_list(:review, 3, store: store) }

        context '施設レビューが5個登録されているとき' do
          before do
            visit store_path(store)
          end

          it '.cardが5個表示されていること' do
            expect(page).to have_selector('.card', count: 5)
          end

          it 'ページネーションリンクが表示されていないこと' do
            expect(page).to_not have_css '.pagination'
          end
        end

        context '施設レビューが6個登録されているとき' do
          let!(:review6) { create(:review, store: store) }

          before do
            visit store_path(store)
          end

          it 'ページネーションが1つ表示され2ページ目をクリックすると次ページに遷移すること', js: true do
            expect(page).to have_css '.pagination', count: 1
            expect(page).to have_selector '.pagination-count', text: "1-5\n/6件中"
            expect(page).to have_css '.card', count: 5
            within '.paginate' do
              click_link '2'
            end
            expect(page).to have_css '.pagination', count: 1
            expect(page).to have_selector '.pagination-count', text: "6-6\n/6件中"
            expect(page).to have_css '.card', count: 1
          end
        end
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
          expect(page).to have_content 'ちはるママさんからのレビューを書いてみよう！'
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
          expect(page).to have_current_path(store_path(store))
          expect(page).to_not have_content 'ちはるママさんからのレビューを書いてみよう！'
          expect(page).to_not have_selector 'review_comment'
          expect(page).to_not have_button 'レビューを投稿する'
        end
      end
    end

    context 'ログインしていないとき' do
      it '投稿フォームが表示されないこと' do
        visit store_path(store)
        expect(page).to have_current_path(store_path(store))
        expect(page).to_not have_content 'ちはるママさんからのレビューを書いてみよう！'
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
          click_link '修正'
        end

        it 'タイトルが正しく表示されること' do
          expect(page).to have_title 'レビューの修正 - Baby_Go'
        end

        context 'フォームの入力値が正しいとき' do
          it '編集に成功すること' do
            expect(page).to have_current_path(edit_store_review_path(store))
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
          expect(page).to have_current_path(store_path(store))
          expect(page).to_not have_link '修正'
        end
      end
    end

    context 'ログインしていないとき' do
      it '編集ボタンが表示されないこと' do
        visit store_path(store)
        expect(page).to have_current_path(store_path(store))
        expect(page).to_not have_link '修正'
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
              click_link '削除'
            end
            expect(page).to have_selector '.alert-success', text: 'レビューを削除しました'
            expect(page).to have_current_path(store_path(store))
          }.to change(Review, :count).by(-1)
        end
      end

      context 'その施設のレビューを投稿していないとき' do
        it '削除ボタンが表示されないこと' do
          visit store_path(store)
          expect(page).to have_current_path(store_path(store))
          expect(page).to_not have_link '削除'
        end
      end
    end

    context 'ログインしていないとき' do
      it '削除ボタンが表示されないこと' do
        visit store_path(store)
        expect(page).to have_current_path(store_path(store))
        expect(page).to_not have_link '削除'
      end
    end
  end
end
