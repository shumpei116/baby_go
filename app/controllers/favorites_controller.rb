class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_store

  def create
    @favorite = current_user.favorites.create(store_id: @store.id)
    @store.reload
  end

  def destroy
    @favorite = current_user.favorites.find_by(store_id: @store.id)
    @favorite.destroy
    @store.reload
  end

  private

  def find_store
    @store = Store.find(params[:store_id])
  end
end
