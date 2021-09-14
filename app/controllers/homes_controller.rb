class HomesController < ApplicationController
  MAX_RANK_STORE_COUNT = 3
  def top
    @rank_store = Store.average_score_rank.includes(:reviews, :user).limit(MAX_RANK_STORE_COUNT)
    @stores = Store.all
    gon.stores = @stores
  end
end
