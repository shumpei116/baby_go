class RanksController < ApplicationController
  def index
    @rank_stores = Store.average_score_rank
    @stores = Kaminari.paginate_array(@rank_stores).page(params[:rank_page]).per(10)
  end
end
