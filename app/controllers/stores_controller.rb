class StoresController < ApplicationController
  before_action :find_store, only: %i[show edit update destroy]
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :correct_user, only: %i[edit update destroy]

  def index
    @stores = Store.all
  end

  def show
  end

  def new
    @store = @user.stores.build
  end

  def create
    @store = @user.stores.build(store_params)
  end

  def edit
  end

  def update
    if @store.update(store_params)
      flash[:success] = '施設の情報を更新しました'
      redirect_to @store
    else
      render 'edit'
    end
  end

  def destroy
    @store.destroy
    flash[:success] = '施設を削除しました'
    redirect_to user_path(current_user)
  end

  private

  def store_params
    params.require(:store).premit(:name, :introduction, :postcode, :prefecture_code, :city, :url)
  end

  def find_store
    @store = Store.find(pramas: [:id])
  end

  def correct_user
    redirect_to(root_url) unless @user == current_user
  end
end
