require 'rails_helper'

RSpec.describe Store, type: :model do
  it 'パラメータが全て正しいとき有効であること' do
    store = build(:store)
    expect(store).to be_valid
  end

  describe 'ユーザーIDのテスト' do
    it '名前がないときは無効であること' do
      store = build(:store, user_id: nil)
      store.valid?
      expect(store.errors[:user_id]).to include('を入力してください')
    end
  end

  describe '施設名のテスト' do
    it '名前がないときは無効であること' do
      store = build(:store, name: nil)
      store.valid?
      expect(store.errors[:name]).to include('を入力してね')
    end

    context '50文字以下の時' do
      it '有効であること' do
        store = build(:store, name: 'a' * 50)
        expect(store).to be_valid
      end
    end

    context '51文字以上の時' do
      it '無効であること' do
        store = build(:store, name: 'a' * 51)
        store.valid?
        expect(store.errors[:name]).to include('は50文字以内で入力してね')
      end
    end
  end

  describe '施設紹介のテスト' do
    it '施設の紹介がない時は無効であること' do
      store = build(:store, introduction: nil)
      store.valid?
      expect(store.errors[:introduction]).to include('を入力してね')
    end

    context '140文字以下の時' do
      it '有効であること' do
        store = build(:store, introduction: ('a' * 140).to_s)
        expect(store).to be_valid
      end
    end

    context '141文字以上の時' do
      it '無効であること' do
        store = build(:store, introduction: ('a' * 141).to_s)
        store.valid?
        expect(store.errors[:introduction]).to include('は140文字以内で入力してね')
      end
    end
  end

  describe '郵便番号のテスト' do
    it '郵便番号が未入力の時は無効であること' do
      store = build(:store, postcode: nil)
      store.valid?
      expect(store.errors[:postcode]).to include('を入力してね')
    end

    context '正しいフォーマットのとき' do
      it '有効であること' do
        valid_postcodes = %w[1234567 2222222 9000000]
        valid_postcodes.each do |valid_postcode|
          store = build(:store, postcode: valid_postcode)
          expect(store).to be_valid
        end
      end
    end

    context '正しくないフォーマットのとき' do
      it '無効であること' do
        invalid_postcodes = %w[123456 12345678 111-1111]
        invalid_postcodes.each do |invalid_postcode|
          store = build(:store, postcode: invalid_postcode)
          store.valid?
          expect(store.errors[:postcode]).to include('は有効でありません')
        end
      end
    end
  end

  describe '都道府県番号のテスト' do
    it '都道府県番号が未入力の時は無効であること' do
      store = build(:store, prefecture_code: nil)
      store.valid?
      expect(store.errors[:prefecture_code]).to include('を入力してね')
    end
  end

  describe '市区町村番地のテスト' do
    it '地区町村番地が未入力の時は無効であること' do
      store = build(:store, city: nil)
      store.valid?
      expect(store.errors[:city]).to include('を入力してね')
    end

    it '重複した市区町村番地は無効であること' do
      create(:store, city: 'ひたちなか市新光町35')
      store = build(:store, city: 'ひたちなか市新光町35')
      store.valid?
      expect(store.errors[:city]).to include('は既に使用されています')
    end
  end

  describe '施設参考URLのテスト' do
    context '正しいフォーマットのとき' do
      it '有効であること' do
        valid_urls = %w[http://hogehoge.examplecom http://hogehoge.example.com https://WorlD.examPle.com/hoge/foobar https://hogehoge.example.com/seach?q=%$_/.,¥=[]]
        valid_urls.each do |valid_url|
          store = build(:store, url: valid_url)
          expect(store).to be_valid
        end
      end
    end

    context '正しくないフォーマットのとき' do
      it '無効であること' do
        invalid_urls = %w[http:://hogehoge.examplecom htt://hogehoge.example.com htps://WorlD.examPle.com/hoge/foobar
                          hogehoge.example.com]
        invalid_urls.each do |invalid_url|
          store = build(:store, url: invalid_url)
          store.valid?
          expect(store.errors[:url]).to include('は有効でありません')
        end
      end
    end
  end

  describe '施設画像のテスト' do
    context '正しいフォーマットのとき' do
      it '有効であること' do
        store = build(:store, image: File.open(Rails.root.join('spec/factories/image/valid_image.jpg')))
        expect(store).to be_valid
      end
    end

    context '正しくないフォーマットのとき' do
      it '無効であること' do
        store = build(:store, image: File.open(Rails.root.join('spec/factories/image/invalid_image.txt')))
        store.valid?
        expect(store.errors[:image]).to include('"txt"ファイルのアップロードは許可されていません。アップロードできるファイルタイプ: jpg, jpeg, gif, png')
      end
    end

    context '5.0MB以下の画像がアップロードされたとき' do
      it '有効であること' do
        store = build(:store, image: File.open(Rails.root.join('spec/factories/image/5MB_image.jpg')))
        expect(store).to be_valid
      end
    end

    context '5.0MBより大きな画像がアップロードされたとき' do
      it '無効であること' do
        store = build(:store, image: File.open(Rails.root.join('spec/factories/image/6MB_image.jpg')))
        store.valid?
        expect(store.errors[:image]).to include('を5MB以下のサイズにしてください')
      end
    end
  end

  describe 'favorites_countのテスト' do
    it '施設に関連したfavoriteの数をカウントすること' do
      store = create(:store)
      user = create(:user)
      store.favorites.create!(user: user)
      store.reload
      expect(store.favorites_count).to eq 1
    end
  end

  describe 'reviews_countのテスト' do
    it '施設に関連したreviewの数をカウントすること' do
      store = create(:store)
      user = create(:user)
      store.reviews.create!(user: user, rating: 3, comment: '確かにいいところでした！')
      store.reload
      expect(store.reviews_count).to eq 1
    end
  end

  describe 'favoriteモデルアソシエーションのテスト' do
    it '施設に関連したfavoriteが作成できること' do
      store = create(:store)
      user = create(:user)
      store.favorites.create!(user: user)
      expect(store.favorites.count).to eq 1
    end

    it '施設が削除されたら関連したfavoriteも削除されること' do
      store = create(:store)
      user = create(:user)
      store.favorites.create!(user: user)
      store.destroy
      expect(Favorite.count).to eq 0
    end
  end

  describe 'reviewモデルアソシエーションのテスト' do
    it '施設に関連したreviewが作成できること' do
      store = create(:store)
      user = create(:user)
      store.reviews.create!(user: user, rating: 3, comment: '確かにいいところでした！')
      expect(store.reviews.count).to eq 1
    end

    it '施設が削除されたら関連したreviewも削除されること' do
      store = create(:store)
      user = create(:user)
      store.reviews.create!(user: user, rating: 3, comment: '確かにいいところでした！')
      store.destroy
      expect(Review.count).to eq 0
    end
  end

  describe 'average_ratingメソッドのテスト' do
    let(:store) { create(:store) }

    context '施設のレビューがあるとき' do
      let!(:review1) { create(:review, store: store, rating: 2) }
      let!(:review2) { create(:review, store: store, rating: 3) }
      let!(:review3) { create(:review, store: store, rating: 4) }

      it '施設のレビュー平均点を返すこと' do
        expect(store.average_rating).to  eq 3
      end
    end

    context '施設のレビューがないとき' do
      it '0.0を返すこと' do
        expect(store.average_rating).to  eq 0.0
      end
    end
  end

  describe 'self.average_score_rankメソッドのテスト' do
    let!(:store1) { create(:store, :rated1) }
    let!(:store2) { create(:store, :rated2) }
    let!(:store3) { create(:store, :rated3) }

    it '全ての施設をレビュー平均点が高い順に並び替えた配列で返すこと' do
      average_stores = Store.average_score_rank
      expect(average_stores).to match [store1, store2, store3]
    end
  end

  describe 'addressメソッドのテスト' do
    it '都道府県と市町村番地を繋いだ住所を返すこと' do
      store = build(:store, prefecture_code: '東京都', city: '千代田区丸の内1-1-1')
      expect(store.address).to eq '東京都千代田区丸の内1-1-1'
    end
  end
end
