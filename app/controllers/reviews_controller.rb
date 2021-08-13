class ReviewsController < ApplicationController
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
    @review = Review.find(params[:id])
  end

  def update
    @review = Review.find(params[:id])
    if @review.update(review_params)
      flash[:success] = 'レビューを修正しました！'
      redirect_to store_path(@review.store)
    else
      render 'edit'
    end
  end

  def destroy
  end

  private

  def review_params
    params.require(:review).permit(:store_id, :user_id, :rating, :comment)
  end
end
