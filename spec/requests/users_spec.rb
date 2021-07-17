require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) {create(:user, name: "shumpei")}

  describe "GET #index" do
    it "200レスポンスが返ってくること" do
      get users_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #show" do
    context "ユーザーがログインしているとき" do
      before do
        sign_in(user)
        get user_path(user)
      end

      it "200レスポンスが返ってくること" do
        expect(response).to have_http_status(200)
      end

      it '名前が含まれていること' do
        expect(response.body).to include 'shumpei'
      end
    end

    context "ユーザーがログインしていないとき" do
      before do
        get user_path(user)
      end

      it "302レスポンスが返ってくること" do
        expect(response).to have_http_status(302)
      end

      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
