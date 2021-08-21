class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_current_user_review, only: %i[edit update destroy]
  before_action :exclude_empty_review, only: %i[edit update destroy]

  def create
    @review = current_user.reviews.build(review_params)
    if @review.save
      flash[:success] = 'レビューが投稿されました！'
      redirect_to store_path(@review.store)
    else
      @store = Store.find(params[:store_id])
      @reviews = @store.reviews
      render 'stores/show'
    end
  end

  def edit
  end

  def update
    if @review.update(review_params)
      flash[:success] = 'レビューを修正しました！'
      redirect_to store_path(@review.store)
    else
      render 'edit'
    end
  end

  def destroy
    @review.destroy
    flash[:success] = 'レビューを削除しました'
    redirect_to store_path(@review.store)
  end

  private

  def review_params
    params.require(:review).permit(:store_id, :rating, :comment)
  end

  def find_current_user_review
    @review = current_user.reviews.find_by(store_id: params[:store_id])
  end

  def exclude_empty_review
    redirect_to stores_path, alert: '無効な操作です' unless @review
  end
end
