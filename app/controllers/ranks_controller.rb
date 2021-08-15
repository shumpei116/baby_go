class RanksController < ApplicationController
  def index
    rank_stores = Store.left_joins(:reviews).includes(:reviews).distinct.sort_by(&:average_rating)
                       .reverse

    @rank_stores = Kaminari.paginate_array(rank_stores).page(params[:rank_page]).per(10)
  end
end
