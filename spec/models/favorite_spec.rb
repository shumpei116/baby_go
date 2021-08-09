require 'rails_helper'

RSpec.describe Favorite, type: :model do
  let(:user) { create(:user) }
  let(:store) { create(:store) }

  it 'ユーザーIDと施設IDがあれば有効なこと' do
    favorite = build(:favorite, user: user, store: store)
    expect(favorite).to be_valid
  end

  it 'ユーザーIDがない時は無効なこと' do
    favorite = build(:favorite, user: nil, store: store)
    favorite.valid?
    expect(favorite.errors[:user_id]).to include('を入力してください')
  end

  it '施設IDがない時は無効なこと' do
    favorite = build(:favorite, user: user, store: nil)
    favorite.valid?
    expect(favorite.errors[:store_id]).to include('を入力してください')
  end

  it '重複したユーザーIDと施設IDの時は無効なこと' do
    create(:favorite, user: user, store: store)
    favorite = build(:favorite, user: user, store: store)
    favorite.valid?
    expect(favorite.errors[:store_id]).to include('はすでに存在します')
  end
end
