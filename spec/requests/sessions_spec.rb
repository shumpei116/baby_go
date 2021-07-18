require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET new" do
    it "200レスポンスが返ってくること" do
      get new_user_session_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET create" do
    let! (:user) { create(:user, name: "shumpei", email: "shumpei@example.com", password: "password") }

    context "パラメーターが正しいとき" do
      before do
        post user_session_path, params: { user: { email: "shumpei@example.com", password: "password" } }
      end

      it "302レスポンスが返ってくること" do
        expect(response).to have_http_status(302)
      end

      it "トップページにリダイレクトされること" do
        expect(response).to redirect_to(root_url)
      end
    end

    context "パラメーターが正しくないとき" do
      before do
        post user_session_path, params: { user: { email: "masato@example.com", password: "password" } }
      end

      it '200レスポンスが返ってくること' do
        expect(response).to have_http_status(200)
      end

      it 'エラーが表示されること' do
        expect(response.body).to include 'メールアドレスまたはパスワードが違います。'
      end
    end
  end

  describe "GET destroy" do
    let! (:user) { create(:user, name: "shumpei", email: "shumpei@example.com", password: "password") }

    before do
      delete destroy_user_session_path
    end

    it '302レスポンスが返ってくること' do
      expect(response).to have_http_status(302)
    end

    it 'トップページにリダイレクトすること' do
      expect(response).to redirect_to(root_url)
    end
  end
end
