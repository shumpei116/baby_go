class RanksController < ApplicationController
  before_action :set_q

  def index
    @rank_stores = @q.result.average_score_rank
    @stores = Kaminari.paginate_array(@rank_stores).page(params[:rank_page]).per(10)
  end

  private

  def set_q
    @q = Store.ransack(params[:q])
  end
end
