class RanksController < ApplicationController
  def index
    @rank_stores = Kaminari.paginate_array(Store.average_score_rank).page(params[:rank_page]).per(10)
  end
end
