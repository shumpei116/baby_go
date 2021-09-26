class StoresController < ApplicationController
  before_action :find_store, only: %i[show edit update destroy]
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :correct_user, only: %i[edit update destroy]
  before_action :set_q, only: :index

  def index
    @stores = @q.result.order(created_at: :desc).page(params[:page]).per(12).includes(:user, :reviews)
  end

  def show
    @review = current_user.reviews.build if current_user
    @reviews = @store.reviews.order(created_at: :desc).page(params[:page]).per(5).includes(:user)
    gon.store = @store
  end

  def new
    @store = current_user.stores.build
  end

  def create
    @store = current_user.stores.build(store_params)
    if @store.save
      flash[:success] = '施設を登録したよ！ありがとう！'
      redirect_to store_path(@store)
    else
      render 'new'
    end
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
    params.require(:store).permit(:name, :introduction, :postcode, :prefecture_code, :city, :url, :image, :image_cache,
                                  :remove_image, :nursing_room, :diaper_changing_area, :hot_water, :stroller_rental,
                                  :kids_space, :large_space, :height_and_weight_scales, :microwave_oven, :basin,
                                  :toilet_with_baby_chair, :tatami_room, :private_room, :baby_food, :stroller_access,
                                  :baby_chair)
  end

  def find_store
    @store = Store.find(params[:id])
  end

  def correct_user
    return if @store.user == current_user

    flash[:alert] = '無効な操作です'
    redirect_to root_url
  end

  def set_q
    @q = Store.ransack(params[:q])
  end
end
