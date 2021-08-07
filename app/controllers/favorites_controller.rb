class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_store

  def create
    @favorite = current_user.favorites.create(store_id: @store.id)
  end

  def destroy
    @favorite = current_user.favorites.find_by(store_id: @store.id)
    @favorite.destroy
  end

  private

  def find_store
    @store = Store.find(params[:store_id])
  end
end
