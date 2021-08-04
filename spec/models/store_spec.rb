require 'rails_helper'

RSpec.describe Store, type: :model do
  it 'パラメータが全て正しいとき有効であること' do
    store = build(:store)
    expect(store).to be_valid
  end

  describe '施設名のテスト' do
    it '名前がないときは無効であること' do
      store = build(:store, name: nil)
      store.valid?
      expect(store.errors[:name]).to include('が入力されていません')
    end

    context '20文字以下の時' do
      it '有効であること' do
        store = build(:store, name: 'a' * 20)
        expect(store).to be_valid
      end
    end

    context '21文字以上の時' do
      it '無効であること' do
        store = build(:store, name: 'a' * 21)
        store.valid?
        expect(store.errors[:name]).to include('は20文字以下に設定して下さい')
      end
    end
  end

  describe '施設紹介のテスト' do
    it '施設の紹介がない時は無効であること' do
      store = build(:store, introduction: nil)
      store.valid?
      expect(store.errors[:introduction]).to include('が入力されていません')
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
        expect(store.errors[:introduction]).to include('は140文字以下に設定して下さい')
      end
    end
  end

  describe '郵便番号のテスト' do
    it '郵便番号が未入力の時は無効であること' do
      store = build(:store, postcode: nil)
      store.valid?
      expect(store.errors[:postcode]).to include('が入力されていません')
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
      expect(store.errors[:prefecture_code]).to include('が入力されていません')
    end
  end

  describe '市区町村番地のテスト' do
    it '地区町村番地が未入力の時は無効であること' do
      store = build(:store, city: nil)
      store.valid?
      expect(store.errors[:city]).to include('が入力されていません')
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
end
