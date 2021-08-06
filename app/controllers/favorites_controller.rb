class FavoritesController < ApplicationController
  def create
    @favorite = current_user.favorites.create(store_id: params[:store_id])
  end

  def destroy
    @favorite = current_user.favorites.find_by(store_id: params[:store_id])
    @favorite.destroy
  end
end
