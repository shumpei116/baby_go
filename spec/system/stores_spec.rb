require 'rails_helper'

RSpec.describe 'Stores', type: :system do
  describe '施設新規登録のテスト' do
    let(:user) { create(:user, name: 'shumpei', email: 'shumpei@example.com') }

    context 'ログインしているとき', js: true do
      before do
        sign_in(user)
        visit new_store_path
      end

      it 'タイトルが正しく表示されること' do
        expect(page).to have_title '施設の投稿 - Baby_Go'
      end

      it '郵便番号を入力すると都道府県と市区町村番地が自動で入力されること' do
        fill_in '郵便番号', with: '1000001'
        expect(page).to have_select('都道府県', selected: '東京都')
        expect(page).to have_field '市区町村番地', with: '千代田区千代田'
      end

      it '施設紹介フォームの残り文字数が入力文字数に連動して変化すること' do
        expect(page).to have_selector '.js-text-count', text: '残り140文字'
        fill_in '施設の紹介', with: 'a' * 140
        expect(page).to have_selector '.js-text-count', text: '残り0文字'
        fill_in '施設の紹介', with: 'a' * 150
        expect(page).to have_selector '.js-text-count', text: '残り-10文字'
      end

      context 'フォームの入力値が正しいとき' do
        it '施設の登録に成功すること' do
          expect {
            fill_in '名前',	with: '東松屋'
            fill_in '施設の紹介',	with: '綺麗で広くて使いやすい授乳室がありました'
            fill_in '郵便番号',	with: '1000001'
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
            fill_in '郵便番号',	with: '1000001'
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
        expect(page).to have_current_path(new_user_session_path)
        expect(page).to have_selector '.alert-alert', text: 'ログインもしくはアカウント登録してください'
      end
    end
  end

  describe '詳細ページのテスト' do
    let(:user) { create(:user, name: 'shumpei', email: 'shumpei@example.com') }
    let(:store) {
      create(:store, name: 'アカチャンホンポニューポートひたちなか店', introduction: '綺麗な授乳室でした', postcode: '3120005',
                     prefecture_code: '茨城県', city: 'ひたちなか市新光町35', url: 'https://stores.akachan.jp/224', user: user)
    }

    before do
      visit store_path(store)
    end

    it 'タイトルが正しく表示されること' do
      expect(page).to have_title 'アカチャンホンポニューポートひたちなか店 - Baby_Go'
    end

    it '施設情報が表示されていること' do
      expect(page).to have_selector 'h1', text: 'アカチャンホンポニューポートひたちなか店'
      expect(page).to have_css ".favorite-#{store.id}"
      expect(page).to have_selector '.favorite-count', text: '0'
      expect(page).to have_css '.review-average-rating'
      expect(page).to have_selector '.reviews-average-score', text: '0.0'
      expect(page).to have_selector 'td', text: 'アカチャンホンポニューポートひたちなか店'
      expect(page).to have_content '綺麗な授乳室でした'
      expect(page).to have_link 'https://stores.akachan.jp/224'
      expect(page).to have_content '3120005'
      expect(page).to have_content '茨城県ひたちなか市新光町35'
      expect(page).to have_selector('img[alt=施設画像]')
      expect(page).to have_content 'shumpei'
    end

    it '投稿者名をクリックするとユーザー詳細画面が表示されること' do
      click_link 'shumpei'
      expect(page).to have_current_path(user_path(user))
    end

    it '地図が表示されピンをクリックすると施設名と施設紹介・住所が表示されること', js: true do
      expect(page).to have_css '.gm-style'
      pin = find('map#gmimap0 area', visible: false)
      pin.click
      expect(page).to have_css '.gm-style-iw' # infowindow クラスの有無をテスト
      within '.gm-style-iw-d' do
        expect(page).to have_selector 'h5', text: '施設名：アカチャンホンポニューポートひたちなか店'
        expect(page).to have_selector 'p', text: '施設紹介:綺麗な授乳室でした'
        expect(page).to have_selector 'p', text: '住所　:茨城県ひたちなか市新光町35'
      end
    end

    it 'GoogleMapで開くをクリックすると別タブでGoogleMapが開いて施設名が表示されること', js: true do
      googlemap_window = window_opened_by do
        click_link 'GoogleMapで開く'
      end
      within_window googlemap_window do
        expect(page).to have_content 'アカチャンホンポ ニューポートひたちなか店'
      end
    end

    describe 'いいね機能のテスト', js: true do
      context 'ログインしているとき' do
        it '.favorite-store.idをクリックするといいねをつけたり削除したりできること' do
          sign_in(user)
          visit store_path(store)
          expect(page).to have_selector 'h1', text: 'アカチャンホンポニューポートひたちなか店'
          expect(page).to have_selector '.favorite-count', text: '0'

          expect {
            find(".favorite-#{store.id}").click
            expect(page).to have_css ".favorited-#{store.id}"
            expect(page).to have_selector '.favorite-count', text: '1'
          }.to change(Favorite, :count).by(1)

          expect {
            find(".favorited-#{store.id}").click
            expect(page).to have_css ".favorite-#{store.id}"
            expect(page).to have_selector '.favorite-count', text: '0'
          }.to change(Favorite, :count).by(-1)
        end
      end

      context 'ログインしていないとき' do
        it '.favorite-store.idをクリックするとログインページに遷移すること' do
          visit store_path(store)
          find(".favorite-#{store.id}").click
          expect(page).to have_current_path(new_user_session_path)
          expect(page).to have_selector '.alert-alert', text: 'ログインもしくはアカウント登録してください'
        end
      end
    end

    describe 'SNSシェアボタンのテスト', js: true do
      it 'ツイートボタンが表示され、クリックすると別タブでTwitter画面に遷移すること' do
        expect(page).to have_css '.twitter-share-button'
        twitter_window = window_opened_by do
          find('.twitter-share-button').click
        end
        within_window twitter_window do
          expect(page).to have_content 'Twitter'
        end
      end

      it 'シェアボタンが表示され、クリックすると別タブでFacebook画面に遷移すること' do
        expect(page).to have_css '.fb-share-button'
        facebook_window = window_opened_by do
          find('.fb-share-button').click
        end
        within_window facebook_window do
          expect(page).to have_content 'Facebook'
        end
      end
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

      it 'タイトルが正しく表示されること' do
        expect(page).to have_title '施設の一覧 - Baby_Go'
      end

      context 'エリア検索・キーワード検索をしていないとき' do
        it '全ての施設情報が表示されていること' do
          within '.store-2' do
            expect(page).to have_selector('img[alt=施設画像-2]')
            expect(page).to have_selector '.card-title', text: 'あかちゃん本舗'
            expect(page).to have_css ".favorite-#{store1.id}"
            expect(page).to have_selector '.favorite-count', text: '0'
            expect(page).to have_css '.review-average-rating'
            expect(page).to have_selector '.reviews-average-score', text: '0.0'
            expect(page).to have_selector '.reviews-count', text: '0'
            expect(page).to have_content '綺麗な授乳室でした'
            expect(page).to have_content '北海道'
            expect(page).to have_link 'shumpei'
          end

          within '.store-1' do
            expect(page).to have_selector('img[alt=施設画像-1]')
            expect(page).to have_selector '.card-title', text: 'ベビーレストラン'
            expect(page).to have_css ".favorite-#{store2.id}"
            expect(page).to have_selector '.favorite-count', text: '0'
            expect(page).to have_css '.review-average-rating'
            expect(page).to have_selector '.reviews-average-score', text: '0.0'
            expect(page).to have_selector '.reviews-count', text: '0'
            expect(page).to have_content '個室の和室があって赤ちゃんと一緒でもゆっくりできました'
            expect(page).to have_content '沖縄県'
            expect(page).to have_link 'ちはるちゃんママ'
          end
          expect(page).to have_selector('.store-card', count: 2)
        end
      end

      context 'エリア検索・キーワード検索をしているとき' do
        context '検索に該当する施設が登録されているとき' do
          it '該当する施設情報のみ表示されていること' do
            fill_in 'q[prefecture_code_or_city_cont]', with: '北海道'
            click_button '検索'
            expect(page).to have_selector('img[alt=施設画像-1]')
            expect(page).to have_selector '.card-title', text: 'あかちゃん本舗'
            expect(page).to have_css ".favorite-#{store1.id}"
            expect(page).to have_selector '.favorite-count', text: '0'
            expect(page).to have_css '.review-average-rating'
            expect(page).to have_selector '.reviews-average-score', text: '0.0'
            expect(page).to have_selector '.reviews-count', text: '0'
            expect(page).to have_content '綺麗な授乳室でした'
            expect(page).to have_content '北海道'
            expect(page).to have_link 'shumpei'
            expect(page).to_not have_content 'ベビーレストラン'

            visit stores_path
            fill_in 'q[name_or_introduction_cont]', with: '和室'
            click_button '検索'
            expect(page).to have_selector('img[alt=施設画像-1]')
            expect(page).to have_selector '.card-title', text: 'ベビーレストラン'
            expect(page).to have_css ".favorite-#{store2.id}"
            expect(page).to have_selector '.favorite-count', text: '0'
            expect(page).to have_css '.review-average-rating'
            expect(page).to have_selector '.reviews-average-score', text: '0.0'
            expect(page).to have_selector '.reviews-count', text: '0'
            expect(page).to have_content '個室の和室があって赤ちゃんと一緒でもゆっくりできました'
            expect(page).to have_content '沖縄県'
            expect(page).to have_link 'ちはるちゃんママ'
            expect(page).to_not have_content 'あかちゃん本舗'
          end
        end

        context '検索に該当する施設が登録されていないとき' do
          it 'コメントと施設登録のリンクが表示されること' do
            fill_in 'q[prefecture_code_or_city_cont]', with: 'アメリカ合衆国'
            click_button '検索'
            expect(page).to have_selector('.store-card', count: 0)
            expect(page).to have_content '入力されたエリア・キーワードに該当する施設は見つかりませんでした！'
            expect(page).to have_link '施設の投稿はこちら'

            visit stores_path
            fill_in 'q[name_or_introduction_cont]', with: 'おむつ交換スペース'
            click_button '検索'
            expect(page).to have_selector('.store-card', count: 0)
            expect(page).to have_content '入力されたエリア・キーワードに該当する施設は見つかりませんでした！'
            expect(page).to have_link '施設の投稿はこちら'
          end
        end
      end

      it '施設画像をクリックすると施設詳細画面にページ遷移すること' do
        click_link '施設画像-1'
        expect(page).to have_current_path(store_path(store2))
        expect(page).to have_selector 'h1', text: 'ベビーレストラン'
      end

      it 'コメントアイコンをクリックすると施設詳細画面にページ遷移すること' do
        within '.store-1' do
          find('.comment-link').click
        end
        expect(page).to have_current_path(store_path(store2))
        expect(page).to have_selector 'h1', text: 'ベビーレストラン'
      end

      it 'ユーザー名をクリックするとユーザーの詳細画面に遷移すること' do
        click_link 'ちはるちゃんママ'
        expect(page).to have_current_path(user_path(user2))
        expect(page).to have_selector '.card-title', text: 'ちはるちゃんママ'
      end

      describe 'いいね機能のテスト', js: true do
        context 'ログインしているとき' do
          it '.favorite-store.idをクリックするといいねをつけたり削除したりできること' do
            sign_in(user1)
            visit stores_path
            expect(page).to have_selector 'h1', text: 'みんなが投稿してくれた施設の一覧'
            within '.store-2' do
              expect(page).to have_selector '.favorite-count', text: '0'
              expect {
                find(".favorite-#{store1.id}").click
                expect(page).to have_css ".favorited-#{store1.id}"
                expect(page).to have_selector '.favorite-count', text: '1'
              }.to change(Favorite, :count).by(1)

              expect {
                find(".favorited-#{store1.id}").click
                expect(page).to have_css ".favorite-#{store1.id}"
                expect(page).to have_selector '.favorite-count', text: '0'
              }.to change(Favorite, :count).by(-1)
            end
          end
        end

        context 'ログインしていないとき' do
          it '.favorite-store.idをクリックするとログインページに遷移すること' do
            visit stores_path
            within '.store-2' do
              find(".favorite-#{store1.id}").click
            end
            expect(page).to have_current_path(new_user_session_path)
            expect(page).to have_selector '.alert-alert', text: 'ログインもしくはアカウント登録してください'
          end
        end
      end
    end

    describe 'ページネーションのテスト' do
      context '施設情報が12個登録されているとき' do
        let!(:stores) {
          create_list(:store, 12, name: 'あかちゃん本舗', introduction: '綺麗な授乳室でした', postcode: '1111111',
                                  prefecture_code: '北海道', user: user1)
        }

        before do
          visit stores_path
        end

        it '.store-cardが12個表示されていること' do
          expect(page).to have_selector('.store-card', count: 12)
        end

        it 'ページネーションリンクが表示されていないこと' do
          expect(page).to_not have_css '.pagination'
        end
      end

      context '施設情報が13個登録されているとき' do
        let!(:stores) {
          create_list(:store, 13, name: 'あかちゃん本舗', introduction: '綺麗な授乳室でした', postcode: '1111111',
                                  prefecture_code: '北海道', user: user1)
        }

        before do
          visit stores_path
        end

        it 'ページネーションが2つ表示され2ページ目をクリックすると次ページに遷移すること', js: true do
          expect(page).to have_css '.pagination', count: 2
          expect(page).to have_selector '.pagination-count', text: "1-12\n/13件中"
          expect(page).to have_css '.store-card', count: 12
          within '.paginate-1' do
            click_link '2'
          end
          expect(page).to have_css '.pagination', count: 2
          expect(page).to have_selector '.pagination-count', text: "13-13\n/13件中"
          expect(page).to have_css '.store-card', count: 1
        end
      end
    end

    describe 'スクロールボタンのテスト', js: true do
      let!(:stores) {
        create_list(:store, 10, :rated1, name: 'あかちゃん本舗', introduction: '綺麗な授乳室でした', postcode: '1111111',
                                         prefecture_code: '北海道', user: user1)
      }

      context '画面横幅が767px以下のとき' do
        before do
          visit stores_path
          Capybara.current_session.driver.browser.manage.window.resize_to(767, 1200)
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

      context '画面横幅が768px以上のとき' do
        before do
          visit stores_path
          Capybara.current_session.driver.browser.manage.window.resize_to(768, 1200)
        end

        it '画面スクロールが500px以下でも501px以上でもscrollボタンが表示されないこと' do
          expect(find('#back', visible: false)).to_not be_visible
          page.execute_script('window.scroll(0, 500)')
          sleep 1
          expect(find('#back', visible: false)).to_not be_visible
          scrolly = page.evaluate_script('window.pageYOffset')
          expect(scrolly).to eq(500)

          expect(find('#back', visible: false)).to_not be_visible
          page.execute_script('window.scroll(0, 501)')
          sleep 1
          expect(find('#back', visible: false)).to_not be_visible
          scrolly = page.evaluate_script('window.pageYOffset')
          expect(scrolly).to eq(501)
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
          expect(page).to have_selector 'h1', text: 'あかちゃん本舗'
          expect(page).to have_selector 'td', text: '綺麗な授乳室でした'
          expect(page).to have_selector 'td', text: '1111111'
          expect(page).to have_selector 'td', text: '北海道'
          expect(page).to have_selector 'td', text: '函館市1-1-1'
          expect(page).to have_selector 'td', text: 'https://stores.akachan.jp/224'
          expect(page).to have_selector("img[src$='thumb_default_store.jpeg']")
          click_link '編集'
        end

        it 'タイトルが正しく表示されること' do
          expect(page).to have_title '施設の編集 - Baby_Go'
        end

        it '郵便番号を編集すると都道府県と市区町村番地が自動で修正されること', js: true do
          fill_in '郵便番号', with: '1000001'
          expect(page).to have_select('都道府県', selected: '東京都')
          expect(page).to have_field '市区町村番地', with: '千代田区千代田'
        end

        it '施設紹介フォームの残り文字数が入力文字数に連動して変化すること', js: true do
          expect(page).to have_selector '.js-text-count', text: '残り140文字'
          fill_in '施設の紹介', with: 'a' * 140
          expect(page).to have_selector '.js-text-count', text: '残り0文字'
          fill_in '施設の紹介', with: 'a' * 150
          expect(page).to have_selector '.js-text-count', text: '残り-10文字'
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
            expect(page).to have_current_path(store_path(store))
            expect(page).to have_content '施設の情報を更新しました'
            expect(page).to have_selector 'h1', text: '東松屋'
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
            expect(page).to have_selector 'h1', text: 'あかちゃん本舗'
          end
        end
      end

      context 'current_userと@store.userが等しくないとき' do
        let(:other_user) { create(:user) }

        it '編集ボタンが表示されないこと' do
          sign_in(other_user)
          visit store_path(store)
          expect(page).to have_current_path(store_path(store))
          expect(page).to_not have_link '編集'
        end
      end
    end

    context 'ログインしていないとき' do
      it '編集ボタンが表示されないこと' do
        visit store_path(store)
        expect(page).to have_current_path(store_path(store))
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
              click_link '施設情報を削除'
            end
            expect(page).to have_selector '.alert-success', text: '施設を削除しました'
            expect(page).to have_current_path(user_path(user))
          }.to change(Store, :count).by(-1)
        end
      end

      context 'current_userと@store.userが等しくないとき' do
        let(:other_user) { create(:user) }

        it '施設削除ボタンが表示されないこと' do
          sign_in(other_user)
          visit store_path(store)
          expect(page).to have_current_path(store_path(store))
          expect(page).to_not have_link '施設情報を削除'
        end
      end
    end

    context 'ログインしていないとき' do
      it '施設削除ボタンが表示されないこと' do
        visit store_path(store)
        expect(page).to have_current_path(store_path(store))
        expect(page).to_not have_link '施設情報を削除'
      end
    end
  end

  describe '施設オプション選択のテスト' do
    let(:user) { create(:user, name: 'shumpei', email: 'shumpei@example.com') }
    let(:store) {
      create(:store, :add_option, name: '東松屋', introduction: '綺麗で広くて使いやすい授乳室がありました', postcode: '1000001',
                                  prefecture_code: '東京都', city: '千代田区千代田１', user: user)
    }

    it '施設作成時にチェックしたオプションのみ詳細ページで◎が表示され、編集ページから編集ができること' do
      sign_in(user)
      visit new_store_path
      expect {
        fill_in '名前',	with: '東松屋'
        fill_in '施設の紹介',	with: '綺麗で広くて使いやすい授乳室がありました'
        fill_in '郵便番号',	with: '1000001'
        select '東京都', from: '都道府県'
        fill_in '市区町村番地',	with: '千代田区千代田１'
        fill_in 'URL',	with: 'https://github.com/shumpei116'
        attach_file 'store[image]', Rails.root.join('spec/factories/image/valid_image.jpg')
        check 'store[nursing_room]'
        check 'store[tatami_room]'
        click_button '施設を登録する'
        expect(page).to have_selector '.alert-success', text: '施設を登録したよ！ありがとう！'
      }.to change(Store, :count).by(1)
      expect have_content '授乳室: ◎'
      expect have_content 'おむつ交換スペース: ×'
      expect have_content 'お湯: ×'
      expect have_content 'ベビーカー貸出: ×'
      expect have_content 'キッズスペース: ×'
      expect have_content 'スペース広々: ×'
      expect have_content '身長体重計: ×'
      expect have_content '電子レンジ: ×'
      expect have_content 'シンク・洗面台: ×'
      expect have_content 'ベビーチェアー付きトイレ: ×'
      expect have_content 'たたみのお部屋: ◎'
      expect have_content '個室: ×'
      expect have_content '離乳食持ち込み: ×'
      expect have_content 'ベビーカーで入店: ×'
      expect have_content 'ベビーチェアー: ×'

      click_link '編集'
      check 'store[nursing_room]'
      check 'store[hot_water]'
      check 'store[baby_chair]'
      click_button '更新する'
      expect have_content '授乳室: ×'
      expect have_content 'おむつ交換スペース: ×'
      expect have_content 'お湯: ◎'
      expect have_content 'ベビーカー貸出: ×'
      expect have_content 'キッズスペース: ×'
      expect have_content 'スペース広々: ×'
      expect have_content '身長体重計: ×'
      expect have_content '電子レンジ: ×'
      expect have_content 'シンク・洗面台: ×'
      expect have_content 'ベビーチェアー付きトイレ: ×'
      expect have_content 'たたみのお部屋: ◎'
      expect have_content '個室: ×'
      expect have_content '離乳食持ち込み: ×'
      expect have_content 'ベビーカーで入店: ×'
      expect have_content 'ベビーチェアー: ◎'
    end
  end
end
