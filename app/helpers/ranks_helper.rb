module RanksHelper
  def check_and_show_rank(stores, store)
    ranking = stores.index(store) + 1

    if ranking >= 1 && ranking <= 3
      image_pack_tag("media/images/home_rank_#{ranking}.png", size: '130x80', alt: "ランキング#{ranking}位画像")
    else
      "第#{ranking}位"
    end
  end
end
