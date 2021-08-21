require 'rails_helper'

RSpec.describe Review, type: :model do
  it 'ユーザーIDと施設IDと点数と口コミがあれば有効なこと' do
    review = build(:review, rating: 3, comment: 'テストレビューです')
    expect(review).to be_valid
  end

  it 'ユーザーIDがない時は無効なこと' do
    review = build(:review, user: nil)
    review.valid?
    expect(review.errors[:user_id]).to include('を入力してください')
  end

  it '施設IDがない時は無効なこと' do
    # reviewファクトリーのuserはstoreに紐付いている為、userのみ別に作成する
    user = create(:user)
    review = build(:review, store: nil, user: user)
    review.valid?
    expect(review.errors[:store_id]).to include('を入力してください')
  end

  describe '点数のテスト' do
    it '点数がない時は無効なこと' do
      review = build(:review, rating: nil)
      review.valid?
      expect(review.errors[:rating]).to include('で点数をつけてね')
    end

    context '0.5以上のとき' do
      it '有効なこと' do
        review = build(:review, rating: 0.5)
        expect(review).to be_valid
      end
    end

    context '0.5未満のとき' do
      it '無効なこと' do
        review = build(:review, rating: 0.4)
        review.valid?
        expect(review.errors[:rating]).to include('は0.5以上の値にしてください')
      end
    end

    context '5以下のとき' do
      it '有効なこと' do
        review = build(:review, rating: 5)
        expect(review).to be_valid
      end
    end

    context '5より大きいとき' do
      it '無効なこと' do
        review = build(:review, rating: 5.1)
        review.valid?
        expect(review.errors[:rating]).to include('は5以下の値にしてください')
      end
    end
  end

  describe '口コミのテスト' do
    it '口コミがない時は無効なこと' do
      review = build(:review, comment: nil)
      review.valid?
      expect(review.errors[:comment]).to include('を入力してね')
    end

    context '140文字以下の時' do
      it '有効であること' do
        review = build(:review, comment: ('a' * 140))
        expect(review).to be_valid
      end
    end

    context '141文字以上の時' do
      it '無効であること' do
        review = build(:review, comment: ('a' * 141))
        review.valid?
        expect(review.errors[:comment]).to include('は140文字以内で入力してね')
      end
    end
  end

  it '重複したユーザーIDと施設IDの組み合わせの時は無効なこと' do
    store = create(:store)
    user = create(:user)
    create(:review, user: user, store: store)
    review = build(:review, user: user, store: store)
    review.valid?
    expect(review.errors[:store_id]).to include('はすでに存在します')
  end
end
