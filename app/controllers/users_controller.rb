class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @stores = @user.stores.order(created_at: :desc).page(params[:index_page]).per(8)
    @favorite_stores = @user.favorite_stores.order(created_at: :desc).page(params[:favorite_page]).per(8)
                            .includes(:user)
  end
end
