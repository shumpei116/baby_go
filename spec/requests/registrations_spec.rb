require 'rails_helper'

RSpec.describe 'Registrations', type: :request do
  let(:user) { create(:user, name: 'chiaki', email: 'chiaki@example.com') }

  describe 'GET #new' do
    context 'ユーザーがログインしていないとき' do
      it '200レスポンスが返ってくること' do
        get new_user_registration_path
        expect(response).to have_http_status(200)
      end
    end

    context 'ユーザーがログイン済みのとき' do
      before do
        sign_in(user)
        get new_user_registration_path
      end
      it '302レスポンスが返ってくること' do
        expect(response).to have_http_status(302)
      end

      it 'トップページにリダイレクトされること' do
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe 'GET #create' do
    context 'パラメーターが正しいとき' do
      it '302レスポンスが返ってくること' do
        post user_registration_path, params: { user: attributes_for(:user) }
        expect(response).to have_http_status(302)
      end

      it 'ユーザーが登録されること' do
        expect {
          post user_registration_path, params: { user: attributes_for(:user) }
        }.to change(User, :count).by(1)
      end

      it 'トップページにリダイレクトされること' do
        post user_registration_path, params: { user: attributes_for(:user) }
        expect(response).to redirect_to(root_url)
      end
    end

    context 'パラメーターが正しくないとき' do
      it '200レスポンスが返ってくること' do
        post user_registration_path, params: { user: attributes_for(:user, :invalid_signup) }
        expect(response).to have_http_status(200)
      end

      it 'ユーザーが登録されないこと' do
        expect {
          post user_registration_path, params: { user: attributes_for(:user, :invalid_signup) }
        }.to_not change(User, :count)
      end

      it 'エラーが表示されること' do
        post user_registration_path, params: { user: attributes_for(:user, :invalid_signup) }
        expect(response.body).to include 'メールアドレスが入力されていません'
      end
    end
  end

  describe 'GET #edit' do
    context 'ユーザーがログインしていないとき' do
      before do
        get edit_user_registration_path
      end

      it '302レスポンスが返ってくること' do
        expect(response).to have_http_status(302)
      end

      it 'ログインページにリダイレクトされること' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'ユーザーがログイン済みのとき' do
      before do
        sign_in(user)
        get edit_user_registration_path
      end

      it '200レスポンスが返ってくること' do
        expect(response).to have_http_status(200)
      end

      it 'ユーザー名が表示されていること' do
        expect(response.body).to include 'chiaki'
      end

      it 'メールアドレスが表示されていること' do
        expect(response.body).to include 'chiaki@example.com'
      end
    end
  end

  describe 'GET #update' do
    before do
      sign_in(user)
    end

    context 'パラメータが正しいとき' do
      it '302レスポンスが返ってくること' do
        patch user_registration_path, params: { user: attributes_for(:user) }
        expect(response).to have_http_status(302)
      end

      it 'ユーザー名が更新されること' do
        expect {
          patch user_registration_path, params: { user: attributes_for(:user, name: 'chiharu') }
        }.to change { User.find(user.id).name }.from('chiaki').to('chiharu')
      end

      it 'ユーザー詳細画面にリダイレクトされること' do
        patch user_registration_path, params: { user: attributes_for(:user) }
        expect(response).to redirect_to(user_path(user))
      end
    end

    context 'パラメーターが正しくないとき' do
      it '200レスポンスが返ってくること' do
        patch user_registration_path, params: { user: attributes_for(:user, :invalid_signup) }
        expect(response).to have_http_status(200)
      end

      it 'ユーザー名が変更されないこと' do
        expect {
          patch user_registration_path, params: { user: attributes_for(:user, :invalid_signup) }
        }.to_not change(User.find(user.id), :name)
      end

      it 'エラーが表示されること' do
        patch user_registration_path, params: { user: attributes_for(:user, :invalid_signup) }
        expect(response.body).to include 'メールアドレスが入力されていません'
      end
    end
  end

  describe 'GET #destroy' do
    before do
      sign_in(user)
    end

    it '302レスポンスが返ってくること' do
      delete user_registration_path
      expect(response).to have_http_status(302)
    end

    it 'ユーザーが削除されること' do
      expect {
        delete user_registration_path
      }.to change(User, :count).by(-1)
    end

    it 'トップページにリダイレクトすること' do
      delete user_registration_path
      expect(response).to redirect_to(root_url)
    end
  end
end
