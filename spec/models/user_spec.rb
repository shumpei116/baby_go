require 'rails_helper'

RSpec.describe User, type: :model do
  it "名前、メールアドレス、パスワードがあれば有効であること" do
    user = build(:user, name: "shumpei", email: "shumpei@example.com", password: "password") 
    expect(user).to be_valid
  end

  describe "名前のテスト" do
    it "名前がないときは無効であること" do
      user = build(:user, name: nil) 
      user.valid?
      expect(user.errors[:name]).to include("が入力されていません")
    end

    context "20文字以下の時" do
      it "有効であること" do
        user = build(:user, name: "a" * 20) 
        expect(user).to be_valid
      end
    end

    context "21文字以上の時" do
      it "無効であること" do
        user = build(:user, name: "a" * 21) 
        user.valid?
        expect(user.errors[:name]).to include("は20文字以下に設定して下さい")
      end
    end
  end

  describe "メールアドレスのテスト" do
    it "メールアドレスがない時は無効であること" do
      user = build(:user, email: nil) 
      user.valid?
      expect(user.errors[:email]).to include("が入力されていません")
    end
  
    it "重複したメールアドレスは無効であること" do
      create(:user, email: "shumpei@example.com")
      user = build(:user, email: "shumpei@example.com") 
      user.valid?
      expect(user.errors[:email]).to include("は既に使用されています")
    end
  
    it "保存時に小文字に変換されること" do
      user = create(:user, email: "SHUMPEI@EXAMPLE.COM")
      expect(user.email).to eq "shumpei@example.com"
    end

    context "255文字以下の時" do
      it "有効であること" do
        user = build(:user, email: "a" * 243 + "@example.com") 
        expect(user).to be_valid
      end
    end

    context "256文字以上の時" do
      it "無効であること" do
        user = build(:user, email: "a" * 244 + "@example.com") 
        user.valid?
        expect(user.errors[:email]).to include("は255文字以下に設定して下さい")
      end
    end

    context "正しいフォーマットのとき" do
      it "有効であること" do
        valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
          first.last@foo.jp alice+bob@baz.cn]
        valid_addresses.each do |valid_address|
        user = build(:user, email: valid_address)
        expect(user).to be_valid
        end
      end
    end

    context "正しくないフォーマットのとき" do
      it "無効であること" do
        invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
          foo@bar_baz.com foo@bar+baz.com foo@bar..com]
        invalid_addresses.each do |invalid_address|
        user = build(:user, email: invalid_address)
        user.valid?
        expect(user.errors[:email]).to include("は有効でありません")
        end
      end
    end
  end

  describe "パスワードのテスト" do
    it "パスワードがないときは無効であること" do
      user = build(:user, password: nil) 
      user.valid?
      expect(user.errors[:password]).to include("が入力されていません")
    end

    it "パスワードとパスワードコンファメーションが一致しないときは無効であること" do
      user = build(:user, password: "password", password_confirmation: "111111")
      user.valid?
      expect(user.errors[:password_confirmation]).to include("が間違っています")
    end

    context "6文字以上の時" do
      it "有効であること" do
        user = build(:user, password: "a" * 6, password_confirmation: "a" * 6)
        expect(user).to be_valid
      end
    end

    context "6文字以下の時" do
      it "無効であること" do
        user = build(:user, password: "a" * 5, password_confirmation: "a" * 5)
        user.valid?
        expect(user.errors[:password]).to include("は6文字以上に設定して下さい")
      end
    end

    context "128文字以下の時" do
      it "有効であること" do
        user = build(:user, password: "a" * 128, password_confirmation: "a" * 128)
        expect(user).to be_valid
      end
    end

    context "129文字以上の時" do
      it "無効であること" do
        user = build(:user, password: "a" * 129, password_confirmation: "a" * 129)
        user.valid?
        expect(user.errors[:password]).to include("は128文字以下に設定して下さい")
      end
    end
  end
end
