class HomesController < ApplicationController
  MAX_RANK_STORE_COUNT = 3
  def top
    @stores = Store.all
    gon.stores = @stores
    @rank_store = Store.average_score_rank.take(MAX_RANK_STORE_COUNT)
  end
end
